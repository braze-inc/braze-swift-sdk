import BrazeKit
import UIKit

extension BrazeInAppMessageUI {

  /// The view for full in-app messages.
  ///
  /// The full view can be customized using the ``ModalView/attributes-swift.property`` property.
  /// By default, the full view takes all available space on small screens and is displayed as a
  /// modal on large screens (e.g. iPad, Desktop).
  open class FullView: ModalView {

    // MARK: - Attributes

    /// The attributes supported by the full in-app message view.
    ///
    /// Attributes can be updated in multiple ways:
    /// - Via modifying the ``defaults`` static property
    /// - Via implementing the ``BrazeInAppMessageUIDelegate/inAppMessage(_:prepareWith:)-11fog``
    ///   delegate.
    /// - Via modifying the ``BrazeInAppMessageUI/messageView`` attributes on the
    ///   `BrazeInAppMessageUI` instance.
    public struct Attributes {

      /// The minimum spacing around the content view (used when displayed as modal).
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

      /// The content view corner curve.
      @available(iOS 13.0, *)
      public var cornerCurve: CALayerCornerCurve {
        get { CALayerCornerCurve(rawValue: _cornerCurve) }
        set { _cornerCurve = newValue.rawValue }
      }
      var _cornerCurve: String = "circular"

      /// The content view shadow.
      public var shadow: Shadow? = Shadow.inAppMessage

      /// The minimum width (used when displayed as modal).
      public var minWidth: ViewDimension = 320.0

      /// The maximum width (used when displayed as modal).
      ///
      /// The maximum width is swapped with the maximum height for large UIs (e.g. iPad).
      public var maxWidth: ViewDimension = .init(regular: 450.0, large: 720.0)

      /// The maximum height (used when displayed as modal).
      ///
      /// The maximum height is swapped with the maximum width for large UIs (e.g. iPad).
      public var maxHeight: ViewDimension = .init(regular: 720.0, large: 450.0)

      /// Specify whether the full in-app message view can be dismissed from a tap with the
      /// view's background.
      public var dismissOnBackgroundTap = false

      /// The buttons attributes.
      public var buttonsAttributes = ButtonView.Attributes.defaults

      /// Specify the preferred display mode. See
      /// ``BrazeInAppMessageUI/FullView/DisplayMode-swift.enum``.
      public var preferredDisplayMode: DisplayMode?

      /// Closure allowing further customization, executed when the view is about to be presented.
      public var onPresent: ((FullView) -> Void)?

      /// Closure executed every time the view is laid out.
      public var onLayout: ((FullView) -> Void)?

      /// Closure executed every time the view update its theme.
      public var onTheme: ((FullView) -> Void)?

      /// The defaults full view attributes.
      ///
      /// Modify this value directly to apply the customizations to all full in-app messages
      /// presented by the SDK.
      public static var defaults = Self()

    }

    public var preferredDisplayMode: DisplayMode? {
      didSet { updateForDisplayMode() }
    }

    /// Display modes supported by the full in-app message view.
    public enum DisplayMode {

      /// Displays the view as a modal.
      case modal

      /// Displays the view full screen.
      case full
    }

    public lazy var displayMode: DisplayMode =
      (traitCollection.horizontalSizeClass == .compact
        ? .full
        : .modal)
    {
      didSet { updateForDisplayMode() }
    }

    // MARK: - Views

    public var imageView: UIImageView {
      graphicView as! UIImageView
    }

    open override func installInternalConstraints() {
      super.installInternalConstraints()

      imageConstraint?.isActive = false
      imageConstraint = imageView.anchors.height.equal(
        contentView.anchors.height.multiplied(by: 0.5))
    }

    var modalMargin: UIEdgeInsets
    var modalMaxHeight: ViewDimension
    var modalCornerRadius: Double
    var modalPaddingBottom: Double

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      super.traitCollectionDidChange(previousTraitCollection)
      if preferredDisplayMode == nil {
        displayMode = traitCollection.horizontalSizeClass == .compact ? .full : .modal
      }
    }

