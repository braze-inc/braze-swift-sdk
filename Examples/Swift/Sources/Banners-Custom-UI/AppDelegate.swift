import BrazeKit
import SwiftUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  static var braze: Braze? = nil

  // The subscription needs to be retained to remain active.
  var bannersSubscription: Braze.Cancellable?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Setup Braze
    let configuration = Braze.Configuration(apiKey: brazeApiKey, endpoint: brazeEndpoint)
    configuration.logger.level = .info
    let braze = Braze(configuration: configuration)
    AppDelegate.braze = braze

    // Request updated banners.
    braze.banners.requestBannersRefresh(
      placementIds: [BannersCustomUI.Constants.placementID]
    )

    window?.makeKeyAndVisible()
    return true
  }

  // MARK: - Displaying Banners

  enum UIFramework {
    case uiKit
    case swiftUI
  }

  func displayBanner(framework: UIFramework) {
    guard let navigationController = window?.rootViewController as? UINavigationController else {
      return
    }

    switch framework {
    case .uiKit:
      navigationController.pushViewController(
        BannerViewController(placementId: BannersCustomUI.Constants.placementID),
        animated: true
      )
    case .swiftUI:
      if #available(iOS 13.0, *) {
        let controller = BannerPlacementController(
          placementId: BannersCustomUI.Constants.placementID
        )
        let view = BannerView(controller: controller)
        navigationController.pushViewController(
          UIHostingController(rootView: view),
          animated: true
        )
      }
    }
  }

  // MARK: - Banners API

  /// Requests an immediate refresh of banners and prints the result.
  func requestBannersRefresh() {
    AppDelegate.braze?.banners.requestBannersRefresh(
      placementIds: [BannersCustomUI.Constants.placementID]
    ) { result in
      switch result {
      case .success(let banners):
        print("Banners refreshed:", banners.keys.sorted().joined(separator: ", "))
      case .failure(let error):
        print("Banner refresh failed:", error)
      }
    }
  }

  /// Retrieves a banner from local cache and prints its properties.
  func getBanner() {
    AppDelegate.braze?.banners.getBanner(
      for: BannersCustomUI.Constants.placementID
    ) { banner in
      guard let banner else {
        print("No banner available for placement:", BannersCustomUI.Constants.placementID)
        return
      }

      print("Banner retrieved:")
      print("  placementId:", banner.placementId)
      print("  isControl:", banner.isControl)
      print("  isTestSend:", banner.isTestSend)
      print("  expiresAt:", banner.expiresAt)

      // Access typed properties set via the Braze dashboard.
      if let title = banner.stringProperty(key: "title") {
        print("  title:", title)
      }
      if let price = banner.numberProperty(key: "price") {
        print("  price:", price)
      }
      if let active = banner.boolProperty(key: "active") {
        print("  active:", active)
      }
      if let imageURL = banner.imageProperty(key: "image") {
        print("  image:", imageURL)
      }
    }
  }

  /// Subscribes to banner updates. The subscription fires immediately if banners have already
  /// been synced this session, and again on every subsequent server sync.
  func subscribeToUpdates() {
    bannersSubscription = AppDelegate.braze?.banners.subscribeToUpdates { banners in
      print("Banner update — placements: \(banners.keys.sorted().joined(separator: ", "))")

      if let banner = banners[BannersCustomUI.Constants.placementID] {
        print("  \(banner.placementId): isControl=\(banner.isControl)")
      }
    }
  }

  /// Cancels the active banner subscription.
  func cancelSubscription() {
    bannersSubscription?.cancel()
    bannersSubscription = nil
    print("Banner subscription cancelled.")
  }

}
