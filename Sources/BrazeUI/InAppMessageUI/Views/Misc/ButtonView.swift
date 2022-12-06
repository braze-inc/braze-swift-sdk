import BrazeKit
import UIKit

extension BrazeInAppMessageUI {

  /// View displaying a Braze in-app message compatible button.
  open class ButtonView: UIButton {

    /// The button definition.
    public var button: Braze.InAppMessage.Button

    /// Creates and returns a Braze in-app message compatible button.
    /// - Parameters:
    ///   - button: A button definition as provided by BrazeKit.
    ///   - attributes: A high-level customization struct.
    public init(
      button: Braze.InAppMessage.Button,
      attributes: Attributes = .defaults
    ) {
      self.button = button
      self.attributes = attributes

      super.init(frame: .zero)

      setTitle(button.text, for: .normal)
      titleLabel?.adjustsFontForContentSizeCategory = true
      titleLabel?.adjustsFontSizeToFitWidth = true
      layer.masksToBounds = true

      setContentCompressionResistancePriority(.required, for: .vertical)

      minWidthConstraint = anchors.width.greaterThanOrEqual(0)
      minWidthConstraint.priority = .defaultHigh
      maxHeightContraint = anchors.height.lessThanOrEqual(0)
      maxHeightContraint.priority = .defaultHigh

      applyTheme()
      applyAttributes()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Attributes

    /// Attributes allow a high-level customization of Braze's UI component.
    public struct Attributes {

      /// Space around the button label, inside the button border.
      ///
      /// Default: `10pt.` vertical, `12pt.` horizontal.
      public var padding: UIEdgeInsets = .init(top: 10, left: 12, bottom: 10, right: 12)

      /// Font used for the button label.
      ///
      /// Default: `subheadline` dynamic type, `bold` weight.
      public var font: UIFont = .preferredFont(textStyle: .subheadline, weight: .bold)

      /// Border width.
      ///
      /// Default: `1pt.`
      /// Set it to `0` to remove the border.
      public var borderWidth: Double = 1

      /// Corner radius.
      ///
      /// Default: `5pt.`
      public var cornerRadius: Double = 5

      /// Minimum width.
      ///
      /// Default: `80pt.`
      public var minWidth: Double = 80

      /// Maximum height.
      ///
      /// Default: `44pt.`
      public var maxHeight: Double = 44

      /// The defaults button view attributes.
      ///
      /// Modify this value directly to apply the customizations to all in-app message buttons
      /// presented by the SDK.
      public static var defaults = Self()
    }

    /// The high-level customization struct.
    ///
    /// See ``Attributes-swift.struct`` for customizable values.
    public var attributes: Attributes {
      didSet { applyAttributes() }
    }

    /// Apply the current ``attributes-swift.property`` to the view.
    ///
    /// This is called automatically whenever ``attributes-swift.property`` is updated.
    open func applyAttributes() {
      contentEdgeInsets = attributes.padding
      titleLabel?.font = attributes.font
      layer.borderWidth = attributes.borderWidth
      layer.cornerRadius = attributes.cornerRadius

      minWidthConstraint.constant = attributes.minWidth
      maxHeightContraint.constant = attributes.maxHeight

      invalidateIntrinsicContentSize()
    }

    // MARK: - Layout

    var minWidthConstraint: NSLayoutConstraint!
    var maxHeightContraint: NSLayoutConstraint!

    open override var intrinsicContentSize: CGSize {
      CGSize(
        width: max(super.intrinsicContentSize.width, attributes.minWidth),
        height: min(super.intrinsicContentSize.height, attributes.maxHeight)
      )
    }

    // MARK: - Theme

    /// The current theme.
    public var theme: Braze.InAppMessage.ButtonTheme { button.theme(for: traitCollection) }

    /// Apply the current ``theme`` to the view.
    ///
    /// This is called automatically whenever the trait collection is updated.
    open func applyTheme() {
      setTitleColor(theme.textColor.uiColor, for: .normal)
      setBackgroundImage(theme.backgroundColor.image, for: .normal)
      setBackgroundImage(
        theme.backgroundColor.adjustingBrightness(by: -0.08).image,
        for: .highlighted
      )
      layer.borderColor = theme.borderColor.uiColor.cgColor
    }

    open override func traitCollectionDidChange(
      _ previousTraitCollection: UITraitCollection?
    ) {
      super.traitCollectionDidChange(previousTraitCollection)
      applyTheme()
    }

  }

}

// MARK: - Previews

#if UI_PREVIEWS
  import SwiftUI

  @available(iOS 13.0, *)
  struct Button_Previews: PreviewProvider {
    typealias ButtonView = BrazeInAppMessageUI.ButtonView

    static var previews: some View {
      ButtonView(button: .mockPrimary)
        .preview()
        .fixedSize()
        .preferredColorScheme(.light)
      ButtonView(button: .mockSecondary)
        .preview()
        .fixedSize()
        .preferredColorScheme(.dark)
    }

  }
#endif
