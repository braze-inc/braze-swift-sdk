import UIKit

extension BrazeContentCardUI {

  /// The base Content Card cell.
  ///
  /// This class implements the common appearance and logic needed for displaying content cards. It
  /// **does not support** displaying content cards directly. Use one of the available subclass to
  /// do so.
  open class Cell: UITableViewCell {

    // MARK: - Attributes

    /// The attributes supported by content card cell.
    ///
    /// Attributes allows customizing the cells.
    public struct Attributes: Equatable {

      /// The spacing around the content view.
      public var margin: Margin = .layoutMargins(
        UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
      )

      /// The spacing around the content's view content.
      public var padding: UIEdgeInsets = UIEdgeInsets(top: 20, left: 25, bottom: 25, right: 25)

      /// The maximum width.
      public var maxWidth: Double? = nil

      /// The background color.
      public var backgroundColor: UIColor = .brazeCellBackgroundColor

      /// The border color.
      public var borderColor: UIColor = .brazeCellBorderColor

      /// The border width.
      public var borderWidth: Double = 1

      /// The corner radius.
      public var cornerRadius: Double = 3

      /// The corner curve.
      @available(iOS 13.0, *)
      public var cornerCurve: CALayerCornerCurve {
        get { CALayerCornerCurve(rawValue: _cornerCurve) }
        set { _cornerCurve = newValue.rawValue }
      }
      var _cornerCurve: String = "circular"

      /// The shadow.
      public var shadow: Shadow? = .contentCard

      /// The color for the highlighted / selected state.
      ///
      /// Disable the highlighted state by setting this value to `UIColor.clear`.
      public var highlightColor: UIColor = .brazeCellHighlightColor

      /// The pin indicator color, use the cell's `tintColor` when nil.
      ///
      /// Requires ``pinIndicatorImage`` to be rendered as a template image using
      /// [`withRenderingMode(_:)`](https://apple.co/3LMOgfZ).
      public var pinIndicatorColor: UIColor?

      /// The pin indicator image, use the default pin indicator image when nil.
      public var pinIndicatorImage: UIImage?

      /// The unviewed indicator color, use the cell's `tintColor` when nil.
      public var unviewedIndicatorColor: UIColor?

      /// The unviewed indicator height.
      public var unviewedIndicatorHeight: Double = 8

      /// The title's font.
      public var titleFont: UIFont = .preferredFont(textStyle: .callout, weight: .bold)

      /// The title's color.
      public var titleColor: UIColor = .brazeLabel

      /// The description's font.
      public var descriptionFont: UIFont = .preferredFont(textStyle: .footnote, weight: .regular)

      /// The description's color.
      public var descriptionColor: UIColor = .brazeLabel

      /// The domain's font.
      public var domainFont: UIFont = .preferredFont(textStyle: .footnote, weight: .medium)

      /// The domain's color, use the cell's `tintColor` when nil.
      public var domainColor: UIColor?

      /// The size for the image in ``BrazeContentCardUI/ClassicImageCell``.
      public var classicImageSize: CGSize = CGSize(width: 57.5, height: 57.5)

      /// The corner radius for the image in ``BrazeContentCardUI/ClassicImageCell``.
      public var classicImageCornerRadius: Double = 3

      /// The spacing between the image and the text in ``BrazeContentCardUI/ClassicImageCell``.
      public var classicImageTextSpacing: Double = 12

      /// The default attributes.
      public static let defaults = Self()
    }

    /// The margin type
    public enum Margin: Equatable {

      /// Use the `layoutMarginsGuide`.
      case layoutMargins(UIEdgeInsets)

      /// Use the edges of the cells.
      case edges(UIEdgeInsets)

      /// Margin insets.
      public var insets: UIEdgeInsets {
        switch self {
        case .layoutMargins(let insets), .edges(let insets):
          return insets
        }
      }
    }

    /// The cell attributes. See ``Attributes-swift.struct``.
    open var attributes: Attributes = .init() {
      didSet {
        guard attributes != oldValue else { return }
        applyAttributes(attributes)
      }
    }

