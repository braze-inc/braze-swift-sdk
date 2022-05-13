import BrazeKit
import UIKit

extension BrazeInAppMessageUI {

  /// The view for control in-app messages.
  ///
  /// Control in-app messages are automatically dismissed as soon as they are presented.
  open class ControlView: UIView, InAppMessageView {

    /// The control in-app message.
    public var message: Braze.InAppMessage.Control

    /// Creates and returns a control in-app message view.
    /// - Parameter message: The message.
    public init(message: Braze.InAppMessage.Control) {
      self.message = message
      super.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    public var presented: Bool = false

    public func present(completion: (() -> Void)? = nil) {
      willPresent()
      presented = true
      logImpression()
      completion?()
      didPresent()

      // Dismiss directly
      dismiss()
    }

    public func dismiss(completion: (() -> Void)? = nil) {
      willDismiss()
      presented = false
      completion?()
      didDismiss()
    }

  }

}
