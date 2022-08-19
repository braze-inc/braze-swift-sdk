import BrazeKit
import UIKit

/// The Braze provided Content Cards UI namespace.
public enum BrazeContentCardUI {}

extension Braze.ContentCard {

  /// The cell identifier used by ``BrazeContentCardUI/ViewController`` to display the content
  /// cards.
  public var cellIdentifier: String {
    switch self {
    case .classic:
      return BrazeContentCardUI.ClassicCell.identifier
    case .classicImage:
      return BrazeContentCardUI.ClassicImageCell.identifier
    case .banner:
      return BrazeContentCardUI.BannerCell.identifier
    case .captionedImage:
      return BrazeContentCardUI.CaptionedImageCell.identifier
    case .control:
      return BrazeContentCardUI.ControlCell.identifier
    @unknown default:
      return "BrazeContentCardUI.unknown"
    }
  }

}
