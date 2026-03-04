import BrazeKit
import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  static var braze: Braze? = nil
  var notificationSubscription: Braze.Cancellable?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Setup Braze
    let configuration = Braze.Configuration(apiKey: brazeApiKey, endpoint: brazeEndpoint)
    configuration.logger.level = .info
    configuration.push.appGroup = "group.com.braze.PushNotifications.PushStories"

    // Enable all push notification automation features (default: disabled)
    configuration.push.automation = true

    // Each automation can be enabled / disabled on its own
    // - e.g. disable the requestAuthorizationAtLaunch automation:
    /*
    configuration.push.automation.requestAuthorizationAtLaunch = false
    */

    let braze = Braze(configuration: configuration)
    AppDelegate.braze = braze

    window?.makeKeyAndVisible()

    // Subscribe to Push notification events
    notificationSubscription = AppDelegate.braze?.notifications.subscribeToUpdates { payload in
      print(
        """
        Push notification subscription triggered:
        - type: \(payload.type)
        - title: \(String(describing: payload.title))
        - isSilent: \(payload.isSilent)
        """
      )
    }

    return true
  }
}
