import BrazeKit
import UIKit

extension BrazeInAppMessageUI {

  /// The view for modal image in-app messages.
  ///
  /// The modal image view can be customized using the ``attributes-swift.property`` property.
  open class ModalImageView: UIView, InAppMessageView {

    /// The modal image in-app message.
    public var message: Braze.InAppMessage.ModalImage

    // MARK: - Attributes

    /// The attributes supported by the modal image in-app message view.
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
      public var padding = UIEdgeInsets(top: 0, left: 25, bottom: 30, right: 25)

      /// The content view corner radius.
      public var cornerRadius = 8.0

      /// The content view corner curve.
      @available(iOS 13.0, *)
      public var cornerCurve: CALayerCornerCurve {
        get { CALayerCornerCurve(rawValue: _cornerCurve) }
        set { _cornerCurve = newValue.rawValue }
      }
      var _cornerCurve: String = "circular"

      /// The content view shadow.
      public var shadow: Shadow? = Shadow.inAppMessage

      /// The minimum width.
      public var minWidth: ViewDimension = 320.0

      /// The maximum width.
      ///
      /// The maximum width is swapped with the maximum height for large UIs (e.g. iPad).
      public var maxWidth: ViewDimension = .init(regular: 450.0, large: 720.0)

      /// The maximum height.
      ///
      /// The maximum height is swapped with the maximum width for large UIs (e.g. iPad).
      public var maxHeight: ViewDimension = .init(regular: 720.0, large: 450.0)

      /// Specify whether the modal image in-app message view displays the image in a scroll view
      /// for large images.
      public var scrollLargeImages = false

      /// Specify whether the modal image in-app message view can be dismissed from a tap with the
      /// view's background.
      public var dismissOnBackgroundTap = false

      /// The buttons attributes.
      public var buttonsAttributes = ButtonView.Attributes.defaults

      /// Closure allowing further customization, executed when the view is about to be presented.
      public var onPresent: ((ModalImageView) -> Void)?

      /// Closure executed every time the view is laid out.
      public var onLayout: ((ModalImageView) -> Void)?

      /// Closure executed every time the view update its theme.
      public var onTheme: ((ModalImageView) -> Void)?

      /// The defaults modal image view attributes.
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
      buttonsContainer?.layoutMargins = attributes.padding

      // Corner radius
      shadowView.layer.cornerRadius = attributes.cornerRadius
      contentView.layer.cornerRadius = attributes.cornerRadius

      // Corner curve
      if #available(iOS 13.0, *) {
        shadowView.layer.cornerCurve = attributes.cornerCurve
        contentView.layer.cornerCurve = attributes.cornerCurve
      }

      // Shadow
      shadowView.shadow = attributes.shadow

      // Dimensions
      let minWidth = isLargeLandscape ? attributes.minWidth.large : attributes.minWidth.regular
      let maxWidth = isLargeLandscape ? attributes.maxHeight.large : attributes.maxWidth.regular
      let maxHeight = isLargeLandscape ? attributes.maxWidth.large : attributes.maxHeight.regular
      minWidthConstraint.constant = minWidth
      maxWidthConstraint.constant = maxWidth
      maxHeightConstraint.constant = maxHeight

      // Scroll large image
      imageContainerView.isScrollEnabled = attributes.scrollLargeImages
      imageCenterConstraints.forEach {
        $0.isActive = !attributes.scrollLargeImages
      }

      // User interactions
      tapBackgroundGesture.isEnabled = attributes.dismissOnBackgroundTap

      // Buttons
      buttons.forEach { $0.attributes = attributes.buttonsAttributes }