    func updateForDisplayMode() {
      let displayMode = preferredDisplayMode ?? self.displayMode

      switch displayMode {
      case .modal:
        // - attributes
        attributes.margin = modalMargin
        attributes.maxHeight = modalMaxHeight
        attributes.cornerRadius = modalCornerRadius
        attributes.padding.bottom = modalPaddingBottom

        // - layout
        maxWidthConstraint.isActive = true

        NSLayoutConstraint.deactivate(contentPositionConstraints)
        contentPositionConstraints =
          contentView.anchors.edges.lessThanOrEqual(layoutMarginsGuide)
          + contentView.anchors.center.align()

        NSLayoutConstraint.deactivate(contentView.stackPositionConstraints)
        contentView.stackPositionConstraints = contentView.stack.anchors.edges.pin()
        contentView.stack.isLayoutMarginsRelativeArrangement = true

        prefersStatusBarHidden = nil

      case .full:
        // - attributes
        attributes.margin = .zero
        attributes.maxHeight = 10000
        attributes.cornerRadius = 0
        attributes.padding.bottom = 0

        // - layout
        maxWidthConstraint.isActive = false

        NSLayoutConstraint.deactivate(contentPositionConstraints)
        contentPositionConstraints = contentView.anchors.edges.pin()

        NSLayoutConstraint.deactivate(contentView.stackPositionConstraints)
        contentView.stackPositionConstraints =
          contentView.stack.anchors.edges.pin(axis: .horizontal)
          + [
            contentView.stack.anchors.top.pin(),
            contentView.stack.anchors.bottom.pin(
              to: contentView.layoutMarginsGuide,
              inset: attributes.padding.bottom
            ),
          ]
        contentView.stack.isLayoutMarginsRelativeArrangement = false

        prefersStatusBarHidden = true
      }

    }

    // MARK: - LifeCycle

    public init(
      message: Braze.InAppMessage.Full,
      attributes: Attributes = .defaults,
      gifViewProvider: GIFViewProvider = .shared,
      presented: Bool = false
    ) {
      var modalViewAttrs = ModalView.Attributes()
      modalViewAttrs.margin = attributes.margin
      modalViewAttrs.padding = attributes.padding
      modalViewAttrs.labelsSpacing = attributes.labelsSpacing
      modalViewAttrs.spacing = attributes.spacing
      modalViewAttrs.headerFont = attributes.headerFont
      modalViewAttrs.messageFont = attributes.messageFont
      modalViewAttrs.cornerRadius = attributes.cornerRadius
      if #available(iOS 13.0, *) {
        modalViewAttrs.cornerCurve = attributes.cornerCurve
      }
      modalViewAttrs.shadow = attributes.shadow
      modalViewAttrs.minWidth = attributes.minWidth
      modalViewAttrs.maxWidth = attributes.maxWidth
      modalViewAttrs.maxHeight = attributes.maxHeight
      modalViewAttrs.dismissOnBackgroundTap = attributes.dismissOnBackgroundTap
      modalViewAttrs.buttonsAttributes = attributes.buttonsAttributes
      modalViewAttrs.onPresent = { attributes.onPresent?($0 as! FullView) }
      modalViewAttrs.onLayout = { attributes.onLayout?($0 as! FullView) }
      modalViewAttrs.onTheme = { attributes.onTheme?($0 as! FullView) }
      modalMargin = attributes.margin
      modalCornerRadius = attributes.cornerRadius
      modalMaxHeight = attributes.maxHeight
      modalPaddingBottom = attributes.padding.bottom
      preferredDisplayMode = attributes.preferredDisplayMode

      super.init(
        message: .init(
          data: message.data,
          graphic: .image(message.imageURL),
          header: message.header,
          headerTextAlignment: message.headerTextAlignment,
          message: message.message,
          messageTextAlignment: message.messageTextAlignment,
          buttons: message.buttons,
          themes: message.themes
        ),
        attributes: modalViewAttrs,
        gifViewProvider: gifViewProvider,
        presented: presented
      )

      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true

      // Bottom spacer view
      contentView.stack.addArrangedSubview(UIView())

      updateForDisplayMode()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Presentation / InAppMessageView conformance

    public override func present(completion: (() -> Void)?) {
      super.present(completion: completion)
      updateForDisplayMode()
    }

  }

}

// MARK: - Previews

