import BrazeKit
import BrazeUI
import UIKit

/// A ClassicImageCell subclass which move the image to the trailing part of the cell, make it take
/// the full height of the cell.
class CustomClassicImageCell: BrazeContentCardUI.ClassicImageCell {

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    // Modify stack behavior
    cardStack.alignment = .center
    cardStack.distribution = .fillProportionally

    // Move image to end of the stack view
    contentImageView.removeFromSuperview()
    cardStack.addArrangedSubview(contentImageView)

    // Disable the size constraints on the image view to let the stack view automatically size it.
    NSLayoutConstraint.deactivate(classicImageSize)
  }

  open override func applyAttributes(_ attributes: Attributes) {
    // Remove original padding for super
    var noPadding = attributes
    noPadding.padding = .zero
    super.applyAttributes(noPadding)

    // Use the original left padding for the text stack + support RTL languages
    textStack?.isLayoutMarginsRelativeArrangement = true
    let isRightToLeft =
      UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
    textStack?.layoutMargins = UIEdgeInsets(
      top: 0,
      left: isRightToLeft ? 0 : attributes.padding.left,
      bottom: 0,
      right: !isRightToLeft ? 0 : attributes.padding.right
    )
  }

  override func set(
    card: Braze.ContentCard.ClassicImage,
    imageLoad: AsyncImageView.ImageLoad?
  ) {
    // Customize the title
    var card = card
    card.title = "\(card.title) (subclass)"
    super.set(card: card, imageLoad: imageLoad)
  }

}
