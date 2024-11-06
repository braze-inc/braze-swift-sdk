import Foundation

extension BrazeBannerUI.ContentUpdates {

  /// The estimated intrinsic height of the HTML content.
  @objc(height)
  @available(swift, obsoleted: 0.0.1)
  public var _objc_height: NSNumber? {
    height.map { NSNumber(value: $0) }
  }

}
