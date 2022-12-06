import BrazeKit
import UIKit

extension BrazeInAppMessageUI {

  /// The view for full image in-app messages.
  ///
  /// The full image view can be customized using the ``ModalImageView/attributes-swift.property``
  /// property.
  /// By default, the full image view takes all available space on small screens and is displayed as
  /// a modal on large screens (e.g. iPad, Desktop).
  open class FullImageView: ModalImageView {

    // MARK: - Attributes

    /// The attributes supported by the full image in-app message view.
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

      /// Specify whether the full image in-app message view displays the image in a scroll view
      /// for large images.
      public var scrollLargeImages = false

      /// Specify whether the full image in-app message view can be dismissed from a tap with the
      /// view's background.
      public var dismissOnBackgroundTap = false

      /// The buttons attributes.
      public var buttonsAttributes = ButtonView.Attributes.defaults

      /// Specify the preferred display mode. See
      /// ``BrazeInAppMessageUI/FullImageView/DisplayMode-swift.enum``.
      public var preferredDisplayMode: DisplayMode?

      /// Closure allowing further customization, executed when the view is about to be presented.
      public var onPresent: ((ModalImageView) -> Void)?

      /// Closure executed every time the view is laid out.
      public var onLayout: ((ModalImageView) -> Void)?

      /// Closure executed every time the view update its theme.
      public var onTheme: ((ModalImageView) -> Void)?

      /// The defaults full image view attributes.
      ///
      /// Modify this value directly to apply the customizations to all full image in-app messages
      /// presented by the SDK.
      public static var defaults = Self()

    }

    public var preferredDisplayMode: DisplayMode? {
      didSet { updateForDisplayMode() }
    }

    /// Display modes supported by the full image in-app message view.
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

    var modalMargin: UIEdgeInsets
    var modalMaxHeight: ViewDimension
    var modalCornerRadius: Double

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

        // - layout
        maxWidthConstraint.isActive = true

        NSLayoutConstraint.deactivate(contentPositionConstraints)
        contentPositionConstraints =
          contentView.anchors.edges.lessThanOrEqual(layoutMarginsGuide)
          + contentView.anchors.center.align()

        prefersStatusBarHidden = nil

      case .full:
        // - attributes
        attributes.margin = .zero
        attributes.maxHeight = 10000
        attributes.cornerRadius = 0

        // - layout
        maxWidthConstraint.isActive = false

        NSLayoutConstraint.deactivate(contentPositionConstraints)
        contentPositionConstraints = contentView.anchors.edges.pin()

