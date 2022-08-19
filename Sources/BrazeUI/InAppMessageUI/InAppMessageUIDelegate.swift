import BrazeKit
import UIKit

/// Methods for reacting to the in-app message UI lifecycle.
public protocol BrazeInAppMessageUIDelegate: AnyObject {

  /// Defines whether the in-app message will be displayed now, displayed later, or discarded.
  ///
  /// The default implementation returns the display choice
  /// ``BrazeInAppMessageUI/DisplayChoice/now``.
  ///
  /// If there are situations where you would not want the in-app message to appear (such as during
  /// a full screen game or on a loading screen), you can use this delegate to delay or discard
  /// pending in-app message messages.
  ///
  /// When returning ``BrazeInAppMessageUI/DisplayChoice/later``, the message is put on the top of
  /// the message ``BrazeInAppMessageUI/stack``. Use ``BrazeInAppMessageUI/presentNext()`` to
  /// present the next in-app message in the stack.
  ///
  /// - Parameters:
  ///   - ui: The in-app message ui instance.
  ///   - message: The message to be presented.
  /// - Returns: The display choice for `message`. See ``BrazeInAppMessageUI/DisplayChoice`` for
  ///            possible values.
  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    displayChoiceForMessage message: Braze.InAppMessage
  ) -> BrazeInAppMessageUI.DisplayChoice

  /// Called before the in-app message display. Offers ways to deeply customize the in-app message
  /// presentation via the mutable `context`.
  ///
  /// - Parameters:
  ///   - ui: The in-app message ui instance.
  ///   - context: The presentation context. See ``BrazeInAppMessageUI/PresentationContext`` for a
  ///              list of supported customizations.
  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    prepareWith context: inout BrazeInAppMessageUI.PresentationContext
  )

  /// Called before the in-app message presentation and after
  /// ``inAppMessage(_:prepareWith:)-11fog``.
  /// - Parameters:
  ///   - ui: The in-app message ui instance.
  ///   - message: The message to be presented.
  ///   - view: The in-app message view.
  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    willPresent message: Braze.InAppMessage,
    view: InAppMessageView
  )

  /// Called once the in-app message is fully visible to the user.
  /// - Parameters:
  ///   - ui: The in-app message ui instance.
  ///   - message: The message to be presented.
  ///   - view: The in-app message view.
  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    didPresent message: Braze.InAppMessage,
    view: InAppMessageView
  )

  /// Called before any dismissal animation occurs.
  /// - Parameters:
  ///   - ui: The in-app message ui instance.
  ///   - message: The message to be presented.
  ///   - view: The in-app message view.
  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    willDismiss message: Braze.InAppMessage,
    view: InAppMessageView
  )

  /// Called after any dismissal animation occurs and the in-app message is fully hidden from the
  /// user.
  /// - Parameters:
  ///   - ui: The in-app message ui instance.
  ///   - message: The message to be presented.
  ///   - view: The in-app message view.
  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    didDismiss message: Braze.InAppMessage,
    view: InAppMessageView
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
  ///   - buttonId: The optional button identifier.
  ///   - message: The message to be presented.
  ///   - view: The in-app message view.
  /// - Returns: `true` to let Braze process the click action, `false` otherwise.
  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    shouldProcess clickAction: Braze.InAppMessage.ClickAction,
    buttonId: String?,
    message: Braze.InAppMessage,
    view: InAppMessageView
  ) -> Bool

}

// MARK: - Default implementation

extension BrazeInAppMessageUIDelegate {

  public func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    displayChoiceForMessage message: Braze.InAppMessage
  ) -> BrazeInAppMessageUI.DisplayChoice {
    .now
  }

  public func inAppMessage(
    _ ui: BrazeInAppMessageUI, prepareWith context: inout BrazeInAppMessageUI.PresentationContext
  ) {}

  public func inAppMessage(
    _ ui: BrazeInAppMessageUI, willPresent message: Braze.InAppMessage,
    view: InAppMessageView
  ) {}

  public func inAppMessage(
    _ ui: BrazeInAppMessageUI, didPresent message: Braze.InAppMessage,
    view: InAppMessageView
  ) {}

  public func inAppMessage(
    _ ui: BrazeInAppMessageUI, willDismiss message: Braze.InAppMessage,
    view: InAppMessageView
  ) {}

  public func inAppMessage(
    _ ui: BrazeInAppMessageUI, didDismiss message: Braze.InAppMessage,
    view: InAppMessageView
  ) {}

  public func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    shouldProcess clickAction: Braze.InAppMessage.ClickAction,
    buttonId: String?,
    message: Braze.InAppMessage,
    view: InAppMessageView
  ) -> Bool {
    true
  }

}
