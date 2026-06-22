@_spi(Internal) import BrazeKit
import UIKit
@preconcurrency import WebKit

extension BrazeInAppMessageUI {

  /// The view for html in-app messages.
  ///
  /// The html view can be customized using the ``attributes-swift.property`` property.
  open class HtmlView: UIView, InAppMessageView {

    /// The html in-app message.
    public var message: Braze.InAppMessage.Html {
      get { messageWrapper.wrappedValue }
      set {
        messageWrapper.wrappedValue = newValue
      }
    }

    /// Internal wrapper for the html in-app message.
    let messageWrapper: StructWrapper<Braze.InAppMessage.Html>

    // MARK: - Attributes

    /// The attributes supported by the html in-app message view.
    ///
    /// Attributes can be updated in multiple ways:
    /// - Via modifying the ``defaults`` static property
    /// - Via implementing the ``BrazeInAppMessageUIDelegate/inAppMessage(_:prepareWith:)-11fog``
    ///   delegate.
    /// - Via modifying the ``BrazeInAppMessageUI/messageView`` attributes on the
    ///   `BrazeInAppMessageUI` instance.
    public struct Attributes: Sendable {

      /// The animation used to present the view.
      public var animation: Animation = .auto

      /// Specifies whether the web view should automatically track body clicks.
      ///
      /// - Important: Body clicks are always tracked for legacy html in-app messages (zip based).
      public var automaticBodyClicks: Bool = false

      /// Specifies whether the web view should support the `target` parameter / attribute in:
      /// - Anchor tags (e.g. `<a href="..." target="_blank">`).
      /// - Window opens (e.g. `window.open(url, "_blank")`).
      ///
      /// When set to true (default), the url marked with `target` is opened and the message
      /// remains visible.
      /// When set to false, the url marked with `target` is opened and the message is dismissed.
      ///
      /// Deeplinks (e.g. `customAppScheme://`) always dismiss the message.
      public var linkTargetSupport: Bool = true

      /// Specifies whether the web view should support the Web Inspector developer tool, if available.
      public var allowInspector: Bool = true

      /// Closure allowing customization of the configuration used by the web view.
      public var configure: (@MainActor @Sendable (WKWebViewConfiguration) -> Void)?

      /// Closure allowing further customization, executed when the view is about to be presented.
      public var onPresent: (@MainActor @Sendable (HtmlView) -> Void)?

      /// Closure executed every time the view is laid out.
      public var onLayout: (@MainActor @Sendable (HtmlView) -> Void)?

      /// Closure executed every time the view update its theme.
      public var onTheme: (@MainActor @Sendable (HtmlView) -> Void)?

      /// The defaults html view attributes.
      ///
      /// Modify this value directly to apply the customizations to all html in-app messages
      /// presented by the SDK.
      public static var defaults: Self {
        get { lock.sync { _defaults } }
        set { lock.sync { _defaults = newValue } }
      }
      nonisolated(unsafe) private static var _defaults = Self()

      /// The lock guarding the static properties.
      private static let lock = NSRecursiveLock()
    }

    /// The view attributes (see ``Attributes-swift.struct``).
    public let attributes: Attributes
    private let persistence: InAppMessagePersistenceProtocol
    private lazy var htmlRenderer: HtmlViewRenderer = HtmlViewRenderer(
      persistence: persistence,
      webViewProvider: { [weak self] in self?.webView },
      onFailure: { [weak self] error in self?.handleHtmlPersistenceError(error) }
    )

    // MARK: - Animation

    /// The presentation animations supported by the html in-app message view.
    public enum Animation: Sendable {

      /// The animation chosen is automatically by the view.
      ///
      /// - ``slide`` is used for legacy (zip-based) html in-app messages.
      /// - ``fade`` is used for html in-app messages with interactive preview on the dashboard.
      case auto

      /// The view fades-in when presented and fades-out when dismissed.
      case fade

      /// The view slides from the bottom of the screen when presented and slides back when
      /// dismissed.
      case slide

      func duration(legacy: Bool) -> TimeInterval {
        switch self {
        case .auto where legacy, .slide:
          return 0.4
        case .auto, .fade:
          return 0.25
        }
      }