    /// Apply the current attributes.
    open func applyAttributes(_ attributes: Attributes) {
      // Margin
      switch attributes.margin {
      case .layoutMargins(let insets):
        layoutContainerEdges[0].constant = insets.left
        layoutContainerEdges[1].constant = -insets.right
        NSLayoutConstraint.deactivate(edgesContainerEdges)
        NSLayoutConstraint.activate(layoutContainerEdges)
      case .edges(let insets):
        edgesContainerEdges[0].constant = insets.left
        edgesContainerEdges[1].constant = -insets.right
        NSLayoutConstraint.deactivate(layoutContainerEdges)
        NSLayoutConstraint.activate(edgesContainerEdges)
      }
      if containerVerticalEdges[0].constant != attributes.margin.insets.top {
        containerVerticalEdges[0].constant = attributes.margin.insets.top
      }
      if containerVerticalEdges[1].constant != attributes.margin.insets.bottom {
        containerVerticalEdges[1].constant = -attributes.margin.insets.bottom
      }

      if let maxWidth = attributes.maxWidth {
        containerMaxWidth.constant = maxWidth
        NSLayoutConstraint.activate([containerMaxWidth])
      } else {
        NSLayoutConstraint.deactivate([containerMaxWidth])
      }

      // Background color
      containerBackground.backgroundColor = attributes.backgroundColor

      // Border
      containerBackground.layer.borderColor =
        attributes.borderColor.brazeResolvedColor(with: traitCollection).cgColor
      containerBackground.layer.borderWidth = attributes.borderWidth

      // Corners
      containerBackground.layer.cornerRadius = attributes.cornerRadius
      container.layer.cornerRadius = attributes.cornerRadius
      if #available(iOS 13.0, *) {
        containerBackground.layer.cornerCurve = attributes.cornerCurve
        container.layer.cornerCurve = attributes.cornerCurve
      }

      // Shadow
      (containerBackground as? ShadowView)?.shadow = attributes.shadow

      // Pin indicator
      pinIndicator.tintColor = attributes.pinIndicatorColor ?? tintColor
      pinIndicator.image = attributes.pinIndicatorImage ?? pinIndicator.image

      // Unviewed indicator
      unviewedIndicator.backgroundColor = attributes.unviewedIndicatorColor ?? tintColor
      unviewedIndicatorHeight.constant = attributes.unviewedIndicatorHeight

      // Text customization (if implemented by subclass)
      textStack?.titleLabel.font = attributes.titleFont
      textStack?.titleLabel.textColor = attributes.titleColor
      textStack?.descriptionLabel.font = attributes.descriptionFont
      textStack?.descriptionLabel.textColor = attributes.descriptionColor
      textStack?.domainLabel.font = attributes.domainFont
      textStack?.domainLabel.textColor = attributes.domainColor ?? tintColor
    }

    // MARK: - Views

    /// The pin indicator image view.
    open lazy var pinIndicator: UIImageView = {
      let image = UIImage(
        named: "ContentCard/pin",
        in: resourcesBundle,
        compatibleWith: traitCollection
      )?
      .withRenderingMode(.alwaysTemplate)
      .imageFlippedForRightToLeftLayoutDirection()
      let view = UIImageView(image: image)
      return view
    }()

    /// The unviewed indicator view.
    open lazy var unviewedIndicator: UIView = {
      let view = UIView()
      view.backgroundColor = self.tintColor
      return view
    }()

    /// The container view.
    open lazy var container: UIView = {
      let view = UIView()
      view.addSubview(pinIndicator)
      view.addSubview(unviewedIndicator)
      view.layer.cornerRadius = 3
      view.layer.masksToBounds = true
      return view
    }()

    /// The container background view, containing the container.
    open lazy var containerBackground: UIView = {
      let view = ShadowView(.contentCard)
      view.backgroundColor = .brazeCellBackgroundColor
      view.layer.cornerRadius = 3
      view.layer.borderColor = .brazeCellBorderColor(traitCollection)
      view.layer.borderWidth = 1
      view.addSubview(container)
      return view
    }()

    /// The optional text stack.
    open var textStack: TextStack?

    /// The viewed state, hides / displays the unviewed indicator.
    open var viewed: Bool {
      get { unviewedIndicator.isHidden }
      set { unviewedIndicator.isHidden = newValue }
    }

    // MARK: - Init

