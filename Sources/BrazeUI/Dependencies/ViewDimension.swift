import UIKit

/// A struct representing view dimensions for both regular and large interfaces.
///
/// Large interface values are used when the UI is being displayed with both horizontal and vertical
/// size classes are `.regular` and the device is in landscape.
public struct ViewDimension: Hashable {

  /// The dimension for the regular case.
  public var regular: Double

  /// The dimension for the large case.
  public var large: Double

  public init(regular: Double, large: Double) {
    self.regular = regular
    self.large = large
  }

}

// MARK: - Misc.

extension ViewDimension: ExpressibleByFloatLiteral {

  public init(floatLiteral value: Double) {
    self.init(regular: value, large: value)
  }

}

extension ViewDimension: ExpressibleByIntegerLiteral {

  public init(integerLiteral value: IntegerLiteralType) {
    self.init(regular: Double(value), large: Double(value))
  }

}
