import BrazeKit
import UIKit

extension BrazeInAppMessageUI {

  /// The view for modal in-app messages.
  ///
  /// The modal view can be customized using the ``attributes-swift.property`` property.
  open class ModalView: UIView, InAppMessageView {

    /// The modal in-app message.
    public var message: Braze.InAppMessage.Modal

    // MARK: - Attributes

    /// The attributes supported by the modal in-app message view.
    ///
    /// Attributes can be updated in multiple ways:
    /// - Via modifying the ``defaults`` static property
    /// - Via implementing the ``BrazeInAppMessageUIDelegate/inAppMessage(_:prepareWith:)-11fog``
    ///   delegate.
    /// - Via modifying the ``BrazeInAppMessageUI/messageView`` attributes on the
    ///   `BrazeInAppMessageUI` instance.
    public struct Attributes {

      /// The minimum spacing around the content view.
      public var margin = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

      /// The spacing around the content's view content.
      public var padding = UIEdgeInsets(top: 40, left: 25, bottom: 30, right: 25)

      /// The spacing between the header and message
      public var labelsSpacing = 10.0

      /// The spacing between the graphic, the labels scroll view and the buttons.
      public var spacing = 20.0

      /// The font for the header.
      public var headerFont = UIFont.preferredFont(textStyle: .title3, weight: .bold)

      /// The font for the message.
      public var messageFont = UIFont.preferredFont(forTextStyle: .subheadline)

      /// The content view corner radius.
      public var cornerRadius = 8.0

      /// The content view shadow.
      public var shadow: Shadow? = Shadow.inAppMessage

      /// The minimum width.
      public var minWidth = 320.0

      /// The maximum width.
      ///
      /// The maximum width is swapped with the maximum height for large UIs (e.g. iPad).
      public var maxWidth = 450.0

      /// The maximum height.
      ///
      /// The maximum height is swapped with the maximum width for large UIs (e.g. iPad).
      public var maxHeight = 720.0

      /// Specify whether the modal in-app message view can be dismissed from a tap with the
      /// view's background.
      public var dismissOnBackgroundTap = false

      /// Closure allowing further customization, executed when the view is about to be presented.
      public var onPresent: ((ModalView) -> Void)?

      /// Closure executed every time the view is laid out.
      public var onLayout: ((ModalView) -> Void)?

      /// Closure executed every time the view update its theme.
      public var onTheme: ((ModalView) -> Void)?

      /// The defaults modal view attributes.
      ///
      /// Modify this value directly to apply the customizations to all modal in-app messages
      /// presented by the SDK.
      public static var defaults = Self()
    }

    public var attributes: Attributes {
      didSet { applyAttributes() }
    }

    open func applyAttributes() {
      // Margin
      layoutMargins = attributes.margin

      // Padding
      let padding = attributes.padding
      let hasImage: Bool
      if case .image = message.graphic {
        hasImage = true
      } else {
        hasImage = false
      }

      contentView.stack.layoutMargins = .init(
        top: hasImage ? 0 : padding.top,
        left: 0,
        bottom: padding.bottom,
        right: 0
      )
      textStack.layoutMargins = .init(
        top: 0,
        left: padding.left,
        bottom: 0,
        right: padding.right
      )
      buttonsContainer?.stack.layoutMargins = .init(
        top: 0,
        left: padding.left,
        bottom: 0,
        right: padding.right
      )

      // Spacings
      textStack.spacing = attributes.labelsSpacing
      contentView.stack.spacing = attributes.spacing

      // Fonts
      headerLabel.font = attributes.headerFont
      messageLabel.font = attributes.messageFont

      // Corner radius
      shadowView.layer.cornerRadius = attributes.cornerRadius
      contentView.layer.cornerRadius = attributes.cornerRadius

      // Shadow
      shadowView.shadow = attributes.shadow

      // Dimensions
      let maxWidth = isLargeLandscape ? attributes.maxHeight : attributes.maxWidth
      let maxHeight = isLargeLandscape ? attributes.maxWidth : attributes.maxHeight
      minWidthConstraint.constant = attributes.minWidth
      maxWidthConstraint.constant = maxWidth
      maxHeightConstraint.constant = maxHeight

      // User interactions
      tapBackgroundGesture.isEnabled = attributes.dismissOnBackgroundTap

      setNeedsLayout()
      layoutIfNeeded()
    }

