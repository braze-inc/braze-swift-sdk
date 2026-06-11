import BrazeKit
import UIKit

let readme =
  """
  This sample demonstrates how to implement a custom Banner UI using BrazeKit only,
  without BrazeUI:

  - AppDelegate.swift:
    - Requesting a Banners refresh (with and without a completion handler)
    - Retrieving a cached banner via getBanner(for:)
    - Subscribing to and cancelling banner updates via subscribeToUpdates(_:)
  - BannerViewController.swift / BannerView.swift:
    - Rendering banner HTML in a WKWebView
    - Logging impressions via banner.context?.logImpression()
    - Logging clicks via banner.context?.logClick(buttonId:) and WKNavigationDelegate
    - Dismissing a banner via banner.context?.dismiss()
    - Subscribing to live updates so the view re-renders on new content
  """

@MainActor
let actions: [(String, String, @MainActor (ReadmeViewController) -> Void)] = [
  (
    "Display banner using UIKit",
    "",
    displayBannerUIKit
  ),
  (
    "Display banner using SwiftUI",
    "",
    displayBannerSwiftUI
  ),
  (
    "Request banners refresh",
    "",
    requestBannersRefresh
  ),
  (
    "Get banner (cached)",
    "",
    getBanner
  ),
  (
    "Subscribe to banner updates",
    "",
    subscribeToUpdates
  ),
  (
    "Cancel banner subscription",
    "",
    cancelSubscription
  ),
]

// MARK: - Internal

@MainActor
func displayBannerUIKit(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.displayBanner(framework: .uiKit)
}

@MainActor
func displayBannerSwiftUI(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.displayBanner(framework: .swiftUI)
}

@MainActor
func requestBannersRefresh(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.requestBannersRefresh()
}

@MainActor
func getBanner(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.getBanner()
}

@MainActor
func subscribeToUpdates(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.subscribeToUpdates()
}

@MainActor
func cancelSubscription(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.cancelSubscription()
}
