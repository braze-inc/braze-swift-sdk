import BrazeKit
import UIKit

/// The Braze provided Content Cards UI namespace.
public enum BrazeContentCardUI {}

extension Braze.ContentCard {

  /// The cell identifier used by ``BrazeUI/BrazeContentCardUI/ViewController`` to display the
  /// content cards.
  @MainActor
  public var cellIdentifier: String {
    switch self {
    case .classic:
      return BrazeContentCardUI.ClassicCell.identifier
    case .classicImage:
      return BrazeContentCardUI.ClassicImageCell.identifier
    case .imageOnly:
      return BrazeContentCardUI.ImageOnlyCell.identifier
    case .captionedImage:
      return BrazeContentCardUI.CaptionedImageCell.identifier
    case .control:
      return BrazeContentCardUI.ControlCell.identifier
    @unknown default:
      return "BrazeContentCardUI.unknown"
    }
  }

}
