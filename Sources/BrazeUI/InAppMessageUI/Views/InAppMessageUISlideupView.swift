import BrazeKit
import UIKit

extension BrazeInAppMessageUI {

  /// The view for slideup in-app messages.
  ///
  /// The slideup view can be customized using the ``attributes-swift.property`` property.
  open class SlideupView: UIView, InAppMessageView {

    /// The slideup in-app message.
    public let message: Braze.InAppMessage.Slideup

    // MARK: - Attributes

    /// The attributes supported by the slideup in-app message view.
    ///
    /// Attributes can be updated in multiple ways:
    /// - Via modifying the ``defaults`` static property
    /// - Via implementing the ``BrazeInAppMessageUIDelegate/inAppMessage(_:prepareWith:)-11fog``
    ///   delegate.
    /// - Via modifying the ``BrazeInAppMessageUI/messageView`` attributes on the
    ///   `BrazeInAppMessageUI` instance.
    public struct Attributes {

      /// The minimum spacing around the content view.
      public var margin = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

      /// The spacing around the content's view content.
      public var padding = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)

      /// The leading padding when the view is displaying a graphic (icon or image)
      public var graphicLeadingPadding = 15.0

      /// The spacing between the graphic view, the body and the chevron.
      public var spacing = 10.0

      /// The font for the body.
      public var font = UIFont.preferredFont(textStyle: .subheadline, weight: .bold)

      /// The image size.
      public var imageSize = CGSize(width: 50, height: 50)

      /// The image view corner radius.
      public var imageCornerRadius = 0.0

      /// The image view corner curve.
      @available(iOS 13.0, *)
      public var imageCornerCurve: CALayerCornerCurve {
        get { CALayerCornerCurve(rawValue: _imageCornerCurve) }
        set { _imageCornerCurve = newValue.rawValue }
      }
      var _imageCornerCurve: String = "circular"

      /// The chevron visibility.
      public var chevronVisibility: ChevronVisibility = .auto

      /// The content view corner radius.
      public var cornerRadius = 15.0

      /// The content view corner curve.
      @available(iOS 13.0, *)
      public var cornerCurve: CALayerCornerCurve {
        get { CALayerCornerCurve(rawValue: _cornerCurve) }
        set { _cornerCurve = newValue.rawValue }
      }
      var _cornerCurve: String = "circular"

      /// Specifies whether the slideup can be dismissed by the user.
      public var dismissible = true

      /// The content view shadow.
      public var shadow: Shadow? = .inAppMessage

      /// The minimum height.
      public var minHeight = 60.0

      /// The maximum width.
      public var maxWidth = 450.0

      /// Closure allowing further customization, executed when the view is about to be presented.
      public var onPresent: ((SlideupView) -> Void)?

      /// Closure executed every time the view is laid out.
      public var onLayout: ((SlideupView) -> Void)?

      /// Closure executed every time the view update its theme.
      public var onTheme: ((SlideupView) -> Void)?

      /// The defaults slideup view attributes.
      ///
      /// Modify this value directly to apply the customizations to all slideup in-app messages
      /// presented by the SDK.
      public static var defaults = Self()

    }

    /// Visibility options supported for the chevron.
    public enum ChevronVisibility {

      /// Visible when the message has a click action, hidden otherwise.
      case auto

      /// Always hidden.
      case hidden

      /// Always visible.
      case visible
    }

    /// The view attributes. See ``Attributes-swift.struct``.
    public var attributes: Attributes {
      didSet { applyAttributes() }
    }

    open func applyAttributes() {
      // Margin
      layoutMargins = attributes.margin

      // Padding
      contentView.stack.layoutMargins = UIEdgeInsets(
        top: attributes.padding.top,
        left: message.graphic != nil
          ? attributes.graphicLeadingPadding
          : attributes.padding.left,
        bottom: attributes.padding.bottom,
        right: attributes.padding.right
      )

      // Spacing
      contentView.stack.spacing = attributes.spacing

      // Fonts
      messageLabel.font = attributes.font

      // Image size
      imageWidthConstraint?.constant = attributes.imageSize.width
      imageHeightConstraint?.constant = attributes.imageSize.height

      // Chevron
      chevronView.isHidden =
        attributes.chevronVisibility == .hidden
        || (attributes.chevronVisibility == .auto && message.clickAction == .none)

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
      maxWidthConstraints.forEach { $0.constant = attributes.maxWidth }
      minHeightConstraint.constant = attributes.minHeight

      // Image
      if case .image = message.graphic {
        graphicView?.layer.cornerRadius = attributes.imageCornerRadius
      } else {
        graphicView?.layer.cornerRadius = 0
      }
      if #available(iOS 13.0, *) {
        graphicView?.layer.cornerCurve = attributes.imageCornerCurve
      }

