import BrazeKit
import UIKit

#if canImport(ActivityKit) && os(iOS) && !targetEnvironment(macCatalyst)
  import ActivityKit
#endif

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

    // Enable all push notification automation features so that a push token is registered at
    // launch (default: disabled).
    configuration.push.automation = true

    let braze = Braze(configuration: configuration)
    AppDelegate.braze = braze

    // Register the Live Activity type for remote launch (push-to-start)
    registerPushToStart()

    // Add a row to change the current user's ID. Populated before the window is created.
    readmeTextFieldRows = [
      ReadmeTextFieldRow(placeholder: "User ID", buttonTitle: "Change user") { userId, _ in
        changeUser(userId)
      }
    ]

    // Re-registration actions, shown in their own section. Populated before the window is created.
    readmeActionSections = [
      ReadmeActionSection(
        title: "Re-register after logout",
        actions: [
          (
            "Enable Braze SDK",
            "Re-enable the SDK after logout disabled it",
            { _ in enableSDK() }
          ),
          (
            "Register push",
            "Re-enable the SDK and register for remote notifications",
            { _ in registerPush() }
          ),
          (
            "Register push-to-start",
            "Re-enable the SDK and re-register Live Activities push-to-start",
            { _ in registerPushToStart() }
          ),
        ]
      )
    ]

    window?.makeKeyAndVisible()

    return true
  }
}

#if canImport(ActivityKit) && os(iOS) && !targetEnvironment(macCatalyst)
  /// Minimal Live Activity attributes used to demonstrate push-to-start unregistration.
  @available(iOS 16.1, *)
  struct PushLogoutActivityAttributes: ActivityAttributes, BrazeLiveActivityAttributes {
    struct ContentState: Codable, Hashable {}
    var brazeActivityId: String?
  }
#endif
