import UIKit

/// Type representing a view's shadow.
public struct Shadow: Equatable {
  public var color: UIColor
  public var offset: CGSize
  public var radius: CGFloat
  public var opacity: Float

  /// Default shadow used by Braze's in-app messages.
  public static let `default` = Self(
    color: .black.withAlphaComponent(0.3),
    offset: .zero,
    radius: 4.0,
    opacity: 1
  )
}

extension UIView {

  /// Syntactic sugar around the layer's shadow properties.
  ///
  /// When using this property to set the view's shadow, you can use ``updateShadow()`` to resize
  /// the shadow to the view's current size.
  var shadow: Shadow? {
    get {
      guard let color = layer.shadowColor.flatMap(UIColor.init) else {
        return nil
      }
      return .init(
        color: color,
        offset: layer.shadowOffset,
        radius: layer.shadowRadius,
        opacity: layer.opacity
      )
    }
    set {
      guard let value = newValue else {
        layer.shadowColor = nil
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
        layer.shadowPath = nil
        return
      }
      layer.shadowColor = value.color.cgColor
      layer.shadowOffset = value.offset
      layer.shadowRadius = value.radius
      layer.shadowOpacity = value.opacity
      updateShadow()
    }
  }

  /// Resizes the layer's shadow path to the view's current size.
  func updateShadow() {
    guard shadow != nil else {
      return
    }
    let path = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: layer.cornerRadius
    ).cgPath

    layer.shadowPath = path
  }

}
