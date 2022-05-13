import UIKit

extension BrazeInAppMessageUI {

  /// A `UIStackView` wrapper view.
  ///
  /// Before iOS 14, `UIStackView` uses a non-rendering `CATransformLayer` instead of a classic
  /// `CALayer` (see [tweet](https://archive.md/t0AIh)). This wrapper view allow to set the layer's
  /// properties on pre-iOS 14 devices
  public class StackView: UIView {

    /// The inner stack view.
    public let stack = UIStackView()

    /// The inner stack autolayout position constraints.
    public var stackPositionConstraints: [NSLayoutConstraint]!

    public override var intrinsicContentSize: CGSize {
      stack.intrinsicContentSize
    }

    override init(frame: CGRect) {
      super.init(frame: frame)
      addSubview(stack)
      layoutMargins = .zero
      stackPositionConstraints = stack.anchors.edges.pin(to: self.layoutMarginsGuide)
    }

    /// See `UIStackView/init(arrangedSubviews:)`.
    convenience init(arrangedSubviews subviews: [UIView]) {
      self.init(frame: .zero)
      subviews.forEach(stack.addArrangedSubview)
    }

    required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

  }

}
