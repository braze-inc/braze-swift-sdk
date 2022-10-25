import BrazeKit
import UIKit

extension BrazeContentCardUI {

  /// The Content Card cell which displays Classic cards.
  open class ClassicCell: Cell {

    /// The type identifier.
    public static let identifier = "BrazeContentCardUI.ClassicCell"

    // MARK: - Initialization

    /// Initializes the content card cell passing `style` and `reuseIdentifier` to the `super`
    /// implementation.
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)

      // View hierarchy
      let textStack = TextStack()
      self.textStack = textStack
      container.addSubview(textStack)

      installInternalConstraints()
      applyAttributes(attributes)
    }

    /// Does not support interface-builder / storyboards.
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    /// The text stack edges constraints. Unset until ``installInternalConstraints()`` is
    /// executed.
    open var textStackContraints: [NSLayoutConstraint]!

    open override func installInternalConstraints() {
      super.installInternalConstraints()
      textStackContraints = textStack?.anchors.edges.pin()
    }

    // MARK: - Card Update

    /// Updates the cell with the passed classic content card.
    /// - Parameter card: The content card to display.
    open func set(card: Braze.ContentCard.Classic) {
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
      textStackContraints[0].constant = padding.left
      textStackContraints[1].constant = -padding.right
      textStackContraints[2].constant = padding.top
      textStackContraints[3].constant = -padding.bottom
    }

  }

}

// MARK: - Previews

#if UI_PREVIEWS

  import SwiftUI

  struct ClassicCell_Previews: PreviewProvider {
    static let cards: [Braze.ContentCard] = [
      .classic(.mockPinned),
      .classic(.mockUnviewed),
      .classic(.mockViewed),
      .classic(.mockDomain),
      .classic(.mockShort),
      .classic(.mockLong),
      .classic(.mockExtraLong),
    ]
    static var previews: some View {
      BrazeContentCardUI.ViewController(initialCards: cards)
        .preview()
    }
  }

#endif