    // MARK: - Views

    public let gifViewProvider: GIFViewProvider

    public lazy var graphicView: UIView? = {
      switch message.graphic {

      case .icon(let id):
        return IconView(symbol: id, theme: theme)
          .boundedByIntrinsicContentSize()

      case .image(let url):
        let imageView = gifViewProvider.view(url)
        imageView.contentMode = .scaleAspectFit
        return imageView

      default:
        return nil
      }
    }()

    public lazy var headerLabel: UILabel = {
      let label = UILabel()
      label.numberOfLines = 0
      label.adjustsFontForContentSizeCategory = true
      label.attributedText = message.header.attributed {
        $0.lineSpacing = 2
        $0.alignment = message.headerTextAlignment.nsTextAlignment(forTraits: traitCollection)
      }
      label.setContentCompressionResistancePriority(.required, for: .vertical)
      label.setContentHuggingPriority(.required, for: .vertical)
      return label
    }()

    public lazy var messageLabel: UILabel = {
      let label = UILabel()
      label.numberOfLines = 0
      label.adjustsFontForContentSizeCategory = true
      label.attributedText = message.message.attributed {
        $0.lineSpacing = 4
        $0.alignment = message.messageTextAlignment.nsTextAlignment(forTraits: traitCollection)
      }
      label.setContentCompressionResistancePriority(.required, for: .vertical)
      label.setContentHuggingPriority(.required, for: .vertical)
      return label
    }()

    public lazy var textStack: UIStackView = {
      let stack = UIStackView(arrangedSubviews: [headerLabel, messageLabel])
      stack.axis = .vertical
      stack.isLayoutMarginsRelativeArrangement = true
      return stack
    }()

    public lazy var textContainer: UIScrollView = {
      let container = UIScrollView()
      container.addSubview(textStack)
      return container
    }()

    public lazy var buttonsContainer: StackView? = {
      let container = StackView(
        buttons: message.buttons,
        onClick: { [weak self] button in
          guard let self = self else { return }
          self.logClick(buttonId: "\(button.id)")
          self.process(clickAction: button.clickAction, buttonId: "\(button.id)")
          self.dismiss()
        }
      )
      container?.isHidden = message.buttons.isEmpty
      container?.stack.spacing = 10
      container?.stack.isLayoutMarginsRelativeArrangement = true
      return container
    }()

    public lazy var shadowView = ShadowView(.inAppMessage)

    public lazy var contentView: StackView = {
      let view = StackView(
        arrangedSubviews: [
          graphicView,
          textContainer,
          buttonsContainer,
        ]
        .compactMap { $0 }
      )
      view.stack.axis = .vertical
      view.stack.distribution = .fill
      view.stack.isLayoutMarginsRelativeArrangement = true
      view.layer.masksToBounds = true
      view.addSubview(closeButton)
      return view
    }()

    public lazy var closeButton: UIButton = {
      let button = UIButton(type: .custom)
      button.setTitle("✕", for: .normal)
      button.accessibilityLabel = localize(
        "braze.in-app-message.close-button.title",
        for: .inAppMessage
      )
      button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
      button.addAction { [weak self] in self?.dismiss() }
      return button
    }()

    // MARK: - LifeCycle

