import BrazeKit
import UIKit
import WebKit

extension BrazeInAppMessageUI {

  /// The view for html in-app messages
  ///
  /// The html view can be customized using the ``attributes-swift.property`` property.
  open class HtmlView: UIView, InAppMessageView {

    /// The html in-app message.
    public var message: Braze.InAppMessage.Html

    // MARK: - Attributes

    /// The attributes supported by the html in-app message view.
    ///
    /// Attributes can be updated in multiple ways:
    /// - Via modifying the ``defaults`` static property
    /// - Via implementing the ``BrazeInAppMessageUIDelegate/inAppMessage(_:prepareWith:)-11fog``
    ///   delegate.
    /// - Via modifying the ``BrazeInAppMessageUI/messageView`` attributes on the
    ///   `BrazeInAppMessageUI` instance.
    public struct Attributes {

      /// The animation used to present the view.
      public var animation: Animation = .auto

      /// Specifies whether the web view should automatically track body clicks.
      ///
      /// - Important: Body clicks are always tracked for legacy html in-app messages (zip based).
      public var automaticBodyClicks: Bool = false

      /// Specifies whether the web view should support the `target` parameter / attribute in:
      /// - Anchor tags (e.g. `<a href="..." target="_blank">`)
      /// - Window opens (e.g. `window.open(url, "_blank")`)`
      ///
      /// When set to true (default), the url marked with `target` is opened and the message
      /// remains visible.
      /// When set to false, the url marked with `target` is opened and the message is dismissed.
      ///
      /// Deeplinks (e.g. `customAppScheme://`) always dismiss the message.
      public var linkTargetSupport: Bool = true

      /// Closure allowing customization of the configuration used by the web view.
      public var configure: ((WKWebViewConfiguration) -> Void)?

      /// Closure allowing further customization, executed when the view is about to be presented.
      public var onPresent: ((HtmlView) -> Void)?

      /// Closure executed every time the view is laid out.
      public var onLayout: ((HtmlView) -> Void)?

      /// Closure executed every time the view update its theme.
      public var onTheme: ((HtmlView) -> Void)?

      /// The defaults html view attributes.
      ///
      /// Modify this value directly to apply the customizations to all html in-app messages
      /// presented by the SDK.
      public static var defaults = Self()
    }

    /// The view attributes. See ``Attributes-swift.struct``.
    public let attributes: Attributes

    // MARK: - Animation

    /// The presentation animations supported by the html in-app message view.
    public enum Animation {

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
    public lazy var queryHandler: Braze.WebViewBridge.QueryHandler = webViewQueryHandler()

    // MARK: - LifeCycle

    public init(
      message: Braze.InAppMessage.Html,
      attributes: Attributes = .defaults,
      presented: Bool = false
    ) {
      self.message = message
      self.attributes = attributes
      self.presented = presented
      super.init(frame: .zero)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    deinit {
      // Cleanup userContentController because it:
      // - strongly retain its scripts and script message handlers
      // - seems to outlive the configuration / web view instance
      // - manual cleanup here ensure proper deallocation of those objects
      let userContentController = webView?.configuration.userContentController
      userContentController?.removeAllUserScripts()
      userContentController?.removeScriptMessageHandler(
        forName: Braze.WebViewBridge.ScriptMessageHandler.name
      )
    }

    // MARK: - Theme

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      super.traitCollectionDidChange(previousTraitCollection)
      attributes.onTheme?(self)
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
      guard let superview = superview,
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

    open func setupWebView() {
      // Configuration
      let configuration = WKWebViewConfiguration()
      configuration.suppressesIncrementalRendering = true
      configuration.allowsInlineMediaPlayback = true

      // - Customization
      attributes.configure?(configuration)

      // - Script message handler
      typealias ScriptMessageHandler = Braze.WebViewBridge.ScriptMessageHandler
      configuration.userContentController.addUserScript(ScriptMessageHandler.script)
      configuration.userContentController.add(scriptMessageHandler, name: ScriptMessageHandler.name)

      // WebView
      let webView = WKWebView(frame: .zero, configuration: configuration)
      webView.uiDelegate = self
      webView.navigationDelegate = self
      webView.allowsLinkPreview = false
      webView.scrollView.bounces = false
      webView.backgroundColor = .clear
      webView.isOpaque = false
      // Disable this optimization for mac catalyst (force webview in window bounds)
      #if !targetEnvironment(macCatalyst)
        if #available(iOS 11.0, *) {
          // Make web view ignore the safe area allowing proper handling in html / css. See the usage
          // section at https://developer.mozilla.org/en-US/docs/Web/CSS/env() (archived version:
          // https://archive.is/EBSJD) for instructions.
          webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
      #endif
      webView.alpha = attributes.animation.initialAlpha(legacy: message.legacy)
      addSubview(webView)
      self.webView = webView
    }

    open func loadMessage() {
      guard let baseURL = message.baseURL else {
        logError(.htmlNoBaseURL)
        message.animateOut = false
        dismiss()
        return
      }

      // Create directory if needed
      try? FileManager.default.createDirectory(
        at: baseURL,
        withIntermediateDirectories: true,
        attributes: nil
      )

      // Write index.html
      let index = baseURL.appendingPathComponent("index.html")
      try? message.message.write(to: index, atomically: true, encoding: .utf8)

      // Load
      webView?.loadFileURL(index, allowingReadAccessTo: baseURL)
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

      let (clickAction, buttonId) = queryHandler.process(
        url: url,
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
    let isIframeLoad =
      navigationAction.targetFrame != nil
      && navigationAction.sourceFrame != navigationAction.targetFrame
    let isIframeNavigation = navigationAction.targetFrame?.isMainFrame == false

    guard let url = navigationAction.request.url,
      url.isFileURL == false,
      isIframeLoad == false,
      isIframeNavigation == false
    else {
      decisionHandler(.allow)
      return
    }

    decisionHandler(.cancel)

    processNavigationAction(navigationAction, isTransientOpen: navigationAction.isTransientOpen)
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
    message.animateOut = false
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

}

extension WKWebView {

  fileprivate func disableDragAndDrop() {
    if #available(iOS 11.0, *) {
      self
        .bfsSubviews
        .lazy
        .first { $0.interactions.contains(where: { $0 is UIDragInteraction }) }?
        .interactions
        .filter { $0 is UIDragInteraction }
        .forEach { $0.view?.removeInteraction($0) }
    }
  }

  fileprivate func disableSelection() {
    evaluateJavaScript(
      """
      const css = `* {
        -webkit-touch-callout: none;
        -webkit-user-select: none;
      }`
      const head = document.head || document.getElementsByTagName('head')[0]
      var style = document.createElement('style')
      style.type = 'text/css'
      style.appendChild(document.createTextNode(css))
      head.appendChild(style)
      """
    )
  }

}

extension WKNavigationAction {

  /// Returns whether the navigation action is considered _transient_. A transient navigation action
  /// is processed without dismissing the in-app message.
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