      func initialAlpha(legacy: Bool) -> CGFloat {
        switch self {
        case .auto where legacy, .slide:
          return 1
        case .auto, .fade:
          return 0
        }
      }
    }

    // MARK: - WebView

    /// The web view used to display the message.
    ///
    /// This property can be used after ``present(completion:)`` was called.
    public var webView: WKWebView?

    public lazy var scriptMessageHandler: Braze.WebViewBridge.ScriptMessageHandler =
      webViewScriptMessageHandler()
    public lazy var schemeHandler: Braze.WebViewBridge.SchemeHandler = webViewSchemeHandler()
    public var queryHandler: Braze.WebViewBridge.QueryHandler {
      get {
        queryHandlerWrapper.wrappedValue
      }
      set {
        queryHandlerWrapper.wrappedValue = newValue
      }
    }

    lazy var queryHandlerWrapper: StructWrapper<Braze.WebViewBridge.QueryHandler> = .init(
      wrappedValue: webViewQueryHandler())

    // MARK: - LifeCycle

    public init(
      message: Braze.InAppMessage.Html,
      attributes: Attributes = .defaults,
      presented: Bool = false
    ) {
      self.messageWrapper = .init(wrappedValue: message)
      self.attributes = attributes
      self.presented = presented
      self.persistence = InAppMessagePersistenceQueueWriter()
      super.init(frame: .zero)

      registerForTraitChanges()
    }

    init(
      message: Braze.InAppMessage.Html,
      attributes: Attributes = .defaults,
      presented: Bool = false,
      persistence: InAppMessagePersistenceProtocol
    ) {
      self.messageWrapper = .init(wrappedValue: message)
      self.attributes = attributes
      self.presented = presented
      self.persistence = persistence
      super.init(frame: .zero)

      registerForTraitChanges()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    deinit {
      runOnMainActorIsolated { [self] in
        // Only capture scriptMessageHandler if webView exists (avoids initializing the lazy property
        // during deallocation when the web view was never set up)
        guard let webView else { return }
        webView.configuration.userContentController.removeBrazeBridge()
        scriptMessageHandler.clearRegistration()
      }
    }

    /// Removes the Braze bridge script and handler from the web view configuration (same as
    /// `deinit`). Call when the IAM context is torn down before deallocation (e.g. user switch) so
    /// WebKit stops posting to the bridge while the view may still be on screen.
    ///
    /// Also clears ``webView`` and removes it from this view so a later ``setupWebView()`` (e.g. when
    /// this ``HtmlView`` is cached and presented again) builds a new bridged ``WKWebView``. Without
    /// this, ``setupWebView()`` would early-return while the old web view was still embedded but
    /// unbridged.
    ///
    /// - Important: Must be called from the main thread; ``WKWebView`` / ``WKUserContentController``
    ///   are main-thread-only.
    @MainActor
    func detachWebViewBridge() {
      guard let webView else { return }
      webView.configuration.userContentController.removeBrazeBridge()
      scriptMessageHandler.clearRegistration()
      webView.removeFromSuperview()
      self.webView = nil
      resetPresentationLayoutStateForWebViewReplacement()
    }

    /// Clears one-shot presentation layout state so ``installPresentationConstraintsIfNeeded()`` can
    /// run again after the ``WKWebView`` is replaced (e.g. ``detachWebViewBridge()`` or stale rebuild
    /// in ``setupWebView()``).
    @MainActor
    private func resetPresentationLayoutStateForWebViewReplacement() {
      presentationConstraintsInstalled = false
      yConstraint = nil
    }

    // MARK: - Theme

    #if !os(visionOS)
      open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        attributes.onTheme?(self)
      }
    #endif

    /// Sets up the listener for trait changes on visionOS.
    func registerForTraitChanges() {
      #if os(visionOS)
        registerForTraitChanges([
          UITraitActiveAppearance.self
        ]) { (self: Self, _: UITraitCollection) in
          self.attributes.onTheme?(self)
        }
      #endif
    }

    // MARK: - Layout

    open var presentationConstraintsInstalled = false
    open var yConstraint: NSLayoutConstraint?

