import BrazeKit
import UIKit

extension BrazeContentCardUI {

  /// The Content Card cell which displays Classic Image cards.
  open class ClassicImageCell: ImageCell {

    /// The type identifier.
    public static let identifier = "BrazeContentCardUI.ClassicImageCell"

    // MARK: - Views

    /// The horizontal stack view containing the image and the text stack.
    open var cardStack: UIStackView = {
      let stack = UIStackView()
      stack.axis = .horizontal
      stack.spacing = 12
      stack.alignment = .top
      return stack
    }()

    // MARK: - Initialization

    /// Initializes the content card cell passing `style` and `reuseIdentifier` to the `super`
    /// implementation.
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)

      // View hierachy
      let textStack = TextStack()
      self.textStack = textStack

      contentImageView.fixedAspectRatio = 1.0
      contentImageView.activityIndicator.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

      cardStack.addArrangedSubview(contentImageView)
      cardStack.addArrangedSubview(textStack)
      container.addSubview(cardStack)

      installInternalConstraints()
      applyAttributes(attributes)
    }

    /// Does not support interface-builder / storyboards.
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    /// The horizontal stack edges constraints. Unset until ``installInternalConstraints()`` is
    /// executed.
    open var cardStackConstraints: [NSLayoutConstraint]!

    /// The classic image size constraints. Unset until ``installInternalConstraints()`` is
    /// executed.
    open var classicImageSize: [NSLayoutConstraint]!

    open override func installInternalConstraints() {
      super.installInternalConstraints()
      classicImageSize = contentImageView.anchors.size.equal(CGSize(width: 10, height: 10))
      cardStackConstraints = cardStack.anchors.edges.pin()
    }

    // MARK: - Card Update

    /// Updates the cell with the passed classic image content card.
    /// - Parameters:
    ///   - card: The content card to display.
    ///   - imageLoad: The current image load state.
    open func set(card: Braze.ContentCard.ClassicImage, imageLoad: AsyncImageView.ImageLoad?) {
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
      cardStackConstraints[0].constant = padding.left
      cardStackConstraints[1].constant = -padding.right
      cardStackConstraints[2].constant = padding.top
      cardStackConstraints[3].constant = -padding.bottom

      contentImageView.imageCornerRadius = attributes.classicImageCornerRadius
      classicImageSize[0].constant = attributes.classicImageSize.width
      classicImageSize[1].constant = attributes.classicImageSize.height

      cardStack.spacing = attributes.classicImageTextSpacing
    }

  }

}

// MARK: - Previews

#if UI_PREVIEWS

  import SwiftUI

  struct ClassicImageCell_Previews: PreviewProvider {
    static let cards: [Braze.ContentCard] = [
      .classicImage(.mockPinned),
      .classicImage(.mockUnviewed),
      .classicImage(.mockViewed),
      .classicImage(.mockDomain),
      .classicImage(.mockShort),
      .classicImage(.mockLong),
      .classicImage(.mockExtraLong),
    ]
    static var previews: some View {
      BrazeContentCardUI.ViewController(initialCards: cards)
        .preview()
    }
  }

#endif
