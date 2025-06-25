import BrazeKit
import UIKit
@preconcurrency import WebKit

extension BrazeBannerUI {

  /// A UIKit-compatible version of the Braze banner view.
  @objc(BRZBannerUIView)
  open class BannerUIView: UIView, BrazeBannerPlacement {

    /// The placement ID of the Banner.
    public let placementId: String

    let braze: Braze
    let impressionTracker: BrazeBannerUI.BannersImpressionTracker
    let processContentUpdates:
      (@MainActor (Result<BrazeBannerUI.ContentUpdates, Swift.Error>) -> Void)?

    var webView: WKWebView?
    var banner: Braze.Banner?

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

    /// Wrapper for the `QueryHandler` object.
    ///
    /// Structs from `BrazeKit` cannot generate a proper Objective-C metaclass and will cause a crash if subclassed.
    lazy var queryHandlerWrapper: StructWrapper<Braze.WebViewBridge.QueryHandler> = .init(
      wrappedValue: webViewQueryHandler())

    /// Initializes and registers a Braze banner view.
    ///
    /// - Parameter placementId: The placement ID of the banner.
    /// - Parameter braze: The Braze instance.
    /// - Parameter processContentUpdates: A closure that provides the updated properties of the banner view after content has finished rendering.
    public init(
      placementId: String,
      braze: Braze,
      processContentUpdates: (
        @MainActor (Result<BrazeBannerUI.ContentUpdates, Swift.Error>) -> Void
      )? = nil
    ) {
      self.placementId = placementId
      self.braze = braze
      self.processContentUpdates = processContentUpdates
      self.impressionTracker = .shared

      super.init(frame: .zero)

      setupWebView()
      braze.banners.registerView(self)
      impressionTracker.startSessionTracking(with: braze)
    }

    /// Internal default initializer without auto-registration.
    init(
      placementId: String,
      braze: Braze,
      processContentUpdates: (
        @MainActor (Result<BrazeBannerUI.ContentUpdates, Swift.Error>) -> Void
      )? = nil,
      impressionTracker: BrazeBannerUI.BannersImpressionTracker
    ) {
      self.placementId = placementId
      self.braze = braze
      self.processContentUpdates = processContentUpdates
      self.impressionTracker = impressionTracker

      super.init(frame: .zero)
      setupWebView()
    }

    deinit {
      isolatedMainActorDeinit { [self] in
        self.tearDownWebView()
      }
    }

    open func setupWebView() {
      let configuration = WKWebViewConfiguration.forBrazeBridge(
        scriptMessageHandler: scriptMessageHandler)
      let webView = WKWebView(frame: .zero, configuration: configuration)
      webView.navigationDelegate = self
      webView.clipsToBounds = true
      webView.scrollView.isScrollEnabled = false
      // Prevents the status bar from pushing down the web view's content when scrolling on Flutter.
      webView.scrollView.contentInsetAdjustmentBehavior = .never
      webView.isOpaque = false

      if #available(iOS 16.4, macOS 13.3, *) {
        webView.isInspectable = true
      }

      self.webView = webView
      self.addSubview(webView)

      webView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        webView.topAnchor.constraint(equalTo: self.topAnchor),
        webView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        webView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        webView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      ])
    }

    func tearDownWebView() {
      // Cleanup userContentController because:
      // - It strongly retains its scripts and script message handlers
      // - It seems to outlive the configuration / web view instance
      // - Manual cleanup here ensure proper deallocation of those objects
      let userContentController = webView?.configuration.userContentController
      userContentController?.removeAllUserScripts()
      userContentController?.removeScriptMessageHandler(
        forName: Braze.WebViewBridge.ScriptMessageHandler.name
      )
      self.subviews.forEach { ($0 as? WKWebView)?.removeFromSuperview() }
      webView = nil
    }

    required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    /// Renders the banner content into the view if there are updates.
    ///
    /// - Parameter banner: The Braze banner model.
    open func render(with banner: Braze.Banner) {
      if self.webView == nil {
        setupWebView()
      }

      if self.banner != banner {
        self.banner = banner
        DispatchQueue.main.async { [weak self] in
          self?.webView?.loadHTMLString(banner.html, baseURL: nil)
        }
      }
    }

    /// Processes errors encountered during loading.
    ///
    /// - Parameter error: The error object.
    open func notifyError(_ error: Swift.Error) {
      if let brazeError = error as? BrazeBannerUI.Error {
        logError(brazeError)
      }
      self.processContentUpdates?(.failure(error))
    }

    /// Instructs the view to nullify and remove its existing Banner Card content.
    public func removeBannerContent() {
      self.banner = nil
      self.tearDownWebView()
      self.processContentUpdates?(.success(.init(height: 0)))
    }

    /// Logs an error related to the banner.
    ///
    /// - Parameter error: The banner UI error.
    open func logError(_ error: BrazeBannerUI.Error) {
      banner?.context?.logError(error)
        ?? print("[BrazeUI]", error.flattened)
    }

    open func processNavigationAction(_ navigationAction: WKNavigationAction) {
      guard let url = navigationAction.request.url else { return }

      // Process as a Braze bridge action.
      if let action = schemeHandler.action(url: url) {
        schemeHandler.process(action: action, url: url)
        return
      }

      // Process as a Braze click action.
      let clickAction = queryHandler.processBannerURL(url)
      process(clickAction: clickAction)
    }

    public func process(
      clickAction: Braze.Banner.ClickAction,
      target: Any? = nil
    ) {
      guard let context = banner?.context else {
        logError(.noContextProcessClickAction)
        return
      }

      context.processClickAction(clickAction, target: target)
    }

  }

}

