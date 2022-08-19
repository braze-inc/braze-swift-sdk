import UIKit

extension BrazeContentCardUI {

  /// The Content Card cell used for Control cards.
  open class ControlCell: UITableViewCell {

    /// The type identifier.
    public static let identifier = "BrazeContentCardUI.ControlCell"

    /// Initializes the content card cell passing `style` and `reuseIdentifier` to the `super`
    /// implementation.
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      backgroundColor = .clear
    }

    /// Does not support interface-builder / storyboards.
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

  }

}
