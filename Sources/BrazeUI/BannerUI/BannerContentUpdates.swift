import Foundation

extension BrazeBannerUI {

  /// A data model containing updated properties of the loaded HTML content.
  @objc(BrazeBannerUIContentUpdates)
  public final class ContentUpdates: NSObject, Sendable {

    /// The estimated intrinsic height of the HTML content.
    public let height: Double?

    /// Initializes the Braze banner UI content updates object.
    ///
    /// - Parameter height: The intrinsic height of the view.
    init(height: Double? = nil) {
      self.height = height
    }

  }

}
