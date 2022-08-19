import UIKit

/// A view rendering an auto-updating shadow.
open class ShadowView: UIView {

  /// The view's shadow.
  open var shadow: Shadow? {
    didSet { drawShadow() }
  }

  open override var bounds: CGRect {
    didSet { drawShadow() }
  }

  /// Creates and returns a shadow view.
  /// - Parameter shadow: The shadow value.
  public init(_ shadow: Shadow) {
    self.shadow = shadow

    super.init(frame: .zero)

    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }

  /// Does not support interface-builder / storyboards.
  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// Use ``init(_:)`` instead.
  @available(*, unavailable)
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }

  /// Draws the shadow with the current ``shadow``.
  open func drawShadow() {
    guard let shadow = shadow else {
      layer.shadowOffset = .zero
      layer.shadowRadius = 0
      layer.shadowOpacity = 0
      layer.shadowColor = nil
      layer.shadowPath = nil
      return
    }

    // Params
    layer.shadowOffset = shadow.offset
    layer.shadowRadius = shadow.radius
    layer.shadowOpacity = shadow.opacity

    // Color
    layer.shadowColor = shadow.color.brazeResolvedColor(with: traitCollection).cgColor

    // Size
    let path = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: layer.cornerRadius
    ).cgPath
    layer.shadowPath = path
  }

  open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    guard #available(iOS 13.0, *),
      traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)
    else {
      return
    }
    drawShadow()
  }

}
