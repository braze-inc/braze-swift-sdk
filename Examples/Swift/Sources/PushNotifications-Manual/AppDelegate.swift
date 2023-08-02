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
    // Setup Braze
    let configuration = Braze.Configuration(apiKey: brazeApiKey, endpoint: brazeEndpoint)
    configuration.logger.level = .info
    configuration.push.appGroup = "group.com.braze.PushNotifications.PushStories"
    let braze = Braze(configuration: configuration)
    AppDelegate.braze = braze

    // Push notifications support
    application.registerForRemoteNotifications()
    let center = UNUserNotificationCenter.current()
    center.setNotificationCategories(Braze.Notifications.categories)
    center.delegate = self
    center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
      print("Notification authorization, granted: \(granted), error: \(String(describing: error))")
    }

    window?.makeKeyAndVisible()

    return true
  }

  // MARK: - Push Notification support

  // - Register the device token with Braze

  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    AppDelegate.braze?.notifications.register(deviceToken: deviceToken)
  }

  // - Add support for silent notification

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    if let braze = AppDelegate.braze,
      braze.notifications.handleBackgroundNotification(
        userInfo: userInfo,
        fetchCompletionHandler: completionHandler
      )
    {
      return
    }
    completionHandler(.noData)
  }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

  // - Add support for push notifications

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    if let braze = AppDelegate.braze,
      braze.notifications.handleUserNotification(
        response: response,
        withCompletionHandler: completionHandler
      )
    {
      return
    }
    completionHandler()
  }

  // - Add support for displaying push notification when the app is currently running in the
  //   foreground

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14, *) {
      completionHandler([.list, .banner])
    } else {
      completionHandler(.alert)
    }
  }

}
