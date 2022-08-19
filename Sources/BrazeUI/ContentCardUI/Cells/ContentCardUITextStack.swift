import UIKit

extension BrazeContentCardUI {

  /// A `UIStackView` subclass used to display a content card's title, description and optionally
  /// domain aligned on the leading vertical axis.
  open class TextStack: UIStackView {

    /// Whether the domain is hidden or not.
    open var domainHidden: Bool {
      get { domainLabel.isHidden }
      set { domainLabel.isHidden = newValue }
    }

    // MARK: - Views

    /// The title label.
    open var titleLabel: UILabel = {
      let label = UILabel()
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping
      label.adjustsFontForContentSizeCategory = true
      return label
    }()

    /// The description label.
    open var descriptionLabel: UILabel = {
      let label = UILabel()
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping
      label.adjustsFontForContentSizeCategory = true
      return label
    }()

    /// The domain label.
    open lazy var domainLabel: UILabel = {
      let label = UILabel()
      label.textColor = self.tintColor
      label.adjustsFontForContentSizeCategory = true
      return label
    }()

    // MARK: - Init

    /// Creates and returns a text stack used to display a content card's title, description and
    /// optionally domain aligned on the leading vertical axis.
    /// - Parameter frame: The view frame.
    public override init(frame: CGRect) {
      super.init(frame: frame)

      axis = .vertical
      alignment = .leading

      addArrangedSubview(titleLabel)
      addArrangedSubview(descriptionLabel)
      addArrangedSubview(domainLabel)

      if #available(iOS 11.0, *) {
        spacing = UIStackView.spacingUseSystem
      } else {
        spacing = 10
      }
    }

    /// Does not support interface-builder / storyboards.
    @available(*, unavailable)
    public required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

}
