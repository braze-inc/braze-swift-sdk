import BrazeKit
import BrazeUI
import SwiftUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  static var braze: Braze? = nil

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
    braze.banners.requestBannersRefresh(placementIds: [
      "sdk-test-1",
      "sdk-test-2",
    ])

    window?.makeKeyAndVisible()
    return true
  }

  // MARK: - Displaying Banners

  enum UIFramework {
    case uiKit
    case swiftUI
  }

  func displayFullScreenBanner(framework: UIFramework) {
    guard let navigationController = window?.rootViewController as? UINavigationController else {
      return
    }

    switch framework {
    case .uiKit:
      navigationController.pushViewController(FullScreenBannerViewController(), animated: true)
    case .swiftUI:
      if #available(iOS 13.0, *) {
        let hostingController = UIHostingController(rootView: FullScreenBannerView())
        navigationController.pushViewController(hostingController, animated: true)
      }
    }
  }

  func displayWideBanner(framework: UIFramework) {
    guard let navigationController = window?.rootViewController as? UINavigationController else {
      return
    }

    switch framework {
    case .uiKit:
      navigationController.pushViewController(WideBannerViewController(), animated: true)
    case .swiftUI:
      if #available(iOS 13.0, *) {
        let hostingController = UIHostingController(rootView: WideBannerView())
        navigationController.pushViewController(hostingController, animated: true)
      }
    }
  }

}