    public init(
      message: Braze.InAppMessage.Modal,
      attributes: Attributes = .defaults,
      gifViewProvider: GIFViewProvider = .nonAnimating,
      presented: Bool = false
    ) {
      self.message = message
      self.attributes = attributes
      self.gifViewProvider = gifViewProvider
      self.presented = presented

      super.init(frame: .zero)

      addSubview(shadowView)
      addSubview(contentView)
      installInternalConstraints()

      addGestureRecognizer(tapBackgroundGesture)
      contentView.addGestureRecognizer(tapGesture)

      applyTheme()
      applyAttributes()

      alpha = presented ? 1 : 0
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Theme

    public var theme: Braze.InAppMessage.Theme { message.theme(for: traitCollection) }

    open func applyTheme() {
      headerLabel.textColor = theme.headerTextColor.uiColor
      messageLabel.textColor = theme.textColor.uiColor
      closeButton.setTitleColor(theme.closeButtonColor.uiColor, for: .normal)
      contentView.backgroundColor = theme.backgroundColor.uiColor
      backgroundColor = theme.frameColor.uiColor

      attributes.onTheme?(self)
    }

    open override func traitCollectionDidChange(
      _ previousTraitCollection: UITraitCollection?
    ) {
      super.traitCollectionDidChange(previousTraitCollection)
      applyAttributes()
      applyTheme()
    }

    // MARK: - Layout

    open var presentationConstraintsInstalled = false
    var imageConstraint: NSLayoutConstraint?
    var minWidthConstraint: NSLayoutConstraint!
    var maxWidthConstraint: NSLayoutConstraint!
    var maxHeightConstraint: NSLayoutConstraint!
    var contentPositionConstraints: [NSLayoutConstraint]!

    open override func layoutSubviews() {
      super.layoutSubviews()
      installPresentationConstraintsIfNeeded()
      attributes.onLayout?(self)
    }

    open func installInternalConstraints() {
      // Dummy frame for first layout pass
      frame = CGRect(x: 0, y: 0, width: 500, height: 500)
      Constraints {

        // Graphic
        switch (message.graphic, graphicView) {
        case (.image(let url), .some(let imageView)):
          if let imageSize = imageSize(url: url) {
            let aspectRatio = imageSize.width / imageSize.height
            imageConstraint = imageView.anchors.width.equal(
              imageView.anchors.height.multiplied(by: aspectRatio)
            )
          }
        case (.icon, .some(let iconView)):
          iconView.anchors.height.equal(50)
        default:
          break
        }

        // Text
        textStack.anchors.edges.pin()
        textStack.anchors.width.equal(textContainer.anchors.width)
        // - not required priority to allow the text container scrollview to shrink
        textStack.anchors.height.lessThanOrEqual(textContainer.anchors.height).priority =
          .defaultHigh
        let textStackHeightConstraint = textStack.anchors.height.equal(textContainer.anchors.height)
        textStackHeightConstraint.priority = .defaultHigh - 1

        // Close button
        closeButton.anchors.height.equal(closeButton.anchors.width)
        closeButton.anchors.edges.pin(to: contentView.layoutMarginsGuide, alignment: .topTrailing)

        // Content view
        // - dimensions
        minWidthConstraint = contentView.anchors.width.greaterThanOrEqual(attributes.minWidth)
        minWidthConstraint.priority = .defaultHigh
        maxWidthConstraint = contentView.anchors.width.lessThanOrEqual(attributes.maxWidth)
        maxHeightConstraint = contentView.anchors.height.lessThanOrEqual(attributes.maxHeight)
        // - position
        let bottom = contentView.anchors.bottom.lessThanOrEqual(layoutMarginsGuide.anchors.bottom)
        bottom.priority = .defaultHigh
        let centerY = contentView.anchors.centerY.align()
        centerY.priority = .defaultHigh
        contentPositionConstraints = [
          contentView.anchors.top.greaterThanOrEqual(layoutMarginsGuide.anchors.top),
          contentView.anchors.leading.greaterThanOrEqual(layoutMarginsGuide.anchors.leading),
          contentView.anchors.trailing.lessThanOrEqual(layoutMarginsGuide.anchors.trailing),
          bottom,
          contentView.anchors.centerX.align(),
          centerY,
        ]

        // Shadow view
        shadowView.anchors.edges.pin(to: contentView)
      }
    }

    open func installPresentationConstraintsIfNeeded() {
      guard let superview = superview, !presentationConstraintsInstalled else { return }
      presentationConstraintsInstalled = true
      anchors.edges.pin()
      setNeedsLayout()
      superview.layoutIfNeeded()
    }

    // MARK: - Presentation / InAppMessageView conformance

    public var presented: Bool = false {
      didSet { alpha = presented ? 1 : 0 }
    }

    public func present(completion: (() -> Void)?) {
      installPresentationConstraintsIfNeeded()

      willPresent()
      attributes.onPresent?(self)

      UIView.performWithoutAnimation {
        superview?.layoutIfNeeded()
      }

      makeKey()

      UIView.animate(
        withDuration: message.animateIn ? 0.25 : 0,
        animations: { self.presented = true },
        completion: { _ in
          self.logImpression()
          completion?()
          self.didPresent()
        }
      )
    }

    @objc
    public func dismiss(completion: (() -> Void)? = nil) {
      isUserInteractionEnabled = false
      willDismiss()
      UIView.animate(
        withDuration: message.animateOut ? 0.25 : 0,
        animations: { self.presented = false },
        completion: { _ in
          completion?()
          self.didDismiss()
        }
      )
    }

    // MARK: - User Interactions

    open lazy var tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(tap)
    )

