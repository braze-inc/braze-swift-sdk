import BrazeKit
import UIKit

extension BrazeContentCardUI {

  /// The Content Card cell which displays Banner cards.
  open class BannerCell: ImageCell {

    /// The type identifier.
    public static let identifier = "BrazeContentCardUI.BannerCell"

    // MARK: - Initialization

    /// Initializes the content card cell passing `style` and `reuseIdentifier` to the `super`
    /// implementation.
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)

      container.addSubview(contentImageView)
      container.bringSubviewToFront(pinIndicator)
      container.bringSubviewToFront(unviewedIndicator)

      installInternalConstraints()
      applyAttributes(attributes)
    }

    /// Does not support interface-builder / storyboards.
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    open override func installInternalConstraints() {
      super.installInternalConstraints()
      contentImageView.anchors.edges.pin()
    }

    // MARK: - Card Update

    /// Updates the cell with the passed banner content card.
    /// - Parameters:
    ///   - card: The content card to display.
    ///   - imageLoad: The current image load state.
    open func set(card: Braze.ContentCard.Banner, imageLoad: AsyncImageView.ImageLoad?) {
      if case .success = imageLoad {
      } else {
        // Set the image view aspect ratio using the content card's value only if the image isn't
        // loaded yet. When the image is loaded, the image view uses the actual aspect ratio
        // automatically
        contentImageView.aspectRatio = card.imageAspectRatio ?? 1.0
      }
      contentImageView.imageLoad = imageLoad

      pinIndicator.isHidden = !card.pinned
      unviewedIndicator.isHidden = card.viewed

      highlightable = card.clickAction != .none
    }
  }

}

// MARK: - Previews

#if UI_PREVIEWS

  import SwiftUI

  struct BannerCell_Previews: PreviewProvider {
    static let cards: [Braze.ContentCard] = [
      .banner(.mockPinned),
      .banner(.mockUnviewed),
      .banner(.mockViewed),
    ]
    static var previews: some View {
      BrazeContentCardUI.ViewController(initialCards: cards)
        .preview()
    }
  }

#endif
