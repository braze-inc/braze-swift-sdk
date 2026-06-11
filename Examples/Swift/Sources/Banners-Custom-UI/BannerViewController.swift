import BrazeKit
import UIKit
import WebKit

/// Custom banner view controller that renders a Braze banner using WKWebView without BrazeUI.
/// Demonstrates manual analytics logging via the Banner model API and conformance to BrazeBannerPlacement.
@MainActor
final class BannerViewController: UIViewController, BrazeBannerPlacement {

  let placementId: String

  var onDismiss: ((Braze.BannerDismissalEvent) -> Void)?

  // Retained to keep the live update subscription active for this screen.
  private var subscription: Braze.Cancellable?

  private var banner: Braze.Banner?
  private var hasLoggedImpression = false

  // MARK: - Views

  private lazy var webView: WKWebView = {
    let webView = WKWebView()
    webView.navigationDelegate = self
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.isHidden = true
    return webView
  }()

  private lazy var dismissButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Dismiss Banner", for: .normal)
    button.addTarget(self, action: #selector(dismissBanner), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.isHidden = true
    return button
  }()

  private lazy var logClickButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Log Click", for: .normal)
    button.addTarget(self, action: #selector(logBannerClick), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.isHidden = true
    return button
  }()

  private lazy var errorLabel: UILabel = {
    let label = UILabel()
    label.text = "No banner available for this placement."
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.isHidden = true
    return label
  }()

  private lazy var loadingView: UIActivityIndicatorView = {
    let view: UIActivityIndicatorView
#if os(visionOS)
    view = UIActivityIndicatorView(style: .medium)
#else
    if #available(iOS 13.0, *) {
      view = UIActivityIndicatorView(style: .medium)
    } else {
      view = UIActivityIndicatorView(style: .gray)
    }
#endif
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  // MARK: - Init

  init(placementId: String) {
    self.placementId = placementId
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = "Custom Banner"
    setupLayout()
    loadingView.startAnimating()

    // Set up the onDismiss callback to handle dismissal events
    onDismiss = { event in
      print("Banner dismissed from placement: \(event.placementId ?? "no placement")")
      if let stableKey = event.stableKey {
        print("  Stable key: \(stableKey)")
      }
      if let trackingId = event.trackingId {
        print("  Tracking ID: \(trackingId)")
      }
    }

    // Subscribe to live updates so the view re-renders when new content arrives from the server.
    subscription = AppDelegate.braze?.banners.subscribeToUpdates { [weak self] banners in
      guard let self else { return }
      if let banner = banners[self.placementId] {
        self.render(banner)
      } else {
        self.showError()
      }
    }

    // Fetch the currently cached banner immediately — subscribeToUpdates handles the rest.
    AppDelegate.braze?.banners.getBanner(for: placementId) { [weak self] banner in
      guard let self, let banner else { return }
      self.render(banner)
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    logImpression()
  }

  // MARK: - BrazeBannerPlacement

  func render(with banner: Braze.Banner) {
    render(banner)
  }

  func notifyError(_ error: Error) {
    showError()
  }

  func removeBannerContent(reason: Braze.Banner.RemovalReason) {
    showError()
  }

  // MARK: - Banner Rendering

  private func render(_ banner: Braze.Banner) {
    self.banner = banner

    // Control banners should be tracked but have no HTML to display.
    if banner.isControl {
      logImpression()
      showError()
      return
    }

    loadingView.stopAnimating()
    webView.isHidden = false
    dismissButton.isHidden = false
    logClickButton.isHidden = false
    errorLabel.isHidden = true

    webView.loadHTMLString(banner.html, baseURL: nil)

    // Log impression once the banner content has been set and the view is visible.
    if isViewLoaded, view.window != nil {
      logImpression()
    }
  }

  private func showError() {
    loadingView.stopAnimating()
    webView.isHidden = true
    dismissButton.isHidden = true
    logClickButton.isHidden = true
    errorLabel.isHidden = false
  }

  // MARK: - Analytics

  private func logImpression() {
    // The SDK deduplicates impressions per session, but we guard locally to avoid the warning.
    guard !hasLoggedImpression, let banner else { return }
    hasLoggedImpression = true
    banner.context?.logImpression()
  }

  /// Dismiss the banner via its context when available — this handles idempotency and fires
  /// the SDK's onDismiss callback. Falls back to the top-level dismiss(using:) otherwise.
  /// The onDismiss closure is automatically invoked by the SDK with dismissal event details.
  @objc private func dismissBanner() {
    if let context = banner?.context {
      context.dismiss()
    } else if let banner, let braze = AppDelegate.braze {
      banner.dismiss(using: braze)
    }
    removeBannerContent(reason: .dismissal)
    navigationController?.popViewController(animated: true)
  }

  /// Logs a manual click event on the banner (e.g. from a custom tap target in your UI).
  /// Pass a `buttonId` to associate the click with a specific button defined in the dashboard.
  @objc private func logBannerClick() {
    guard let banner else { return }
    banner.context?.logClick(buttonId: nil)
    print("Logged click for banner:", banner.placementId)
  }

  // MARK: - Layout

  private func setupLayout() {
    view.addSubview(webView)
    view.addSubview(dismissButton)
    view.addSubview(logClickButton)
    view.addSubview(errorLabel)
    view.addSubview(loadingView)

    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      webView.bottomAnchor.constraint(equalTo: dismissButton.topAnchor, constant: -12),

      dismissButton.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      dismissButton.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      dismissButton.bottomAnchor.constraint(equalTo: logClickButton.topAnchor, constant: -8),

      logClickButton.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      logClickButton.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      logClickButton.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

      errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      errorLabel.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      errorLabel.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

      loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }

}

// MARK: - WKNavigationDelegate

extension BannerViewController: WKNavigationDelegate {

  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    // Intercept link taps to log a click event, then let the SDK handle URL navigation.
    guard navigationAction.navigationType == .linkActivated,
      let url = navigationAction.request.url,
      let banner
    else {
      decisionHandler(.allow)
      return
    }

    banner.context?.logClick(buttonId: nil)
    // processClickAction handles URL opening (in-app browser vs. Safari) via Braze's URL delegate.
    banner.context?.processClickAction(.url(url, useWebView: false), target: self)
    decisionHandler(.cancel)
  }

}