      setNeedsLayout()
      layoutIfNeeded()
    }

    // MARK: - Views

    let gifViewProvider: GIFViewProvider

    var highlighted: Bool = false {
      didSet {
        let alpha = highlighted ? 0.7 : 1
        let duration = highlighted ? 0.15 : 0.3
        UIView.animate(withDuration: duration) {
          self.messageLabel.alpha = alpha
          self.chevronView.alpha = alpha
        }
      }
    }

    open lazy var graphicView: UIView? = {
      switch message.graphic {
      case .icon(let id):
        return IconView(symbol: id, theme: theme)
      case .image(let url):
        let imageView = self.gifViewProvider.view(url)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
      default:
        return nil
      }
    }()

    open lazy var messageLabel: UILabel = {
      let label = UILabel()
      label.font = attributes.font
      label.numberOfLines = 3
      label.adjustsFontForContentSizeCategory = true
      label.attributedText = message.message.attributed {
        $0.lineSpacing = 2
        $0.lineBreakMode = .byTruncatingTail
      }
      label.setContentCompressionResistancePriority(.required, for: .horizontal)
      return label
    }()

    open lazy var chevronView: UIImageView = {
      let image = UIImage(
        named: "InAppMessage/chevron",
        in: resourcesBundle,
        compatibleWith: traitCollection
      )?
      .withRenderingMode(.alwaysTemplate)
      .imageFlippedForRightToLeftLayoutDirection()
      let view = UIImageView(image: image)
      view.isHidden = message.clickAction == .none
      return view
    }()

    open lazy var shadowView = ShadowView(.inAppMessage)

    open lazy var contentView: StackView = {
      let view = StackView(
        arrangedSubviews: [
          graphicView,
          messageLabel,
          chevronView,
        ]
        .compactMap { $0 }
      )
      view.stack.alignment = .center
      view.stack.distribution = .fill
      view.stack.isLayoutMarginsRelativeArrangement = true
      return view
    }()

    // MARK: - LifeCycle

    public init(
      message: Braze.InAppMessage.Slideup,
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

      contentView.addGestureRecognizer(panGesture)
      contentView.addGestureRecognizer(pressGesture)

      applyTheme()
      applyAttributes()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Theme

    public var theme: Braze.InAppMessage.Theme { message.theme(for: traitCollection) }

    open func applyTheme() {
      messageLabel.textColor = theme.textColor.uiColor
      chevronView.tintColor = theme.closeButtonColor.uiColor
      contentView.backgroundColor = theme.backgroundColor.uiColor

      attributes.onTheme?(self)
    }

    open override func traitCollectionDidChange(
      _ previousTraitCollection: UITraitCollection?
    ) {
      super.traitCollectionDidChange(previousTraitCollection)
      applyTheme()
    }

    // MARK: - Layout

    open var presentationConstraintsInstalled = false
    open var innerYConstraint: NSLayoutConstraint!
    open var outerYConstraint: NSLayoutConstraint!
    var maxWidthConstraints: [NSLayoutConstraint]!
    var minHeightConstraint: NSLayoutConstraint!
    var imageWidthConstraint: NSLayoutConstraint?
    var imageHeightConstraint: NSLayoutConstraint?

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
        switch graphicView {
        case let imageView as UIImageView:
          imageWidthConstraint = imageView.anchors.width.equal(attributes.imageSize.width)
          imageHeightConstraint = imageView.anchors.height.equal(attributes.imageSize.height)
        default:
          break
        }

        // Chevron
        chevronView.anchors.size.equal(CGSize(width: 12, height: 20))

        // Content view
        // - dimensions
        let lessWidthConstraint = contentView.anchors.width.lessThanOrEqual(attributes.maxWidth)
        let equalWidthConstraint = contentView.anchors.width.equal(attributes.maxWidth)
        equalWidthConstraint.priority = .required - 1
        maxWidthConstraints = [lessWidthConstraint, equalWidthConstraint]
        minHeightConstraint = contentView.anchors.height.greaterThanOrEqual(attributes.minHeight)
        // - position
        contentView.anchors.centerX.align()
        contentView.anchors.edges.lessThanOrEqual(layoutMarginsGuide)

        // Shadow view
        shadowView.anchors.edges.pin(to: contentView)
      }
    }

    open func installPresentationConstraintsIfNeeded() {
      guard let superview = superview, !presentationConstraintsInstalled else { return }
      presentationConstraintsInstalled = true

      Constraints {
        anchors.edges.pin(axis: .horizontal)

        switch message.slideFrom {
        case .top:
          innerYConstraint = anchors.top.pin()
          outerYConstraint = contentView.anchors.top.pin(to: layoutMarginsGuide)
          anchors.bottom.equal(superview.anchors.top).priority = .defaultLow
        case .bottom:
          innerYConstraint = anchors.bottom.pin()
          outerYConstraint = contentView.anchors.bottom.pin(to: layoutMarginsGuide)
          anchors.top.equal(superview.anchors.bottom).priority = .defaultLow
        @unknown default:
          // Same as .bottom
          innerYConstraint = anchors.bottom.pin()
          outerYConstraint = contentView.anchors.bottom.pin(to: layoutMarginsGuide)
          anchors.top.equal(superview.anchors.bottom).priority = .defaultLow
        }
      }

      innerYConstraint.isActive = presented
      outerYConstraint.isActive = presented

      setNeedsLayout()
      superview.layoutIfNeeded()
    }

    // MARK: - Presentation / InAppMessageView conformance

    open var presented: Bool = false {
      didSet {
        presented
          ? NSLayoutConstraint.activate([innerYConstraint, outerYConstraint])
          : NSLayoutConstraint.deactivate([innerYConstraint, outerYConstraint])
      }
    }

    open func present(completion: (() -> Void)? = nil) {
      installPresentationConstraintsIfNeeded()

      willPresent()
      attributes.onPresent?(self)

      UIView.performWithoutAnimation {
        superview?.layoutIfNeeded()
      }

      presented = true
      UIView.animate(
        withDuration: message.animateIn ? 0.3 : 0,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 1,
        options: .beginFromCurrentState,
        animations: { self.superview?.layoutIfNeeded() },
        completion: { _ in
          self.logImpression()
          completion?()
          self.didPresent()
        }
      )
    }

    open func dismiss(completion: (() -> Void)? = nil) {
      willDismiss()
      presented = false
      UIView.animate(
        withDuration: message.animateOut ? 0.3 : 0,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 1,
        options: .beginFromCurrentState,
        animations: { self.superview?.layoutIfNeeded() },
        completion: { _ in
          completion?()
          self.didDismiss()
        }
      )
    }

    // MARK: - User Interactions

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
      contentView.point(inside: convert(point, to: contentView), with: event)
    }

    class PressGestureDelegate: NSObject, UIGestureRecognizerDelegate {
      func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
      ) -> Bool { true }
    }

    private let pressGestureDelegate = PressGestureDelegate()

    open lazy var panGesture: UIPanGestureRecognizer = {
      let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
      return pan
    }()

    open lazy var pressGesture: UILongPressGestureRecognizer = {
      let press = UILongPressGestureRecognizer(target: self, action: #selector(press(_:)))
      press.minimumPressDuration = 0
      press.delegate = pressGestureDelegate
      return press
    }()

    @objc
    func pan(_ gesture: UIPanGestureRecognizer) {
      guard let superview = gesture.view?.superview else { return }
      let dismissible = attributes.dismissible
      var dy = gesture.translation(in: superview).y

      switch gesture.state {
      case .changed:
        if abs(dy) >= 5 { pressGesture.cancel() }
        switch message.slideFrom {
        case .top where dy > 0:
          dy = dy * 0.095
          outerYConstraint.constant = dy
          innerYConstraint.constant = 0
        case .top where dy <= 0:
          if !dismissible { dy = dy * 0.095 }
          outerYConstraint.constant = 0
          innerYConstraint.constant = dy
        case .bottom where dy < 0:
          dy = dy * 0.095
          outerYConstraint.constant = dy
          innerYConstraint.constant = 0
        case .bottom where dy >= 0:
          if !dismissible { dy = dy * 0.095 }
          outerYConstraint.constant = 0
          innerYConstraint.constant = dy
        default:
          break
        }
      case .ended:
        let vy = gesture.velocity(in: superview).y

        switch message.slideFrom {
        case .top where (vy <= -60 || dy < -25) && dismissible:
          dismiss()
        case .bottom where (vy >= 60 || dy > 25) && dismissible:
          dismiss()
        default:
          outerYConstraint.constant = 0
          innerYConstraint.constant = 0
          UIView.animate(withDuration: 0.3) {
            self.superview?.layoutIfNeeded()
          }
        }

      default:
        break
      }
    }

    @objc
    func press(_ gesture: UILongPressGestureRecognizer) {
      guard let gestureView = gesture.view else { return }
      let hitView = gestureView.hitTest(gesture.location(in: gestureView), with: nil)

      switch gesture.state {
      case .began:
        if hitView is UIControl {
          gesture.cancel()
          return
        }
        highlighted = true
      case .changed:
        guard hitView?.isDescendant(of: gestureView) == true else {
          gesture.cancel()
          return
        }
      case .ended:
        highlighted = false
        logClick()
        process(clickAction: message.clickAction)
        dismiss()
      default:
        highlighted = false
      }
    }

  }

}