    open override func layoutSubviews() {
      super.layoutSubviews()
      installPresentationConstraintsIfNeeded()
      attributes.onLayout?(self)
    }

    open func installPresentationConstraintsIfNeeded() {
      guard let superview,
        webView?.superview != nil,
        !presentationConstraintsInstalled
      else {
        return
      }
      presentationConstraintsInstalled = true

      Constraints {
        anchors.edges.pin()

        webView?.anchors.edges.pin(axis: .horizontal)
        webView?.anchors.height.equal(anchors.height)

        switch attributes.animation {
        case .auto where message.legacy, .slide:
          yConstraint = webView?.anchors.top.pin()
          webView?.anchors.top.equal(anchors.bottom).priority = .defaultHigh
        case .auto, .fade:
          webView?.anchors.center.align()
          break
        }
      }

      yConstraint?.isActive = presented

      setNeedsLayout()
      superview.layoutIfNeeded()
    }

    // MARK: - Presentation / InAppMessageView conformance

    private var presentationCompletion: (() -> Void)?

    public var presented: Bool = false {
      didSet {
        switch attributes.animation {
        case .auto where message.legacy, .slide:
          yConstraint?.isActive = presented
        case .auto, .fade:
          webView?.alpha = presented ? 1 : 0
        }
      }
    }

    public func present(completion: (() -> Void)? = nil) {
      prefersStatusBarHidden = true
      addVoiceOverHook()

      setupWebView()
      installPresentationConstraintsIfNeeded()

      willPresent()
      attributes.onPresent?(self)

      UIView.performWithoutAnimation {
        superview?.layoutIfNeeded()
      }

      presentationCompletion = completion
      loadMessage()
    }

    public func dismiss(completion: (() -> Void)? = nil) {
      willDismiss()
      webView?.stopLoading()

      UIView.animate(
        withDuration: message.animateOut
          ? attributes.animation.duration(legacy: message.legacy)
          : 0,
        animations: {
          self.presented = false
          self.superview?.layoutIfNeeded()
        },
        completion: { _ in
          completion?()
          self.didDismiss()
        }
      )
    }

    // MARK: - Helpers

    /// Prepares the underlying `WKWebView` for this html in-app message.
    ///
    /// This method is invoked by ``present(completion:)`` and is responsible for creating and
    /// configuring the `WKWebView` the first time the view is presented, then reusing that same
    /// instance on subsequent presentations as long as it remains attached to this `HtmlView`.
    ///
    /// - Important: This API is `@MainActor` and must only be called from the main thread.
    ///
    /// When overriding this method, you should almost always call `super.setupWebView()` and
    /// avoid creating additional `WKWebView` instances or re-registering the Braze bridge on a
    /// different `WKUserContentController`. If the stored web view is no longer attached to this
    /// view, it will be removed, its bridge will be unregistered, and a new web view will be
    /// built to ensure the bridge and configuration remain valid across reuse.
    @MainActor
    open func setupWebView() {
      // A `WKScriptMessageHandler` instance may only be registered with one
      // `WKUserContentController` at a time. `present(completion:)` can run more than once on the
      // same `HtmlView` (e.g. re-presentation via `PresentationContext.customView`, or a cached
      // view after dismiss). Re-calling `forBrazeBridge` would register the same lazy
      // `scriptMessageHandler` again and trap inside WebKit (often reported as EXC_BREAKPOINT).
      // Match `BannerUIView.render(with:)` which only builds the web view once.
      //
      // Reuse only when the stored web view is still the one we attached to this view; otherwise
      // clear any stale/detached reference and build again (avoids skipping setup with a foreign
      // or orphaned `WKWebView`).
      if let existing = webView, existing.superview === self {
        return
      }

      if let stale = webView {
        stale.removeFromSuperview()
        stale.configuration.userContentController.removeBrazeBridge()
        scriptMessageHandler.clearRegistration()
        self.webView = nil
        resetPresentationLayoutStateForWebViewReplacement()
      }

      // Configuration
      let configuration = WKWebViewConfiguration.forBrazeBridge(
        scriptMessageHandler: scriptMessageHandler)

      // - Customization
      attributes.configure?(configuration)

      // WebView
      let webView = WKWebView(frame: .zero, configuration: configuration)
      webView.uiDelegate = self
      webView.navigationDelegate = self
      webView.allowsLinkPreview = false
      webView.scrollView.bounces = false
      webView.backgroundColor = .clear
      webView.isOpaque = false

      if #available(iOS 16.4, macOS 13.3, *) {
        webView.isInspectable = attributes.allowInspector
      }

