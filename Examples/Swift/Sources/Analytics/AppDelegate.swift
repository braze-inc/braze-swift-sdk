import BrazeKit
import UIKit

// MARK: - Configure Braze

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

    window?.makeKeyAndVisible()
    return true
  }

}