    /// Initializes the content card cell passing `style` and `reuseIdentifier` to the `super`
    /// implementation.
    ///
    /// This class implements the common appearance and logic needed for displaying content cards.
    /// The base ``BrazeContentCardUI/Cell`` class **does not support** displaying content cards
    /// directly. Use one of the available subclass to do so.
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)

      contentView.addSubview(containerBackground)

      selectionStyle = .none
      backgroundColor = .clear
    }

    /// Does not support interface-builder / storyboards.
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    /// The unviewed indicator height constraint. Unset until ``installInternalConstraints()`` is
    /// executed.
    open var unviewedIndicatorHeight: NSLayoutConstraint!

    /// The horizontal constraints to the content view layout margin guide. Unset until
    /// ``installInternalConstraints()`` is executed.
    open var layoutContainerEdges: [NSLayoutConstraint]!

    /// The horizontal constraints to the content view edges. Unset until
    /// ``installInternalConstraints()`` is executed.
    open var edgesContainerEdges: [NSLayoutConstraint]!

    /// The vertical constraints to the content view edges. Unset until
    /// ``installInternalConstraints()`` is executed.
    open var containerVerticalEdges: [NSLayoutConstraint]!

    /// The max width constraint. Unset until ``installInternalConstraints()`` is
    /// executed.
    open var containerMaxWidth: NSLayoutConstraint!

    /// Install the internal auto-layout constraints.
    ///
    /// The base ``BrazeContentCardUI/Cell`` class never calls this method. It is the subclass
    /// responsibility to optionally override the implementation and call it when appropriate,
    /// usually after all views have been added to the view hierarchy, at the end of the
    /// initializer.
    open func installInternalConstraints() {
      Constraints(activate: false) {
        layoutContainerEdges = containerBackground.anchors.edges.pin(
          to: contentView.layoutMarginsGuide,
          axis: .horizontal
        )
        edgesContainerEdges = containerBackground.anchors.edges.pin(axis: .horizontal)
        containerMaxWidth = containerBackground.anchors.width.lessThanOrEqual(100)
      }
      // Lower priority to allow the max width constraint to work
      (layoutContainerEdges + edgesContainerEdges).forEach { $0.priority = .required - 1 }

      Constraints {
        container.anchors.edges.pin()

        containerBackground.anchors.centerX.align()
        containerVerticalEdges = containerBackground.anchors.edges.pin(axis: .vertical)

        unviewedIndicatorHeight = unviewedIndicator.anchors.height.equal(
          attributes.unviewedIndicatorHeight
        )
        unviewedIndicator.anchors.edges.pin(axis: .horizontal)
        unviewedIndicator.anchors.bottom.pin()

        pinIndicator.anchors.edges.pin(alignment: .topTrailing)
      }
    }

    // MARK: - Theme

    /// See [`traitCollectionDidChange(_:)`](https://developer.apple.com/documentation/uikit/uitraitenvironment/1623516-traitcollectiondidchange)
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      super.traitCollectionDidChange(previousTraitCollection)
      applyAttributes(attributes)
    }

    /// See [`tintColorDidChange()`](https://developer.apple.com/documentation/uikit/uiview/1622620-tintcolordidchange)
    open override func tintColorDidChange() {
      super.tintColorDidChange()
      applyAttributes(attributes)
    }

    // MARK: - User Interactions

    /// Whether the cell can be highlighted or not. By default, content cards without click action
    /// are not highlightable.
    open var highlightable: Bool = true

    /// The animator driving the highlighted state.
    open var highlightedAnimator: UIViewPropertyAnimator?

    /// See [`setHighlighted(_:animated:)`](https://developer.apple.com/documentation/uikit/uitableviewcell/1623280-sethighlighted)
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
      super.setHighlighted(highlighted, animated: animated)

      highlightedAnimator?.stopAnimation(true)

      guard highlightable else {
        containerBackground.backgroundColor = attributes.backgroundColor
        return
      }

      if highlighted {
        self.containerBackground.backgroundColor = self.attributes.highlightColor
      } else {
        highlightedAnimator = UIViewPropertyAnimator(duration: 0.25, curve: .easeOut) {
          self.containerBackground.backgroundColor = self.attributes.backgroundColor
        }
        highlightedAnimator?.startAnimation()
      }
    }

    /// Overrides `UIView.hitTest(_:with:)` default implementation to ignore touches outside of the
    /// ``container`` view.
    ///
    /// See [`hitTest(_:with:)`](https://developer.apple.com/documentation/uikit/uiview/1622469-hittest)
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
      let view = super.hitTest(point, with: event)
      return (view == container || view?.responders.lazy.contains(container) == true) ? view : nil
    }

  }

}