    @objc
    func tap(_ gesture: UITapGestureRecognizer) {
      guard gesture.state == .ended else {
        return
      }
      logClick()
      process(clickAction: message.clickAction)
      dismiss()
    }

    open lazy var tapBackgroundGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(tapBackground)
    )

    @objc
    func tapBackground(_ gesture: UITapGestureRecognizer) {
      guard gesture.state == .ended else {
        return
      }
      dismiss()
    }
  }

}

// MARK: - Previews

#if UI_PREVIEWS
  import SwiftUI

  @available(iOS 13.0, *)
  struct ModalView_Previews: PreviewProvider {
    typealias ModalView = BrazeInAppMessageUI.ModalView

    static var previews: some View {
      Group {
        variationPreviews
        //      dimensionPreviews
        //      rightToLeftPreviews
        //      themePreviews
      }
    }

    @ViewBuilder
    static var variationPreviews: some View {
      ModalView(message: .mock, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 300)
        .previewDisplayName("Var. | Default")

      ModalView(message: .mockOneButton, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 300)
        .previewDisplayName("Var. | 1 Button")

      ModalView(message: .mockTwoButtons, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 300)
        .previewDisplayName("Var. | 2 Buttons")

      ModalView(message: .mockIcon, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 370)
        .previewDisplayName("Var. | Icon")

      ModalView(message: .mockImage, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 400)
        .previewDisplayName("Var. | Image")

      ModalView(message: .mockImageWrongAspectRatio, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 400)
        .previewDisplayName("Var. | Image (wrong aspect ratio)")

      ModalView(message: .mockLeadingAligned, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 370)
        .previewDisplayName("Var. | Leading alignment")

      ModalView(message: .mockLong, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 375)
        .previewDisplayName("Var. | Long (constrained)")
    }

    @ViewBuilder
    static var dimensionPreviews: some View {
      ModalView(message: .mockIcon, presented: true)
        .preview(center: .required)
        .frame(width: 540, height: 430)
        .previewDisplayName("Dimension | Small")

      ModalView(message: .mockLong, presented: true)
        .preview(center: .required)
        .frame(width: 540, height: 800)
        .previewDisplayName("Dimensions | Large")
    }

    // OpenRadar: https://archive.md/zr3l4
    // swift-snapshot-testing issue: https://archive.md/dnUQM
    @ViewBuilder
    static var rightToLeftPreviews: some View {
      ModalView(message: .mockIcon, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 370)
        .environment(\.layoutDirection, .rightToLeft)
        .previewDisplayName("RTL Support | Default")
    }

    @ViewBuilder
    static var themePreviews: some View {
      ModalView(message: .mockIcon, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 370)
        .preferredColorScheme(.light)
        .previewDisplayName("Theme | Light")

      ModalView(message: .mockIcon, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 370)
        .preferredColorScheme(.dark)
        .previewDisplayName("Theme | Dark")

      ModalView(message: .mockThemed, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 370)
        .previewDisplayName("Theme | Custom")
    }

  }

#endif