// MARK: - Public Initializers

extension BrazeBannerUI.BannerUIView {

  /// Initializes and registers a Braze banner view.
  ///
  /// - Parameter placementId: The placement ID of the banner.
  /// - Parameter braze: The Braze instance.
  /// - Parameter processContentUpdates: A closure that provides the updated properties of the banner view after content has finished rendering.
  @objc
  @available(swift, obsoleted: 0.0.1)
  public convenience init(
    placementId: String,
    braze: Braze,
    processContentUpdates: ((BrazeBannerUI.ContentUpdates?, Error?) -> Void)? = nil
  ) {
    var resultClosure: ((Result<BrazeBannerUI.ContentUpdates, Swift.Error>) -> Void)?
    if let processContentUpdates {
      resultClosure = { result in
        switch result {
        case .success(let updates):
          processContentUpdates(updates, nil)
        case .failure(let error):
          processContentUpdates(nil, error)
        }
      }
    }
    self.init(
      placementId: placementId,
      braze: braze,
      processContentUpdates: resultClosure
    )
  }

}

// MARK: - WKNavigationDelegate

extension BrazeBannerUI.BannerUIView: WKNavigationDelegate {

  /// This method triggers when the `WKWebView` finishes loading the content.
  ///
  /// Note that web views don't start loading until the user has scrolled to it.
  open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    // Drag and drop interaction handler does not exist until the message is loaded.
    webView.disableDragAndDrop()
    // Disable selection by inserting CSS
    webView.disableSelection()
    // Start tracking the view after it has successfully loaded.
    webView.waitForLoadedState(scriptMessageHandler) { [weak self] in
      guard let self else { return }
      self.impressionTracker.trackView(self)
    }
  }

  public func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    // Link was explicitly clicked by user.
    // Intercept the default web view navigation and handle within the SDK.
    if brazeShouldIntercept(navigationAction) {
      decisionHandler(.cancel)
      processNavigationAction(navigationAction)
    } else {
      // Pass to web view to let system handle it.
      decisionHandler(.allow)
    }
  }

  public func webView(
    _ webView: WKWebView,
    didFail navigation: WKNavigation!,
    withError error: Error
  ) {
    notifyError(
      BrazeBannerUI.Error.webViewNavigation(.init(error))
    )
  }

}

// MARK: - Impression Logging

@objc
extension BrazeBannerUI.BannerUIView {

  /// Logs an impression for the banner.
  open func logImpression() {
    guard let context = banner?.context else {
      logError(BrazeBannerUI.Error.noContextLogImpression)
      return
    }
    context.logImpression()
  }

  /// Logs a click for the banner.
  ///
  /// - Parameter buttonId: The optional button identifier.
  open func logClick(buttonId: String?) {
    guard let context = banner?.context else {
      logError(BrazeBannerUI.Error.noContextLogClick)
      return
    }
    context.logClick(buttonId: buttonId)
  }

  /// Determines if the banner view is currently visible and not occluded.
  ///
  /// - Returns: Whether the banner is currently in view.
  open func isCurrentlyVisible() -> Bool {
    guard let window = self.window, !self.isHidden else {
      return false
    }

    // Iteratively check if any superviews are hidden.
    var superview = self.superview
    while let view = superview {
      if view.isHidden {
        return false
      }
      superview = view.superview
    }

    let viewFrame = self.convert(self.bounds, to: window)
    let intersection = viewFrame.intersection(window.bounds)
    if intersection.isNull {
      return false
    }

    return window.bounds.intersects(viewFrame)
  }

}
