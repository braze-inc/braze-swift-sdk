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

    if let action = schemeHandler.action(url: url) {
      schemeHandler.process(action: action, url: url)
      return
    }

    let (clickAction, buttonId) = queryHandler.process(url: url)
    process(clickAction: clickAction, buttonId: buttonId)
    dismiss()
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

// MARK: - alert / confirm / prompt

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

}

// MARK: - Misc.

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
