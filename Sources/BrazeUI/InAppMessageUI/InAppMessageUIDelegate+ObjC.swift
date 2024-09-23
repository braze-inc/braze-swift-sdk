import BrazeKit
import Foundation
import UIKit

/// Methods for reacting to the in-app message UI lifecycle.
@objc(BrazeInAppMessageUIDelegate)
public protocol _OBJC_BrazeInAppMessageUIDelegate: AnyObject {

  /// Defines whether the in-app message will be displayed now, discarded, or re-enqueued.
  ///
  /// The default implementation returns the display choice
  /// ``BrazeInAppMessageUI/DisplayChoice/now``.
  ///
  /// If there are situations where you would not want the in-app message to appear (such as during
  /// a full screen game or on a loading screen), you can use this delegate to delay or discard
  /// pending in-app message messages.
  ///
  /// When returning ``BrazeInAppMessageUI/DisplayChoice/reenqueue``, the message is put on the top of
  /// the message ``BrazeInAppMessageUI/stack``. Use ``BrazeInAppMessageUI/presentNext()`` to
  /// present the next in-app message in the stack.
  ///
  /// - Parameters:
  ///   - ui: The in-app message ui instance.
  ///   - message: The message to be presented.
  /// - Returns: The display choice for `message`. See ``BrazeInAppMessageUI/DisplayChoice`` for
  ///            possible values.
  @objc(inAppMessage:displayChoiceForMessage:)
  @MainActor
  optional func _objc_inAppMessage(
    _ ui: BrazeInAppMessageUI,
    displayChoiceForMessage message: Braze.InAppMessageRaw
  ) -> _OBJC_BRZInAppMessageUIDisplayChoice

  /// Called before the in-app message presentation and after
  /// ``inAppMessage(_:prepareWith:)-11fog``.
  /// - Parameters:
  ///   - ui: The in-app message ui instance.
  ///   - message: The message to be presented.
  ///   - view: The in-app message view.
  @objc(inAppMessage:willPresent:view:)
  @MainActor
  optional func _objc_inAppMessage(
    _ ui: BrazeInAppMessageUI,
    willPresent message: Braze.InAppMessageRaw,
    view: UIView
  )

  /// Called once the in-app message is fully visible to the user.
  /// - Parameters:
  ///   - ui: The in-app message ui instance.
  ///   - message: The message to be presented.
  ///   - view: The in-app message view.
  @objc(inAppMessage:didPresent:view:)
  @MainActor
  optional func _objc_inAppMessage(
    _ ui: BrazeInAppMessageUI,
    didPresent message: Braze.InAppMessageRaw,
    view: UIView
  )

  /// Called before any dismissal animation occurs.
  /// - Parameters:
  ///   - ui: The in-app message ui instance.
  ///   - message: The message to be presented.
  ///   - view: The in-app message view.
  @objc(inAppMessage:willDismiss:view:)
  @MainActor
  optional func _objc_inAppMessage(
    _ ui: BrazeInAppMessageUI,
    willDismiss message: Braze.InAppMessageRaw,
    view: UIView
  )

  /// Called after any dismissal animation occurs and the in-app message is fully hidden from the
  /// user.
  /// - Parameters:
  ///   - ui: The in-app message ui instance.
  ///   - message: The message to be presented.
  ///   - view: The in-app message view.
  @objc(inAppMessage:didDismiss:view:)
  @MainActor
  optional func _objc_inAppMessage(
    _ ui: BrazeInAppMessageUI,
    didDismiss message: Braze.InAppMessageRaw,
    view: UIView
  )

  /// Defines whether Braze should process the message click action.
  ///
  /// When returning `true` (default return value), Braze processes the click action.
  ///
  /// - Important: When this method returns `true` and the click action is an url, Braze will
  ///              **still** execute the `BrazeDelegate.braze(_:shouldOpenURL:)` delegate method
  ///              offering a last opportunity to modify or replace Braze url handling behavior.
  ///              If your implementation only needs access to the `url`, prefer using
  ///              `BrazeDelegate.braze(_:shouldOpenURL:)` instead.
  ///
  /// - Parameters:
  ///   - ui: The in-app message ui instance.
  ///   - clickAction: The click action.
  ///   - url: The click action url when `clickAction` is of type `url`, nil otherwise.
  ///   - buttonId: The optional button identifier.
  ///   - message: The message to be presented.
  ///   - view: The in-app message view.
  /// - Returns: `true` to let Braze process the click action, `false` otherwise.
  @objc(inAppMessage:shouldProcess:url:buttonId:message:view:)
  @MainActor
  optional func _objc_inAppMessage(
    _ ui: BrazeInAppMessageUI,
    shouldProcess clickAction: Braze.InAppMessageRaw._OBJC_BRZInAppMessageRawClickAction,
    url: URL?,
    buttonId: String?,
    message: Braze.InAppMessageRaw,
    view: UIView
  ) -> Bool

