import BrazeKit
import UIKit

extension BrazeInAppMessageUI {

  /// The window displaying Braze's in-app messages.
  ///
  /// The window capture and process touch events from:
  /// - The ``InAppMessageView`` or one of its subviews
  /// - Any view when displaying an html in-app message
  ///
  /// All other touch events are passed down to the next window by UIKit.
  open class Window: UIWindow, BrazeInAppMessageWindowType {

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
      guard let view = super.hitTest(point, with: event) else {
        return nil
      }

      let isWindowTouch =
        view is InAppMessageView
        || view.responders.lazy.contains { $0 is InAppMessageView }
        || messageViewController?.message.html != nil

      return isWindowTouch ? view : nil
    }

    /// The message view controller being displayed.
    var messageViewController: ViewController? {
      rootViewController as? ViewController
    }

  }

}
