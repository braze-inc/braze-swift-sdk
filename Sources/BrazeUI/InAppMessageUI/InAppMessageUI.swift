import BrazeKit
import Foundation
import UIKit

/// The Braze provided in-app message presenter UI.
///
/// Assign an instance of this class to `braze.inAppMessagePresenter` to enable the presentation of
/// in-app messages to the user.
///
/// To add GIF support to the in-app message UI components, set a valid
/// ``gifViewProvider-swift.var``.
@objc(BrazeInAppMessageUI)
open class BrazeInAppMessageUI:
  NSObject,
  BrazeInAppMessagePresenter,
  _OBJC_BrazeInAppMessagePresenter
{

  // MARK: - Properties

  /// The currently visible message view.
  public var messageView: InAppMessageView? {
    window?.messageViewController?.messageView
  }

  /// The stack of in-app messages awaiting display.
  ///
  /// When the conditions to display a message are not met at trigger time, the message is pushed
  /// onto the stack (which is the end of this array).
  ///
  /// If an in-app message is already in the stack and fails to display again, it is moved to the top
  /// of the stack.
  public internal(set) var stack: [Braze.InAppMessage] = []

  /// The object that act as the delegate for the in-app message UI.
  ///
  /// The delegate is not retained and must conform to ``BrazeInAppMessageUIDelegate``.
  public weak var delegate: BrazeInAppMessageUIDelegate?

  /// Headless support (default: `false`).
  ///
  /// When enabled, in-app messages will be presented even when the app has no UIApplication (e.g.
  /// unit-test target without host app)
  var headless: Bool = false

  /// The keyboard frame notifier.
  var keyboard = KeyboardFrameNotifier()

  /// The timer for dismissing the message view.
  var dismissTimer: Timer?

  /// The window displaying the current in-app message view.
  var window: Window?

  // MARK: - Presentation / BrazeInAppMessagePresenter conformance

  public func present(message: Braze.InAppMessage) {
    guard validateMainThread(for: message),
      validateHeadless(for: message, allowHeadless: headless),
      validateFontAwesome(for: message),
      validateNoMessagePresented(for: message, pushInStack: true)
    else {
      return
    }

    let displayChoice =
      delegate?.inAppMessage(self, displayChoiceForMessage: message)
      ?? .now

    switch displayChoice {
    case .discard:
      message.context?.discard()
    case .later:
      stack.append(message)
    case .now:
      presentNow(message: message)
    }

  }

  @objc
  public func present(message: Braze.InAppMessageRaw) {
    do {
      let message = try Braze.InAppMessage(message)
      present(message: message)
    } catch {
      logError(for: message.context, error: .rawToTypedConversion(.init(error)))
    }
  }

  /// Presents the next in-app message in the stack if any.
  @objc
  public func presentNext() {
    // We use `last` instead of `popLast()` to avoid potentially modifying `stack` from a non
    // main thread. The message is removed from the stack in `presentNow`.
    guard let next = stack.last else {
      return
    }
    presentNow(message: next)
  }

  func presentNow(message: Braze.InAppMessage) {
    guard validateMainThread(for: message),
      validateHeadless(for: message, allowHeadless: headless),
      validateFontAwesome(for: message),
      validateNoMessagePresented(for: message, pushInStack: false),
      validateOrientation(for: message),
      validateContext(for: message)
    else {
      return
    }

    // Remove the message from the stack if needed
    stack.removeAll { $0 == message }

    // Prepare / user customizations
    var context = PresentationContext(
      message: message,
      attributes: .defaults(for: message),
      customView: nil,
      preferredOrientation: Braze.UIUtils.interfaceOrientation,
      statusBarHideBehavior: .auto,
      windowLevel: .normal,
      preferencesProxy: Braze.UIUtils.activeTopmostViewController
    )
    if #available(iOS 13.0, tvOS 13.0, *) {
      context.windowScene = Braze.UIUtils.activeWindowScene
    }
    delegate?.inAppMessage(self, prepareWith: &context)

    // Creates view hierarchy
    // - Message View
    let optMessageView =
      context.customView
      ?? createMessageView(
        for: context.message,
        attributes: context.attributes,
        gifViewProvider: GIFViewProvider.shared
      )
    guard let messageView = optMessageView else {
      message.context?.discard()
      message.context?.logError(flattened: Error.noMessageView.logDescription)
      return
    }

    // - View controller
    let viewController = ViewController(
      ui: self,
      context: context,
      messageView: messageView,
      keyboard: keyboard
    )

    // - Window
    let window: Window
    if #available(iOS 13.0, tvOS 13.0, *), let windowScene = context.windowScene {
      window = Window(windowScene: windowScene)
    } else {
      window = Window(frame: UIScreen.main.bounds)
    }
    window.windowLevel = context.windowLevel
    window.rootViewController = viewController
    self.window = window

    // Dismiss Timer
    if case .auto(let interval) = message.messageClose {
      dismissTimer?.invalidate()
      dismissTimer = .scheduledTimer(
        withTimeInterval: interval,
        repeats: false
      ) { [weak self] _ in self?.dismiss() }
    }

    // Display
    if #available(iOS 15.0, *) {
      // - Use animation block to animate the status bar hidden state
      UIView.animate(withDuration: message.animateIn ? 0.25 : 0) {
        // - Use `isHidden` instead of `makeKeyAndVisible` to defer the choice of hiding the keyboard
        //   to the message view. See `InAppMessageView/makeKey`. `isHidden` just displays the window
        //   without touching the first responder.
        window.isHidden = false
      }
    } else {
      // - No animation block before iOS 15.0, it has undesired side effects
      window.isHidden = false
    }

  }

  /// Dismisses the current in-app message view.
  /// - Parameter completion: Executed once the in-app message view has been dismissed or directly
  ///                         when no in-app message view is currently presented.
  @objc
  public func dismiss(completion: (() -> Void)? = nil) {
    messageView?.dismiss(completion: completion) ?? completion?()
  }

  // MARK: - Utils

  func logError(for context: Braze.InAppMessage.Context?, error: Error) {
    context?.logError(flattened: error.logDescription) ?? print(error.logDescription)
  }

  func validateMainThread(for message: Braze.InAppMessage) -> Bool {
    guard Thread.isMainThread else {
      DispatchQueue.main.sync {
        logError(for: message.context, error: .noMainThread)
      }
      return false
    }
    return true
  }

  func validateHeadless(for message: Braze.InAppMessage, allowHeadless: Bool = false)
    -> Bool
  {
    if allowHeadless {
      return true
    }

    if Braze.UIUtils.activeRootViewController == nil {
      logError(for: message.context, error: .noAppRootViewController)
      return false
    }

    return true
  }

  func validateNoMessagePresented(for message: Braze.InAppMessage, pushInStack push: Bool)
    -> Bool
  {
    guard messageView == nil else {
      if push {
        // Remove message from stack (if present) and place on top
        stack.removeAll { $0.data.id == message.data.id }
        stack.append(message)
      }

      logError(for: message.context, error: .otherMessagePresented(push: push))
      return false
    }
    return true
  }

  // Always return true, font-awesome missing is not a breaking error
  func validateFontAwesome(for message: Braze.InAppMessage) -> Bool {
    guard IconView.registerFontAwesomeIfNeeded() else {
      logError(for: message.context, error: .noFontAwesome)
      return true
    }
    return true
  }

  func validateOrientation(for message: Braze.InAppMessage) -> Bool {
    let traits = Braze.UIUtils.activeTopmostViewController?.traitCollection
    guard message.orientation.supported(by: traits) else {
      stack.removeAll { $0 == message }
      message.context?.discard()
      logError(for: message.context, error: .noMatchingOrientation)
      return false
    }
    return true
  }

  func validateContext(for message: Braze.InAppMessage) -> Bool {
    guard let context = message.context else {
      // No context -> not a Braze in-app message.
      return true
    }

    guard context.discarded == false else {
      stack.removeAll { $0 == message }
      logError(for: message.context, error: .messageContextDiscarded)
      return false
    }

    guard context.valid else {
      stack.removeAll { $0 == message }
      context.discard()
      logError(for: message.context, error: .messageContextInvalid)
      return false
    }

    return true
  }

  // ***** COMPAT *****

  /// Provided for compatibility purposes.
  @objc(_compat_tryPushOnStack:)
  @available(swift, obsoleted: 0.0.1)
  public func _compat_tryPushOnStack(message: Braze.InAppMessageRaw) {
    guard let message = try? Braze.InAppMessage(message) else { return }
    stack.append(message)
  }

  // ******************
}