      // Disable this optimization for mac catalyst (force webview in window bounds)
      #if !targetEnvironment(macCatalyst)
        // Make web view ignore the safe area allowing proper handling in html / css. See the usage
        // section at https://developer.mozilla.org/en-US/docs/Web/CSS/env() (archived version:
        // https://archive.is/EBSJD) for instructions.
        webView.scrollView.contentInsetAdjustmentBehavior = .never
      #endif
      webView.alpha = attributes.animation.initialAlpha(legacy: message.legacy)
      addSubview(webView)
      self.webView = webView
    }

    open func loadMessage() {
      // Ensure we have a writable base directory before attempting any disk IO.
      guard let baseURL = message.baseURL else {
        logError(.htmlNoBaseURL)
        messageWrapper.wrappedValue.animateOut = false
        dismiss()
        return
      }

      // Build a payload representing the HTML content and target directory on disk.
      let payload = HtmlViewRenderer.Payload(
        html: messageWrapper.wrappedValue.message,
        baseURL: baseURL,
        hasLocalAssets: !messageWrapper.wrappedValue.assetURLs.isEmpty
      )

      // Delegate to the renderer so it can persist the HTML off the main thread and load it when ready.
      htmlRenderer.update(
        with: InAppMessageContentStateFactory.html(
          message: messageWrapper.wrappedValue,
          baseURL: baseURL,
          traits: traitCollection
        ),
        payload: payload
      )
    }

    open func processNavigationAction(
      _ navigationAction: WKNavigationAction,
      isTransientOpen: Bool
    ) {
      guard let url = navigationAction.request.url else { return }

      if let action = schemeHandler.action(url: url) {
        schemeHandler.process(action: action, url: url)
        return
      }

      let (clickAction, buttonId) = queryHandler.processInAppMessageURL(
        url,
        logBodyClick: message.legacy || attributes.automaticBodyClicks
      )

      let isTransientOpen =
        attributes.linkTargetSupport
        && isTransientOpen
        && !Self.appURLSchemes.contains(url.scheme ?? "")
      process(
        clickAction: clickAction,
        buttonId: buttonId,
        target: isTransientOpen ? controller : nil
      )

      if !isTransientOpen {
        dismiss()
      }
    }

  }

}

// MARK: - Navigation

extension BrazeInAppMessageUI.HtmlView: WKNavigationDelegate {

  public func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    // When `loadHTMLString` is called with our https:// base URL it fires a synthetic .other
    // navigation to that URL. brazeShouldIntercept would treat any non-file https:// link as a
    // user click and cancel it, so we explicitly pass this initial load through first.
    if navigationAction.request.url?.host == HtmlViewRenderer.httpsBaseURL?.host,
      navigationAction.navigationType == .other
    {
      decisionHandler(.allow)
      return
    }

    if brazeShouldIntercept(navigationAction) {
      decisionHandler(.cancel)
      processNavigationAction(
        navigationAction,
        isTransientOpen: navigationAction.isTransientOpen
      )
    } else {
      decisionHandler(.allow)
    }
  }

  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    // Drag and drop interaction handler does not exist until the message is loaded.
    webView.disableDragAndDrop()
    // Disable selection by inserting css
    webView.disableSelection()

    makeKey()

    UIView.animate(
      withDuration: message.animateIn
        ? attributes.animation.duration(legacy: message.legacy)
        : 0,
      animations: {
        self.presented = true
        self.superview?.layoutIfNeeded()
      },
      completion: { _ in
        self.logImpression()
        self.presentationCompletion?()
        self.presentationCompletion = nil
        self.didPresent()
      }
    )
  }

  public func webView(
    _ webView: WKWebView,
    didFail navigation: WKNavigation!,
    withError error: Error
  ) {
    logError(.webViewNavigation(.init(error)))
    messageWrapper.wrappedValue.animateOut = false
    dismiss()
  }

}

