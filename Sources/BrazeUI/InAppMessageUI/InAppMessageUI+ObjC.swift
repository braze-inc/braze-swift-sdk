import BrazeKit
import Foundation
import UIKit

extension BrazeInAppMessageUI {

  /// The currently visible message view.
  @objc(messageView)
  @available(swift, obsoleted: 0.0.1)
  public var _objc_messageView: UIView? { messageView }

  /// The stack of in-app messages awaiting display.
  ///
  /// When the conditions to display a message are not met at trigger time, the message is pushed
  /// onto the stack.
  @objc(stack)
  @available(swift, obsoleted: 0.0.1)
  public var _objc_stack: [Braze.InAppMessageRaw] { stack.map(Braze.InAppMessageRaw.init) }

  /// The object that act as the delegate for the in-app message UI.
  ///
  /// The delegate is not retained and must conform to ``BrazeInAppMessageUIDelegate``.
  @objc(delegate)
  @available(swift, obsoleted: 0.0.1)
  public weak var _objc_delegate: _OBJC_BrazeInAppMessageUIDelegate? {
    get { (delegate as? _OBJC_BrazeInAppMessageUIDelegateWrapper)?.delegate }
    set { delegate = newValue.flatMap(_OBJC_BrazeInAppMessageUIDelegateWrapper.init) }
  }

  /// Dismisses the current in-app message view.
  @objc(dismiss)
  @available(swift, obsoleted: 0.0.1)
  public func _objc_dismiss() {
    dismiss()
  }

}
