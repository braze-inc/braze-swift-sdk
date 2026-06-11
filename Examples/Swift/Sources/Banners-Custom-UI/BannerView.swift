import BrazeKit
import SwiftUI
import WebKit

// MARK: - BannerPlacementController

@available(iOS 13.0, *)
@MainActor
final class BannerPlacementController: NSObject, ObservableObject, BrazeBannerPlacement {

  let placementId: String

  var onDismiss: ((Braze.BannerDismissalEvent) -> Void)?

  @Published var banner: Braze.Banner?
  @Published var hasError = false

  private var subscription: Braze.Cancellable?

  init(placementId: String) {
    self.placementId = placementId
    super.init()

    // Subscribe to live updates so the view re-renders when new content arrives from the server.
    subscription = AppDelegate.braze?.banners.subscribeToUpdates { [weak self] banners in
      guard let self else { return }
      if let banner = banners[self.placementId] {
        self.render(with: banner)
      } else {
        self.notifyError(NSError(domain: "BannerPlacementController", code: -1))
      }
    }

    // Fetch the currently cached banner immediately — subscribeToUpdates handles the rest.
    AppDelegate.braze?.banners.getBanner(for: placementId) { [weak self] banner in
      guard let self, let banner else { return }
      self.render(with: banner)
    }
  }

  // MARK: - BrazeBannerPlacement

  func render(with banner: Braze.Banner) {
    self.banner = banner
  }

  func notifyError(_ error: Error) {
    hasError = true
  }

  func removeBannerContent(reason: Braze.Banner.RemovalReason) {
    hasError = true
    banner = nil
  }

}

// MARK: - BannerView

@available(iOS 13.0, *)
struct BannerView: View {

  @ObservedObject var controller: BannerPlacementController

  var body: some View {
    if #available(iOS 15.0, *) {
      Group {
        if let banner = controller.banner, !banner.isControl {
          VStack(spacing: 0) {
            BannerWebView(banner: banner)
            HStack(spacing: 16) {
              Button("Dismiss") {
                // context.dismiss() fires the SDK's onDismiss callback, which invokes the
                // BrazeBannerPlacement.onDismiss closure with dismissal event details.
                banner.context?.dismiss()
                // Tear down the banner content from the placement.
                controller.removeBannerContent(reason: .dismissal)
              }
              .frame(maxWidth: .infinity)
              Button("Log Click") {
                banner.context?.logClick(buttonId: nil)
              }
              .frame(maxWidth: .infinity)
            }
            .padding()
          }
        } else if controller.hasError {
          Text("No banner available for this placement.")
            .multilineTextAlignment(.center)
            .padding()
        } else {
          ProgressView()
        }
      }
    }
  }

}

// MARK: - BannerWebView

@available(iOS 13.0, *)
private struct BannerWebView: UIViewRepresentable {

  let banner: Braze.Banner

  func makeCoordinator() -> Coordinator {
    Coordinator(banner: banner)
  }

  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.navigationDelegate = context.coordinator
    webView.loadHTMLString(banner.html, baseURL: nil)
    return webView
  }

  func updateUIView(_ webView: WKWebView, context: Context) {
    context.coordinator.banner = banner
    webView.loadHTMLString(banner.html, baseURL: nil)
  }

  // MARK: - Coordinator

  final class Coordinator: NSObject, WKNavigationDelegate {

    var banner: Braze.Banner
    private var hasLoggedImpression = false

    init(banner: Braze.Banner) {
      self.banner = banner
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      // Log impression once after the HTML has finished rendering.
      guard !hasLoggedImpression else { return }
      hasLoggedImpression = true
      banner.context?.logImpression()
    }

    func webView(
      _ webView: WKWebView,
      decidePolicyFor navigationAction: WKNavigationAction,
      decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
      guard navigationAction.navigationType == .linkActivated,
        let url = navigationAction.request.url
      else {
        decisionHandler(.allow)
        return
      }

      banner.context?.logClick(buttonId: nil)
      // processClickAction handles URL opening (in-app browser vs. Safari) via Braze's URL delegate.
      banner.context?.processClickAction(.url(url, useWebView: false), target: nil)
      decisionHandler(.cancel)
    }
  }

}
