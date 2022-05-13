import BrazeKit
import UIKit

extension UIFont {

  /// Shorthand for `Braze.UIUtils.preferredFont(forTextStyle:weight:)`.
  static func preferredFont(
    textStyle: UIFont.TextStyle,
    weight: UIFont.Weight
  ) -> UIFont {
    Braze.UIUtils.preferredFont(textStyle: textStyle, weight: weight)
  }

}

extension UIButton {

  /// Adds a closure executed when pressed.
  func addAction(_ action: @escaping () -> Void) {
    @objc final class Receiver: NSObject {
      let action: () -> Void
      init(_ action: @escaping () -> Void) { self.action = action }
      @objc func receive() { action() }
    }
    let receiver = Receiver(action)
    self.addTarget(receiver, action: #selector(Receiver.receive), for: .touchUpInside)
    objc_setAssociatedObject(self, UUID().uuidString, receiver, .OBJC_ASSOCIATION_RETAIN)
  }

}

extension UIView {

  /// Position the view in a resizable container view and returns it. The wrapped view can adopt its
  /// intrinsic content size without being stretched.
  /// - Parameters:
  ///   - centerX: Horizontally center the view in the container view (default: `true`).
  ///   - centerY: Vertically center the view in the container view (default: `true`).
  /// - Returns: The view wrapped in a resizable container view.
  func boundedByIntrinsicContentSize(
    centerX: Bool = true,
    centerY: Bool = true
  ) -> UIView {
    let wrapper = UIView()
    wrapper.addSubview(self)
    if centerX { anchors.centerX.align() }
    if centerY { anchors.centerY.align() }
    anchors.edges.lessThanOrEqual(wrapper)
    return wrapper
  }

  /// The sequence of recursive subviews using a breadth-first search approach.
  ///
  /// Use it with the `lazy` modifier for efficient recursive subview search:
  /// ```swift
  /// view.bfsSubviews.lazy.first { $0 is UIButton }
  /// ```
  var bfsSubviews: AnySequence<UIView> {
    AnySequence { () -> AnyIterator<UIView> in
      var subviews: [UIView] = self.subviews
      return AnyIterator {
        if subviews.isEmpty { return nil }
        let view = subviews.removeFirst()
        subviews.append(contentsOf: view.subviews)
        return view
      }
    }
  }

}

extension UIResponder {

  /// A sequence representing the instance's responder chain starting with the instance's next
  /// responder.
  var responders: AnySequence<UIResponder> {
    AnySequence { () -> AnyIterator<UIResponder> in
      var responder: UIResponder? = self
      return AnyIterator {
        responder = responder?.next
        return responder
      }
    }
  }

}

extension UIViewController {

  /// The "topmost" presented view controller.
  var topmost: UIViewController? {
    var controller = self
    while let presented = controller.presentedViewController {
      controller = presented
    }
    return controller
  }

}

extension String {

  func attributed(_ setup: (NSMutableParagraphStyle) -> Void) -> NSAttributedString {
    let attributedText = NSMutableAttributedString(string: self)
    let style = NSMutableParagraphStyle()
    setup(style)
    attributedText.addAttribute(
      .paragraphStyle,
      value: style,
      range: NSRange(location: 0, length: attributedText.length)
    )
    return attributedText
  }

}
