import BrazeKit
import UIKit

#if canImport(ActivityKit) && os(iOS) && !targetEnvironment(macCatalyst)
  import ActivityKit
#endif

let readme =
  """
  This sample demonstrates the Push Logout APIs, which unregister the device's push tokens from \
  the current user profile.

  Enter a user ID and tap "Change user" to switch the current user. Results are printed to the \
  console. On failure, the error's `isRetriable` property indicates whether calling the \
  originating method again may succeed - the SDK never retries a failed unregistration on its own.

  See files:
  - AppDelegate.swift
    - Configure Braze, register for push and Live Activities push-to-start
    - Add the "Change user" text field row
  - Readme.swift
    - Register / unregister push token
    - Register / unregister Live Activities push-to-start tokens
    - Logout
    - Change the current user
    - Show the SDK device ID
  """

@MainActor
let actions: [(String, String, @MainActor (ReadmeViewController) -> Void)] = [
  (
    "Unregister push",
    "Remove the push token from the current user",
    { _ in unregisterPush() }
  ),
  (
    "Unregister push-to-start tokens",
    "Remove all Live Activities push-to-start tokens from the current user",
    { _ in unregisterPushToStart() }
  ),
  (
    "Logout",
    "Unregister all push tokens, then wipe local data and disable the SDK",
    { viewController in
      logout()
      viewController.clearTextFields()
    }
  ),
  (
    "Show device ID",
    "Display and copy the SDK device identifier",
    { showDeviceId($0) }
  ),
]

// MARK: - Internal

@MainActor
func enableSDK() {
  // Logout disables the SDK; re-enable it (e.g. on a new login) before re-registering.
  AppDelegate.braze?.enabled = true
  print("enableSDK: SDK enabled")
}

@MainActor
func registerPush() {
  // Logout disables the SDK; re-enable it before re-registering (e.g. on a new login).
  AppDelegate.braze?.enabled = true
  UIApplication.shared.registerForRemoteNotifications()
  print("registerPush: requested remote notification registration")
}

@MainActor
func unregisterPush() {
  AppDelegate.braze?.notifications.unregisterPush { result in
    switch result {
    case .success:
      print("unregisterPush: success")
    case .failure(let error):
      print("unregisterPush: failure - \(describe(error))")
    }
  }
}

@MainActor
func registerPushToStart() {
  #if canImport(ActivityKit) && os(iOS) && !targetEnvironment(macCatalyst)
    guard #available(iOS 17.2, *) else {
      print("registerPushToStart: requires iOS 17.2+")
      return
    }
    // Logout disables the SDK; re-enable it before re-registering.
    AppDelegate.braze?.enabled = true
    _ = AppDelegate.braze?.liveActivities.registerPushToStart(
      forType: Activity<PushLogoutActivityAttributes>.self,
      name: "PushLogoutActivityAttributes"
    )
    print("registerPushToStart: registered")
  #else
    print("registerPushToStart: Live Activities are not supported on this platform")
  #endif
}

@MainActor
func unregisterPushToStart() {
  #if canImport(ActivityKit) && os(iOS) && !targetEnvironment(macCatalyst)
    guard #available(iOS 16.1, *) else {
      print("unregisterPushToStart: requires iOS 16.1+")
      return
    }
    // Async variant, a completion-based variant is also available.
    Task {
      do {
        try await AppDelegate.braze?.liveActivities.unregisterPushToStart()
        print("unregisterPushToStart: success")
      } catch let error as Braze.PushUnregistrationError {
        print("unregisterPushToStart: failure - \(describe(error))")
      }
    }
  #else
    print("unregisterPushToStart: Live Activities are not supported on this platform")
  #endif
}

@MainActor
func logout() {
  AppDelegate.braze?.logout { result in
    switch result {
    case .success:
      // All local data is wiped and the SDK is disabled. Re-enable it via `braze.enabled = true`
      // (e.g. when a new user logs in).
      print("logout: success")
    case .failure(let error):
      let errors = error.errors.map { "\($0.key): \(describe($0.value))" }.joined(separator: ", ")
      print("logout: failure (isRetriable: \(error.isRetriable)) - [\(errors)]")
    }
  }
}

@MainActor
func changeUser(_ userId: String) {
  let userId = userId.trimmingCharacters(in: .whitespacesAndNewlines)
  guard !userId.isEmpty else {
    print("changeUser: skipped - empty user ID")
    return
  }
  AppDelegate.braze?.changeUser(userId: userId)
  print("changeUser: \(userId)")
}

@MainActor
func showDeviceId(_ viewController: ReadmeViewController) {
  guard let deviceId = AppDelegate.braze?.deviceId else {
    print("deviceId: unavailable")
    return
  }
  print("deviceId: \(deviceId)")
  UIPasteboard.general.string = deviceId
  let alert = UIAlertController(
    title: "Device ID",
    message: "\(deviceId)\n\nCopied to clipboard.",
    preferredStyle: .alert
  )
  alert.addAction(UIAlertAction(title: "Close", style: .default))
  viewController.present(alert, animated: true)
}

func describe(_ error: Braze.PushUnregistrationError) -> String {
  """
  \(error.message) \
  (isRetriable: \(error.isRetriable), \
  httpStatusCode: \(error.httpStatusCode.map(String.init) ?? "none"))
  """
}
