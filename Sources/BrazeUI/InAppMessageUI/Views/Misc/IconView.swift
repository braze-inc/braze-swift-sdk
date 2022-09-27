import BrazeKit
import UIKit

extension BrazeInAppMessageUI {

  /// View displaying a [FontAwesome v4.3][1] icon.
  ///
  /// [1]: https://fontawesome.com/v4.7/cheatsheet/
  open class IconView: UIView {

    /// FontAwesome symbol to display.
    ///
    /// - Important: The value should be the actual unicode symbol instead of the FontAwesome symbol
    ///              identifier. For instance, use `` instead of `fa-arrow-right`.
    ///
    /// You can copy FontAwesome 4.3 compatible symbols directly from the FontAwesome [cheatsheet].
    ///
    /// [cheatsheet]: https://fontawesome.com/v4.7/cheatsheet/
    public var symbol: String {
      didSet { label.text = symbol }
    }

    /// Label displaying the FontAwesome symbol.
    public var label = UILabel()

    /// Creates and returns an icon view.
    /// - Parameters:
    ///   - symbol: A FontAwesome unicode symbol, see ``symbol`` for more details.
    ///   - attributes: A high-level customization struct.
    ///   - theme: An in-app message theme.
    public init(
      symbol: String,
      attributes: Attributes = .init(),
      theme: Braze.InAppMessage.Theme = .defaultLight
    ) {
      self.symbol = symbol
      self.attributes = attributes
      self.theme = theme

      super.init(frame: .zero)
      addSubview(label)

      label.text = symbol
      label.textAlignment = .center

      applyTheme()
      applyAttributes()
    }

    required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Attributes

    /// Attributes allow high-level customization of Braze's UI component.
    public struct Attributes {

      /// Intrinsic size of the icon, including the background.
      ///
      /// Default: `50x50pt.`
      public var size: CGSize = CGSize(width: 50, height: 50)

      /// Size of the symbol, excluding the background.
      ///
      /// Default: `30pt.`
      public var symbolSize = 30.0

      /// Corner radius of the icon's background
      ///
      /// Default: `10pt.`
      public var cornerRadius = 10.0

      /// Default initializer.
      public init() {}
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
      NSLayoutConstraint.deactivate(constraints)
      anchors.size.equal(attributes.size)

      label.font = Self.fontAwesome.withSize(attributes.symbolSize)

      layer.cornerRadius = attributes.cornerRadius
      layer.masksToBounds = true
    }

    // MARK: - Layout

    open override var intrinsicContentSize: CGSize {
      attributes.size
    }

    open override func layoutSubviews() {
      super.layoutSubviews()
      label.frame = bounds
    }

    // MARK: - Theme

    /// The current theme.
    public var theme: Braze.InAppMessage.Theme {
      didSet { applyTheme() }
    }

    /// Apply the current ``theme`` to the view.
    ///
    /// This is called automatically whenever ``theme`` is updated.
    open func applyTheme() {
      label.textColor = theme.iconColor.uiColor
      label.backgroundColor = theme.iconBackgroundColor.uiColor
    }

    // MARK: - FontAwesome

    static let fontAwesome: UIFont = {
      _ = registerFontAwesomeIfNeeded()
      return UIFont(name: "FontAwesome", size: 30) ?? .systemFont(ofSize: 30)
    }()

    static func registerFontAwesomeIfNeeded() -> Bool {
      guard UIFont(name: "FontAwesome", size: 30) == nil else {
        return true
      }
      guard let url = resourcesBundle?.url(forResource: "FontAwesome", withExtension: "otf"),
        let data = try? Data(contentsOf: url),
        let dataProvider = CGDataProvider(data: data as CFData),
        let font = CGFont(dataProvider)
      else {
        return false
      }
      var error: Unmanaged<CFError>? = nil
      guard CTFontManagerRegisterGraphicsFont(font, &error) else {
        return false
      }
      return true
    }
  }

}

// MARK: - Previews

#if UI_PREVIEWS
  import SwiftUI

  @available(iOS 13.0, *)
  struct IconView_Previews: PreviewProvider {
    typealias IconView = BrazeInAppMessageUI.IconView

    static var previews: some View {
      IconView(
        symbol: "",
        theme: .defaultLight
      ).preview()
        .frame(width: 50, height: 50)
        .preferredColorScheme(.light)
        .previewDisplayName("Light")
      IconView(
        symbol: "",
        theme: .defaultDark
      ).preview()
        .frame(width: 50, height: 50)
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark")
      IconView(
        symbol: "",
        theme: .init(
          iconColor: 0xFF4C_D137,
          iconBackgroundColor: 0xFF2D_3436
        )
      ).preview()
        .frame(width: 50, height: 50)
        .previewDisplayName("Custom Theme")
      IconView(symbol: "", theme: .defaultLight).preview()
        .frame(width: 50, height: 50)
        .previewDisplayName("Invalid")
    }

  }
#endif