        prefersStatusBarHidden = true
      }

    }

    public init(
      message: Braze.InAppMessage.FullImage,
      attributes: Attributes = .defaults,
      gifViewProvider: GIFViewProvider = .shared,
      presented: Bool = false
    ) {
      var modalImageAttrs = ModalImageView.Attributes()
      modalImageAttrs.margin = attributes.margin
      modalImageAttrs.padding = attributes.padding
      modalImageAttrs.cornerRadius = attributes.cornerRadius
      if #available(iOS 13.0, *) {
        modalImageAttrs.cornerCurve = attributes.cornerCurve
      }
      modalImageAttrs.shadow = attributes.shadow
      modalImageAttrs.minWidth = attributes.minWidth
      modalImageAttrs.maxWidth = attributes.maxWidth
      modalImageAttrs.maxHeight = attributes.maxHeight
      modalImageAttrs.scrollLargeImages = attributes.scrollLargeImages
      modalImageAttrs.dismissOnBackgroundTap = attributes.dismissOnBackgroundTap
      modalImageAttrs.buttonsAttributes = attributes.buttonsAttributes
      modalImageAttrs.onPresent = { attributes.onPresent?($0 as! FullImageView) }
      modalImageAttrs.onLayout = { attributes.onLayout?($0 as! FullImageView) }
      modalImageAttrs.onTheme = { attributes.onTheme?($0 as! FullImageView) }
      modalMargin = attributes.margin
      modalCornerRadius = attributes.cornerRadius
      modalMaxHeight = attributes.maxHeight
      preferredDisplayMode = attributes.preferredDisplayMode

      super.init(
        message: .init(
          data: message.data,
          imageURL: message.imageURL,
          buttons: message.buttons,
          themes: message.themes
        ),
        attributes: modalImageAttrs,
        gifViewProvider: gifViewProvider,
        presented: presented
      )

      imageView.clipsToBounds = true

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

  @available(iOS 13.0, *)
  struct FullImageView_Previews: PreviewProvider {
    typealias FullImageView = BrazeInAppMessageUI.FullImageView

    static var previews: some View {
      Group {
        variationFullPreviews
        //        variationModalPreviews
        //        dimensionsPreviews
        //        customPreviews
      }
    }

    @ViewBuilder
    static var variationFullPreviews: some View {
      FullImageView(message: .mock, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 800)
        .previewDisplayName("Var. Full | Portrait")

      FullImageView(message: .mockOneButton, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 800)
        .previewDisplayName("Var. Full | 1 Button Portrait")

      FullImageView(message: .mockTwoButtons, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 800)
        .previewDisplayName("Var. Full | 2 Buttons Portrait")

      FullImageView(message: .mockLandscape, presented: true)
        .preview(center: .required)
        .frame(width: 850, height: 510)
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .compact)
        .previewDisplayName("Var. Full | Landcape")

      FullImageView(message: .mockLandscapeOneButton, presented: true)
        .preview(center: .required)
        .frame(width: 850, height: 510)
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .compact)
        .previewDisplayName("Var. Full | 1 Button Landscape")

      FullImageView(message: .mockLandscapeTwoButtons, presented: true)
        .preview(center: .required)
        .frame(width: 850, height: 510)
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .compact)
        .previewDisplayName("Var. Full | 2 Buttons Landscape")
    }

    @ViewBuilder
    static var variationModalPreviews: some View {
      FullImageView(message: .mock, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 800)
        .environment(\.horizontalSizeClass, .regular)
        .previewDisplayName("Var. Modal | Portrait")

      FullImageView(message: .mockOneButton, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 800)
        .environment(\.horizontalSizeClass, .regular)
        .previewDisplayName("Var. Modal | 1 Button")

      FullImageView(message: .mockTwoButtons, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 800)
        .environment(\.horizontalSizeClass, .regular)
        .previewDisplayName("Var. Modal | 2 Buttons")

      FullImageView(message: .mockLandscape, presented: true)
        .preview(center: .required)
        .frame(width: 850, height: 510)
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
        .previewDisplayName("Var. Full | Landcape")

      FullImageView(message: .mockLandscapeOneButton, presented: true)
        .preview(center: .required)
        .frame(width: 850, height: 510)
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
        .previewDisplayName("Var. Full | 1 Button Landscape")

      FullImageView(message: .mockLandscapeTwoButtons, presented: true)
        .preview(center: .required)
        .frame(width: 850, height: 510)
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
        .previewDisplayName("Var. Full | 2 Buttons Landscape")
    }

    @ViewBuilder
    static var dimensionsPreviews: some View {
      FullImageView(message: .mockRecommendedSize, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 800)
        .previewDisplayName("Dimension | Recommended size")

      FullImageView(message: .mockMinRecommendedSize, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 800)
        .previewDisplayName("Dimension | Min. recommended size")

      FullImageView(message: .mockNonRecommendedSize, presented: true)
        .preview(center: .required)
        .frame(maxHeight: 800)
        .previewDisplayName("Dimension | Non recommended size (extra large image)")
    }

    static var customPreviews: some View {
      var attributes = FullImageView.Attributes()
      attributes.scrollLargeImages = true

      return FullImageView(
        message: .mockNonRecommendedSize,
        attributes: attributes,
        presented: true
      )
      .preview(center: .required)
      .frame(maxHeight: 800)
      .previewDisplayName("Custom | Scroll Large Images")
    }

  }
#endif