#if UI_PREVIEWS
  import SwiftUI

  @available(iOS 14.0, *)
  struct FullView_Previews: PreviewProvider {
    typealias FullView = BrazeInAppMessageUI.FullView

    static var previews: some View {
      Group {
        //      variationFullPreviews
        //      variationModalPreviews
        //      dimensionPreviews
        //      rightToLeftPreviews
        themePreviews
      }
    }

    @ViewBuilder
    static var variationFullPreviews: some View {
      FullView(message: .mock, presented: true)
        .preview()
        .frame(maxHeight: 800)
        .previewDisplayName("Var. Full | Portrait")

      FullView(message: .mockOneButton, presented: true)
        .preview()
        .frame(maxHeight: 800)
        .previewDisplayName("Var. Full | 1 Button Portrait")

      FullView(message: .mockTwoButtons, presented: true)
        .preview()
        .frame(maxHeight: 800)
        .previewDisplayName("Var. Full | 2 Buttons Portrait")

      FullView(message: .mockLandscape, presented: true)
        .preview(center: .required)
        .frame(width: 850, height: 510)
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .compact)
        .previewDisplayName("Var. Full | Landcape")

      FullView(message: .mockLandscapeOneButton, presented: true)
        .preview(center: .required)
        .frame(width: 850, height: 510)
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .compact)
        .previewDisplayName("Var. Full | 1 Button Landscape")

      FullView(message: .mockLandscapeTwoButtons, presented: true)
        .preview(center: .required)
        .frame(width: 850, height: 510)
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .compact)
        .previewDisplayName("Var. Full | 2 Buttons Landscape")

      FullView(message: .mockLeadingAligned, presented: true)
        .preview()
        .frame(maxHeight: 800)
        .previewDisplayName("Var. Full | Leading alignment")

      FullView(message: .mockLong, presented: true)
        .preview()
        .frame(maxHeight: 500)
        .previewDisplayName("Var. Full | Long (constrained)")

      FullView(message: .mockTallCharacters, presented: true)
        .preview()
        .frame(maxHeight: 800)
        .previewDisplayName("Var. Full | Tall Characters")
    }

    @ViewBuilder
    static var variationModalPreviews: some View {
      FullView(message: .mock, presented: true)
        .preview()
        .frame(width: 540, height: 820)
        .environment(\.horizontalSizeClass, .regular)
        .previewDisplayName("Var. Modal | Portrait")

      FullView(message: .mockOneButton, presented: true)
        .preview()
        .frame(width: 540, height: 820)
        .environment(\.horizontalSizeClass, .regular)
        .previewDisplayName("Var. Modal | 1 Button Portrait")

      FullView(message: .mockTwoButtons, presented: true)
        .preview()
        .frame(width: 540, height: 820)
        .environment(\.horizontalSizeClass, .regular)
        .previewDisplayName("Var. Modal | 2 Buttons Portrait")

      FullView(message: .mockLandscape, presented: true)
        .preview(center: .required)
        .frame(width: 850, height: 510)
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
        .previewDisplayName("Var. Full | Landcape")

      FullView(message: .mockLandscapeOneButton, presented: true)
        .preview(center: .required)
        .frame(width: 850, height: 510)
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
        .previewDisplayName("Var. Full | 1 Button Landscape")

      FullView(message: .mockLandscapeTwoButtons, presented: true)
        .preview(center: .required)
        .frame(width: 850, height: 510)
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
        .previewDisplayName("Var. Full | 2 Buttons Landscape")

      FullView(message: .mockLeadingAligned, presented: true)
        .preview()
        .frame(width: 540, height: 820)
        .environment(\.horizontalSizeClass, .regular)
        .previewDisplayName("Var. Modal | Leading alignment")

      FullView(message: .mockLong, presented: true)
        .preview()
        .frame(width: 540, height: 500)
        .environment(\.horizontalSizeClass, .regular)
        .previewDisplayName("Var. Modal | Long (constrained)")

      FullView(message: .mockTallCharacters, presented: true)
        .preview()
        .frame(width: 540, height: 820)
        .environment(\.horizontalSizeClass, .regular)
        .previewDisplayName("Var. Modal | Tall Characters")
    }

    @ViewBuilder
    static var dimensionPreviews: some View {

      FullView(message: .mockTwoButtons, presented: true)
        .preview()
        .frame(width: 900, height: 900)
        .environment(\.horizontalSizeClass, .compact)
        .previewDisplayName("Dimensions | Full (no max)")

      FullView(message: .mockTwoButtons, presented: true)
        .preview()
        .frame(width: 540, height: 820)
        .environment(\.horizontalSizeClass, .regular)
        .previewDisplayName("Dimensions | Modal (constrained)")
    }

    // OpenRadar: https://archive.md/zr3l4
    // swift-snapshot-testing issue: https://archive.md/dnUQM
    @ViewBuilder
    static var rightToLeftPreviews: some View {
      FullView(message: .mockTwoButtons, presented: true)
        .preview()
        .frame(maxHeight: 800)
        .environment(\.layoutDirection, .rightToLeft)
        .previewDisplayName("RTL Support | Default")
    }

    @ViewBuilder
    static var themePreviews: some View {
      FullView(message: .mockTwoButtons, presented: true)
        .preview()
        .frame(maxHeight: 800)
        .preferredColorScheme(.light)
        .previewDisplayName("Theme | Light")

      FullView(message: .mockTwoButtons, presented: true)
        .preview()
        .frame(maxHeight: 800)
        .preferredColorScheme(.dark)
        .previewDisplayName("Theme | Dark")

      FullView(message: .mockThemed, presented: true)
        .preview()
        .frame(maxHeight: 800)
        .previewDisplayName("Theme | Custom")

    }
  }
#endif
