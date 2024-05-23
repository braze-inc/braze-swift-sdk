import BrazeKit
import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  static var braze: Braze? = nil

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Prepare Braze for delayed initialization
    // - This ensures that push notifications received before the SDK is initialized are processed
    //   during initialization.
    Braze.prepareForDelayedInitialization()

    window?.makeKeyAndVisible()
    return true
  }

  static func initializeBraze() {
    // Setup Braze
    let configuration = Braze.Configuration(apiKey: brazeApiKey, endpoint: brazeEndpoint)
    configuration.logger.level = .info
    configuration.push.appGroup = "group.com.braze.PushNotifications.PushStories"

    // Enable all push notification automation features (default: disabled)
    // - Using `Braze.prepareForDelayedInitialization()` implicitly enables push automation.
    // - Specific properties of the automation configuration can be customized for initialization.
    configuration.push.automation = true

    let braze = Braze(configuration: configuration)
    AppDelegate.braze = braze
  }
}