// MARK: - Previews

#if UI_PREVIEWS
  import SwiftUI

  @available(iOS 13.0, *)
  struct SlideupView_Previews: PreviewProvider {
    typealias SlideupView = BrazeInAppMessageUI.SlideupView

    public static var previews: some View {
      Group {
        variationPreviews
        //      dimensionPreviews
        //      positionPreviews
        //      rightToLeftPreviews
        //      themePreviews
        //      customPreviews
      }
    }

    @ViewBuilder
    static var variationPreviews: some View {
      SlideupView(message: .mockText)
        .preview(center: .required)
        .frame(maxHeight: 120)
        .previewDisplayName("Var. | Text")

      SlideupView(message: .mockChevron)
        .preview(center: .required)
        .frame(maxHeight: 120)
        .previewDisplayName("Var. | Chevron")

      SlideupView(message: .mockIcon)
        .preview(center: .required)
        .frame(maxHeight: 120)
        .previewDisplayName("Var. | Icon")

      SlideupView(message: .mockImage)
        .preview(center: .required)
        .frame(maxHeight: 120)
        .previewDisplayName("Var. | Image")

      SlideupView(message: .mockShort)
        .preview(center: .required)
        .frame(maxHeight: 120)
        .previewDisplayName("Var. | Short")

      SlideupView(message: .mockLong)
        .preview(center: .required)
        .frame(maxHeight: 120)
        .previewDisplayName("Var. | Long")

    }

    @ViewBuilder
    static var dimensionPreviews: some View {
      SlideupView(message: .mockIcon)
        .preview(center: .required)
        .frame(width: 375, height: 120)
        .previewDisplayName("Dimension | Small")

      SlideupView(message: .mockLong)
        .preview(center: .required)
        .frame(width: 650, height: 120)
        .previewDisplayName("Dimensions | Large")
    }

    @ViewBuilder
    static var positionPreviews: some View {
      SlideupView(message: .mockTop, presented: true)
        .preview()
        .frame(maxHeight: 150)
        .previewDisplayName("Position | Top")

      SlideupView(message: .mockIcon, presented: true)
        .preview()
        .frame(maxHeight: 150)
        .previewDisplayName("Position | Bottom")
    }

    // OpenRadar: https://archive.md/zr3l4
    // swift-snapshot-testing issue: https://archive.md/dnUQM
    @ViewBuilder
    static var rightToLeftPreviews: some View {
      SlideupView(message: .mockIcon)
        .preview(center: .required)
        .frame(maxHeight: 120)
        .environment(\.layoutDirection, .rightToLeft)
        .previewDisplayName("RTL Support | Default")
    }

    @ViewBuilder
    static var themePreviews: some View {
      SlideupView(message: .mockIcon)
        .preview(center: .required)
        .frame(maxHeight: 120)
        .preferredColorScheme(.light)
        .previewDisplayName("Theme | Light")

      SlideupView(message: .mockIcon)
        .preview(center: .required)
        .frame(maxHeight: 120)
        .preferredColorScheme(.dark)
        .previewDisplayName("Theme | Dark")

      SlideupView(message: .mockThemed)
        .preview(center: .required)
        .frame(maxHeight: 120)
        .previewDisplayName("Theme | Custom")
    }

    static let extendedEdgesAttributes: SlideupView.Attributes = {
      var attributes = SlideupView.Attributes()
      attributes.maxWidth = 10000
      attributes.padding = .zero
      attributes.padding.left = 15
      attributes.padding.right = 15
      attributes.cornerRadius = 0
      attributes.onPresent = {
        let backgroundView = ShadowView(.inAppMessage)
        $0.insertSubview(backgroundView, at: 0)
        switch $0.message.slideFrom {
        case .top:
          backgroundView.anchors.bottom.equal($0.anchors.bottom)
        case .bottom:
          backgroundView.anchors.top.equal($0.anchors.top)
        @unknown default:
          backgroundView.anchors.top.equal($0.anchors.top)
        }
        backgroundView.anchors.edges.pin(axis: .horizontal)
        backgroundView.anchors.height.equal(1000)
        backgroundView.backgroundColor = $0.contentView.backgroundColor
        backgroundView.shadow = $0.shadowView.shadow
        $0.shadowView.shadow = nil
      }
      attributes.onTheme = {
        $0.subviews.first?.backgroundColor = $0.contentView.backgroundColor
      }
      return attributes
    }()

    @ViewBuilder
    static var customPreviews: some View {
      SlideupView(
        message: .mockIcon,
        attributes: extendedEdgesAttributes,
        presented: true
      )
      .preview {
        ($0 as! SlideupView).attributes.onPresent?(($0 as! SlideupView))
      }
      .frame(maxHeight: 120)
      .previewDisplayName(#"Custom | Extended edges"#)
    }

  }

#endif
