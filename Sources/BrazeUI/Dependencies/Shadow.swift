import UIKit

/// Type representing a view's shadow.
public struct Shadow: Equatable {
  public var color: UIColor
  public var offset: CGSize
  public var radius: CGFloat
  public var opacity: Float

  public init(color: UIColor, offset: CGSize, radius: CGFloat, opacity: Float) {
    self.color = color
    self.offset = offset
    self.radius = radius
    self.opacity = opacity
  }

  /// Braze's default in-app messages shadow.
  public static let inAppMessage = Self(
    color: .black.withAlphaComponent(0.3),
    offset: .zero,
    radius: 4.0,
    opacity: 1
  )

  /// Braze's default content card shadow.
  public static let contentCard = Self(
    color: .brazeCellShadowColor,
    offset: CGSize(width: 0, height: 2),
    radius: 3,
    opacity: 0.5
  )
}