// MARK: - alert / confirm / prompt / window.open

extension BrazeInAppMessageUI.HtmlView: WKUIDelegate {

  private func presentAlert(message: String, configure: (UIAlertController) -> Void) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    configure(alert)
    controller?.present(alert, animated: true, completion: nil)
  }

  public func webView(
    _ webView: WKWebView,
    runJavaScriptAlertPanelWithMessage message: String,
    initiatedByFrame frame: WKFrameInfo,
    completionHandler: @escaping () -> Void
  ) {
    presentAlert(message: message) {
      $0.addAction(.init(title: "Close", style: .default, handler: { _ in completionHandler() }))
    }
  }

  public func webView(
    _ webView: WKWebView,
    runJavaScriptConfirmPanelWithMessage message: String,
    initiatedByFrame frame: WKFrameInfo,
    completionHandler: @escaping (Bool) -> Void
  ) {
    presentAlert(message: message) {
      $0.addAction(
        .init(title: "Cancel", style: .cancel, handler: { _ in completionHandler(false) }))
      $0.addAction(.init(title: "OK", style: .default, handler: { _ in completionHandler(true) }))
    }
  }

  public func webView(
    _ webView: WKWebView,
    runJavaScriptTextInputPanelWithPrompt prompt: String,
    defaultText: String?,
    initiatedByFrame frame: WKFrameInfo,
    completionHandler: @escaping (String?) -> Void
  ) {
    presentAlert(message: prompt) { alert in
      alert.addTextField { $0.text = defaultText }
      alert.addAction(
        .init(title: "Cancel", style: .cancel, handler: { _ in completionHandler(nil) }))
      alert.addAction(
        .init(
          title: "OK", style: .default,
          handler: { _ in completionHandler(alert.textFields?.first?.text) }))
    }
  }

  public func webView(
    _ webView: WKWebView,
    createWebViewWith configuration: WKWebViewConfiguration,
    for navigationAction: WKNavigationAction,
    windowFeatures: WKWindowFeatures
  ) -> WKWebView? {
    processNavigationAction(navigationAction, isTransientOpen: true)
    return nil
  }

}

// MARK: - Misc.

extension BrazeInAppMessageUI.HtmlView {

  fileprivate func addVoiceOverHook() {
    // This view helps the accessibility engine focus on the message view. Without it, the
    // accessibility engine will fail to properly focus on an accessible element within the web
    // view.
    let voiceOverHook = UIView()
    insertSubview(voiceOverHook, at: 0)
    initialAccessibilityElement = voiceOverHook
  }

  fileprivate static let appURLSchemes: [String] = {
    (Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]] ?? [])
      .filter { $0["CFBundleTypeRole"] as? String == "Editor" }
      .flatMap { $0["CFBundleURLSchemes"] as? [String] ?? [] }
  }()

  private func handleHtmlPersistenceError(_ error: Error) {
    logError(.htmlFileWrite(.init(error)))
    messageWrapper.wrappedValue.animateOut = false
    dismiss()
  }

}

extension WKNavigationAction {

  /// Returns whether the navigation action is considered _transient_.
  ///
  /// A transient navigation action is processed without dismissing the in-app message.
  ///
  /// In HTML, transient navigation actions are performed via an anchor tag with an explicit
  /// undefined target value (e.g. `_blank`, `_new` or any other name excepted `_self`).
  ///
  /// ```html
  /// <a href="https://example.com" target="_blank">link</a>
  /// ```
  ///
  /// In JavaScript, transient navigation actions are performed via the `window.open()` function.
  /// `window.open()` is always considered a transient navigation action as its default behavior
  /// in regular web environment is to open a new window.
  ///
  /// ```js
  /// window.open("https://example.com")
  /// ```
  ///
  fileprivate var isTransientOpen: Bool {
    let transientSupportedSchemes: Set<String> = [
      "http",
      "https",
      "mailto",
      "tel",
      "facetime",
      "facetime-audio",
      "sms",
    ]
    return navigationType == .linkActivated
      && targetFrame == nil
      && transientSupportedSchemes.contains(request.url?.scheme?.lowercased() ?? "")
  }

}
