import UserNotifications

// Important: `UNUserNotificationCenterDelegate` is not yet annotated for Swift Concurrency. We use
// the `@preconcurrency` attribute to suppress concurrency warnings.
// The `@preconcurrency` attribute on protocol conformance is only available starting with Xcode 16.
#if compiler(>=6.0)
  extension AppDelegate: @preconcurrency UNUserNotificationCenterDelegate {

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
      if let braze = AppDelegate.braze {
        braze.notifications.handleForegroundNotification(notification: notification)
      }

      if #available(iOS 14, *) {
        completionHandler([.list, .banner])
      } else {
        completionHandler(.alert)
      }
    }

  }
#endif