  /// Called before the in-app message display, offering ways to deeply customize the in-app message
  /// presentation via the mutable `context`.
  ///
  /// - Parameters:
  ///   - ui: The in-app message UI instance.
  ///   - context: The presentation context. See ``BrazeInAppMessageUI/PresentationContextRaw`` for a
  ///              list of supported customizations.
  @objc(inAppMessage:prepareWith:)
  @MainActor
  optional func _objc_inAppMessage(
    _ ui: BrazeInAppMessageUI,
    prepareWith context: BrazeInAppMessageUI.PresentationContextRaw
  )

}

/// The different display choices supported when receiving an in-app message from the Braze SDK.
///
/// See ``BrazeInAppMessageUIDelegate/inAppMessage(_:displayChoiceForMessage:)-1ghly``.
@objc(BRZInAppMessageUIDisplayChoice)
public enum _OBJC_BRZInAppMessageUIDisplayChoice: Int, Sendable {

  /// The in-app message is displayed immediately.
  case now

  /// The in-app message is **not displayed** and placed on top of the ``BrazeInAppMessageUI/stack``.
  ///
  /// Use ``BrazeInAppMessageUI/presentNext()`` to display the message at the top of the stack.
  case reenqueue

  /// Has identical behavior to ``BrazeInAppMessageUI/DisplayChoice/reenqueue``.
  ///
  /// This option has been deprecated and will be removed in a future update.
  /// Please use ``BrazeInAppMessageUI/DisplayChoice/reenqueue`` instead.
  @available(*, deprecated, renamed: "reenqueue")
  public static var later: Self {
    .reenqueue
  }

  /// The in-app message is discarded.
  case discard

  init(_ displayChoice: BrazeInAppMessageUI.DisplayChoice) {
    switch displayChoice {
    case .now: self = .now
    case .reenqueue: self = .reenqueue
    case .discard: self = .discard
    }
  }

  var displayChoice: BrazeInAppMessageUI.DisplayChoice {
    switch self {
    case .now: return .now
    case .reenqueue: return .reenqueue
    case .discard: return .discard
    }
  }

}

// MARK: - Delegate Wrapper

/// This delegate wraps the ObjC version of the `BrazeInAppMessageUIDelegate` and make it compatible
/// with the base Swift implementation.
final class _OBJC_BrazeInAppMessageUIDelegateWrapper: BrazeInAppMessageUIDelegate {

  // nonisolated(unsafe) attribute for global variable is only available in Xcode 15.3 and later.
  #if compiler(>=5.10)
    /// Property used as a unique key for the wrapper lifecycle behavior.
    nonisolated(unsafe) private static var wrapperKey: Void?
  #else
    private static var wrapperKey: Void?
  #endif

  /// The ObjC in-app message UI delegate.
  weak var delegate: _OBJC_BrazeInAppMessageUIDelegate?

  /// Creates and returns a delegate wrapper for the ObjC version of `BrazeInAppMessageUIDelegate`.
  ///
  /// The delegate is stored weakly by the ``BrazeUI/BrazeInAppMessageUI`` instance. In order for
  /// the wrapper to behave like its underlying delegate, it is dynamically attached to the ObjC
  /// delegate implementation using the ObjC runtime. As long as the underlying delegate is alive,
  /// this wrapper will remain alive.
  ///
  /// - Parameter delegate: The delegate to wrap.
  init(_ delegate: _OBJC_BrazeInAppMessageUIDelegate) {
    self.delegate = delegate
    objc_setAssociatedObject(delegate, &Self.wrapperKey, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }

  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    displayChoiceForMessage message: Braze.InAppMessage
  ) -> BrazeInAppMessageUI.DisplayChoice {
    delegate?._objc_inAppMessage?(ui, displayChoiceForMessage: .init(message)).displayChoice ?? .now
  }

  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    willPresent message: Braze.InAppMessage,
    view: InAppMessageView
  ) {
    delegate?._objc_inAppMessage?(ui, willPresent: .init(message), view: view)
  }

  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    didPresent message: Braze.InAppMessage,
    view: InAppMessageView
  ) {
    delegate?._objc_inAppMessage?(ui, didPresent: .init(message), view: view)
  }

  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    willDismiss message: Braze.InAppMessage,
    view: InAppMessageView
  ) {
    delegate?._objc_inAppMessage?(ui, willDismiss: .init(message), view: view)
  }

  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    didDismiss message: Braze.InAppMessage,
    view: InAppMessageView
  ) {
    delegate?._objc_inAppMessage?(ui, didDismiss: .init(message), view: view)
  }

  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    shouldProcess clickAction: Braze.InAppMessage.ClickAction,
    buttonId: String?,
    message: Braze.InAppMessage,
    view: InAppMessageView
  ) -> Bool {
    let message = Braze.InAppMessageRaw(message)
    return delegate?._objc_inAppMessage?(
      ui,
      shouldProcess: .init(message.clickAction),
      url: clickAction.url,
      buttonId: buttonId,
      message: message,
      view: view
    ) ?? true
  }

  func inAppMessage(
    _ ui: BrazeInAppMessageUI, prepareWith context: inout BrazeInAppMessageUI.PresentationContext
  ) {
    let rawContext = BrazeInAppMessageUI.PresentationContextRaw(context)
    delegate?._objc_inAppMessage?(ui, prepareWith: rawContext)
    if let updatedContext = try? BrazeInAppMessageUI.PresentationContext(rawContext) {
      context = updatedContext
    }
  }

}
