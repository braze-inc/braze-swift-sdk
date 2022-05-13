import UIKit

/// KeyboardFrameNotifier listens to any changes to the keyboard frame reported by the system and
/// pass them down to any of its own subscribers.
///
/// An instance of this class should be created as early as possible in order to receive accurate
/// frame updates.
/// `UIKit` does not offer any api to retrieve the current state of the software keyboard, only
/// updates. The keyboard frame is `.zero` until the keyboard frame notifier receives an update from
/// `UIKit`.
open class KeyboardFrameNotifier {

  /// The shared keyboard frame notifier.
  public static let shared = KeyboardFrameNotifier()

  /// The current keyboard frame.
  ///
  /// The initial value is `.zero` until an update is received from `UIKit`.
  var frame: CGRect = .zero

  /// The windows for which the keyboard can be displayed.
  var windows: [UIWindow] {
    if #available(iOS 13.0, tvOS 13.0, *) {
      return
        UIApplication.shared
        .connectedScenes
        .lazy
        .compactMap { $0 as? UIWindowScene }
        .first { $0.activationState == .foregroundActive }?
        .windows ?? []
    } else {
      return UIApplication.shared
        .windows
    }
  }

  /// The subscriptions dictionary.
  var subscriptions: [AnyHashable: (CGRect) -> Void] = [:]

  /// Creates a keyboard frame notifier.
  /// - Parameter center: The notification center used to receive keyboard frame updates.
  init(center: NotificationCenter = .default) {
    center.addObserver(
      self,
      selector: #selector(willChangeFrame(_:)),
      name: UIResponder.keyboardWillChangeFrameNotification,
      object: nil
    )
    center.addObserver(
      self,
      selector: #selector(didHide(_:)),
      name: UIResponder.keyboardDidHideNotification,
      object: nil
    )
  }

  /// Subscribes for keyboard frame updates.
  /// - Parameters:
  ///   - identifier: The value identifying the subscriptions.
  ///   - onFrame: The closure executed for each frame update.
  func subscribe(
    identifier: AnyHashable,
    onFrame: @escaping (CGRect) -> Void
  ) {
    onFrame(frame)
    subscriptions[identifier] = onFrame
  }

  /// Unsubscribe from keyboard frame updates.
  /// - Parameter identifier: The identifier used when subscribing.
  func unsubscribe(identifier: AnyHashable) {
    subscriptions[identifier] = nil
  }

  @objc
  func willChangeFrame(_ notification: Notification) {
    guard let nsFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
      windows.count > 0
    else {
      return
    }
    guard nsFrame.cgRectValue != .zero else { return }
    frame = nsFrame.cgRectValue
    subscriptions.values.forEach { $0(frame) }
  }

  @objc
  func didHide(_ notification: Notification) {
    frame = .zero
    subscriptions.values.forEach { $0(frame) }
  }

}