      setNeedsLayout()
      layoutIfNeeded()
    }

    // MARK: - Views

    let gifViewProvider: GIFViewProvider

    public lazy var imageView: UIView = {
      let imageView = gifViewProvider.view(message.imageURL)
      imageView.contentMode = .scaleAspectFill
      return imageView
    }()

    public lazy var imageContainerView: UIScrollView = {
      let view = UIScrollView()
      view.addSubview(imageView)
      if #available(iOS 11, *) {
        view.contentInsetAdjustmentBehavior = .never
      } else {
        // No need for iOS 10 support.
        // No devices supporting iOS 10 has a need for safe-area handling.
      }
      return view
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
      container?.stack.spacing = 10
      return container
    }()

    public var buttons: [ButtonView] {
      buttonsContainer?.stack.arrangedSubviews.compactMap {
        ($0 as? ButtonView)
          ?? $0.bfsSubviews.lazy.compactMap { $0 as? ButtonView }.first { _ in true }
      } ?? []
    }

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

    public lazy var shadowView = ShadowView(.inAppMessage)

    public lazy var contentView: UIView = {
      let view = UIView()
      view.addSubview(imageContainerView)
      if let buttonsContainer = buttonsContainer {
        view.addSubview(buttonsContainer)
      }
      view.addSubview(closeButton)
      view.clipsToBounds = true
      return view
    }()

    // MARK: - LifeCycle

    public init(
      message: Braze.InAppMessage.ModalImage,
      attributes: Attributes = .defaults,
      gifViewProvider: GIFViewProvider = .shared,
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
    var minWidthConstraint: NSLayoutConstraint!
    var maxWidthConstraint: NSLayoutConstraint!
    var maxHeightConstraint: NSLayoutConstraint!
    var imageAspectRatioConstraint: NSLayoutConstraint!
    var imageCenterConstraints: [NSLayoutConstraint]!
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
        // ImageView
        if let imageSize = imageSize(url: message.imageURL) {
          let aspectRatio = imageSize.width / imageSize.height
          imageAspectRatioConstraint = imageView.anchors.width.equal(
            imageView.anchors.height.multiplied(by: aspectRatio)
          )
          imageAspectRatioConstraint.priority = .defaultHigh + 1
        }
        imageView.anchors.edges.pin()
        imageView.anchors.width.equal(imageContainerView.anchors.width)
        imageView.anchors.height.equal(imageContainerView.anchors.height).priority = .defaultHigh
        imageCenterConstraints = imageView.anchors.center.align()

        // Container scrollview
        imageContainerView.anchors.edges.pin()
        // - dimensions
        minWidthConstraint = imageContainerView.anchors.width.greaterThanOrEqual(
          attributes.minWidth.regular)
        minWidthConstraint.priority = .defaultHigh
        maxWidthConstraint = imageContainerView.anchors.width.lessThanOrEqual(
          attributes.maxWidth.regular
        )
        maxHeightConstraint = imageContainerView.anchors.height.lessThanOrEqual(
          attributes.maxHeight.regular
        )

        // Buttons
        buttonsContainer?.anchors.edges.pin(
          to: contentView.layoutMarginsGuide,
          alignment: .bottom
        )

        // Close button
        closeButton.anchors.height.equal(closeButton.anchors.width)
        closeButton.anchors.edges.pin(
          to: contentView.layoutMarginsGuide,
          alignment: .topTrailing
        )

        // Content view
        let verticalEdges = contentView.anchors.edges.pin(to: layoutMarginsGuide, axis: .vertical)
        verticalEdges.forEach { $0.priority = .defaultHigh }
        let horizontalEdges = contentView.anchors.edges.pin(
          to: layoutMarginsGuide, axis: .horizontal)
        horizontalEdges.forEach { $0.priority = .defaultHigh + 1 }
        contentPositionConstraints =
          verticalEdges
          + horizontalEdges
          + contentView.anchors.edges.lessThanOrEqual(layoutMarginsGuide)
          + contentView.anchors.center.align()

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
  struct ModalImageView_Previews: PreviewProvider {
    typealias ModalImageView = BrazeInAppMessageUI.ModalImageView

    static var previews: some View {
      Group {
        dimensionsPreviews
        customPreviews
      }
    }

    @ViewBuilder
    static var dimensionsPreviews: some View {
      ModalImageView(message: .mock, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 800)
        .previewDisplayName("Dimension | Square")

      ModalImageView(message: .mockLargeImage, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 800)
        .previewDisplayName("Dimension | Large")

      ModalImageView(message: .mockExtraLargeImage, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 800)
        .previewDisplayName("Dimension | Extra Large")
    }

    static var customPreviews: some View {
      var attributes = ModalImageView.Attributes()
      attributes.scrollLargeImages = true

      return ModalImageView(
        message: .mockExtraLargeImage,
        attributes: attributes,
        presented: true
      )
      .preview(center: .required)
      .frame(maxHeight: 800)
      .previewDisplayName("Custom | Scroll Large Images")
    }

  }

  /// Typealiases to help Xcode build previews
  extension BrazeInAppMessageUI.ModalImageView {
    public typealias ButtonView = BrazeInAppMessageUI.ButtonView
  }

#endif
