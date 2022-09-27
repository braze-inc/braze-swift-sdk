import BrazeKit
import UIKit

extension BrazeInAppMessageThemeable {

  /// Retrieves the theme fitting the passed `traits`.
  ///
  /// When an in-app message campaign does not include a [Dark Mode] theme, the default light mode
  /// theme is returned.
  ///
  /// [Dark Mode]: https://apple.co/2WBiaQ7
  public func theme(for traits: UITraitCollection) -> Braze.InAppMessage.Theme {
    guard #available(iOS 12.0, *) else {
      return themes.light
    }

    switch traits.userInterfaceStyle {
    case .light, .unspecified:
      return themes.light
    case .dark:
      return themes.dark ?? themes.light
    @unknown default:
      return themes.light
    }
  }

}

extension Braze.InAppMessage.Button {

  /// Retrieves the button theme fitting the passed `traits`.
  ///
  /// When an in-app message campaign does not include a [Dark Mode] theme, the default light mode
  /// theme is returned.
  ///
  /// [Dark Mode]: https://apple.co/2WBiaQ7
  public func theme(for traits: UITraitCollection) -> Braze.InAppMessage.ButtonTheme {
    guard #available(iOS 12.0, *) else {
      return themes.light
    }

    switch traits.userInterfaceStyle {
    case .light, .unspecified:
      return themes.light
    case .dark:
      return themes.dark ?? themes.light
    @unknown default:
      return themes.light
    }
  }
}

extension Braze.InAppMessage.Color {

  /// A 1x1 pt image of the color.
  public var image: UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    return UIGraphicsImageRenderer(size: rect.size).image {
      self.uiColor.set()
      $0.fill(rect)
    }
  }

  /// Returns an instance of the color with its brightness adjusted by the amount.
  /// - Parameter amount: A value between `-1` and `1` representing the brightness decrement or
  ///                     increment to apply to the color.
  /// - Returns: The color with its brightness adjusted.
  func adjustingBrightness(by amount: CGFloat) -> Self {
    Self(
      red: max(0, min(r + amount, 1)),
      green: max(0, min(g + amount, 1)),
      blue: max(0, min(b + amount, 1)),
      alpha: a
    )
  }

}

extension Braze.InAppMessage.TextAlignment {

  /// Returns the `NSTextAlignment` enum case matching the in-app message text aligment.
  ///
  /// This function is _RTL-aware_ and uses the passed `traits` to choose the appropriate text
  /// alignment.
  /// - Parameter traits: The current traits.
  /// - Returns: The matching `NSTextAlignment` case.
  func nsTextAlignment(forTraits traits: UITraitCollection) -> NSTextAlignment {
    switch (self, traits.layoutDirection) {
    case (.leading, _):
      return .natural
    case (.center, _):
      return .center
    case (.trailing, .rightToLeft):
      return .left
    case (.trailing, _):
      return .right
    @unknown default:
      return .natural
    }
  }

}

extension Braze.InAppMessage.Orientation {

  /// Returns whether the in-app message orientation is supported by the passed `traits`.
  /// - Parameter traits: The current traits.
  /// - Returns: A boolean value indicating if the in-app message orientation is supported by
  ///            `traits`
  func supported(by traits: UITraitCollection?) -> Bool {
    switch (self, traits?.horizontalSizeClass, traits?.verticalSizeClass) {
    case (.any, _, _),
      (_, .none, .none):
      return true
    case (.portrait, .compact, _),
      (.portrait, .regular, .regular):
      return true
    case (.landscape, .regular, _):
      return true
    default:
      return false
    }
  }

  /// Returns the interface orientation mask for the passed `traits`.
  /// - Parameter traits: The current traits.
  /// - Returns: The interface orientation mask corresponding to the in-app message orientation.
  func mask(for traits: UITraitCollection?) -> UIInterfaceOrientationMask {
    switch self {
    case .any where traits?.userInterfaceIdiom == .phone:
      return .allButUpsideDown
    case .any:
      return .all
    case .portrait:
      return .portrait
    case .landscape:
      return .landscape
    @unknown default:
      return .all
    }
  }

}
