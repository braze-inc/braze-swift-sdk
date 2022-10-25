import BrazeKit
import UIKit

extension BrazeContentCardUI {

  /// The Content Card cell which displays Captioned Image cards.
  open class CaptionedImageCell: ImageCell {

    /// The type identifier.
    public static let identifier = "BrazeContentCardUI.CaptionedImageCell"

    // MARK: - Initialization

    /// Initializes the content card cell passing `style` and `reuseIdentifier` to the `super`
    /// implementation.
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)

      container.addSubview(contentImageView)

      let textStack = TextStack()
      self.textStack = textStack
      container.addSubview(textStack)

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

    /// The image height constraint. Unset until ``installInternalConstraints()`` is executed.
    open var captionedImageHeight: NSLayoutConstraint!

    /// The text container edges constraints. Unset until ``installInternalConstraints()`` is
    /// executed.
    open var textContainerContraints: [NSLayoutConstraint]!

    open override func installInternalConstraints() {
      super.installInternalConstraints()

      contentImageView.anchors.top.pin()
      contentImageView.anchors.edges.pin(axis: .horizontal)

      textContainerContraints =
        Constraints {
          textStack?.anchors.edges.pin(axis: .horizontal)
          textStack?.anchors.top.equal(contentImageView.anchors.bottom)
          textStack?.anchors.bottom.pin()
        }.constraints
    }

    // MARK: - Card Update

    /// Updates the cell with the passed captioned image content card.
    /// - Parameters:
    ///   - card: The content card to display.
    ///   - imageLoad: The current image load state.
    open func set(card: Braze.ContentCard.CaptionedImage, imageLoad: AsyncImageView.ImageLoad?) {
      if case .success = imageLoad {
      } else {
        contentImageView.aspectRatio = card.imageAspectRatio ?? 1.0
      }
      contentImageView.imageLoad = imageLoad

      textStack?.titleLabel.text = card.title
      textStack?.descriptionLabel.text = card.description
      textStack?.domainLabel.text = card.domain
      textStack?.domainHidden = card.domain == nil || card.domain == ""

      pinIndicator.isHidden = !card.pinned
      unviewedIndicator.isHidden = card.viewed

      highlightable = card.clickAction != .none
    }

    open override func applyAttributes(_ attributes: Attributes) {
      super.applyAttributes(attributes)

      let padding = attributes.padding
      textContainerContraints[0].constant = padding.left
      textContainerContraints[1].constant = -padding.right
      textContainerContraints[2].constant = padding.top
      textContainerContraints[3].constant = -padding.bottom
    }

  }

}

// MARK: - Previews

#if UI_PREVIEWS

  import SwiftUI

  struct CaptionedImageCell_Previews: PreviewProvider {
    static let cards: [Braze.ContentCard] = [
      .captionedImage(.mockPinned),
      .captionedImage(.mockUnviewed),
      .captionedImage(.mockViewed),
      .captionedImage(.mockDomain),
      .captionedImage(.mockShort),
      .captionedImage(.mockLong),
      .captionedImage(.mockExtraLong),
    ]
    static var previews: some View {
      BrazeContentCardUI.ViewController(initialCards: cards)
        .preview()
    }
  }

#endif
