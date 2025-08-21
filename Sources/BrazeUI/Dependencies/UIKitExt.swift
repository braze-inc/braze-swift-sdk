import BrazeKit
import UIKit

extension UIFont {

  /// Shorthand for `Braze.UIUtils.preferredFont(forTextStyle:weight:)`.
  static func preferredFont(
    textStyle: UIFont.TextStyle,
    weight: UIFont.Weight
  ) -> UIFont {
    Braze.UIUtils.preferredFont(textStyle: textStyle, weight: weight)
  }

  static var brazeCloseButtonFont: UIFont {
    .systemFont(ofSize: 22)
  }

}

extension UIButton {

  /// Adds a closure executed when pressed.
  func addAction(_ action: @escaping () -> Void) {
    @objc final class Receiver: NSObject {
      let action: () -> Void
      init(_ action: @escaping () -> Void) { self.action = action }
      @objc func receive() { action() }
    }
    let receiver = Receiver(action)
    self.addTarget(receiver, action: #selector(Receiver.receive), for: .touchUpInside)
    objc_setAssociatedObject(self, UUID().uuidString, receiver, .OBJC_ASSOCIATION_RETAIN)
  }

}

extension UIView {

  /// Position the view in a resizable container view and returns it.
  ///
  /// The wrapped view can adopt its intrinsic content size without being stretched.
  ///
  /// - Parameters:
  ///   - centerX: Horizontally center the view in the container view (default: `true`).
  ///   - centerY: Vertically center the view in the container view (default: `true`).
  /// - Returns: The view wrapped in a resizable container view.
  func boundedByIntrinsicContentSize(
    centerX: Bool = true,
    centerY: Bool = true
  ) -> UIView {
    let wrapper = UIView()
    wrapper.addSubview(self)
    if centerX { anchors.centerX.align() }
    if centerY { anchors.centerY.align() }
    anchors.edges.lessThanOrEqual(wrapper)
    return wrapper
  }

  /// The sequence of recursive subviews using a breadth-first search approach.
  ///
  /// Use it with the `lazy` modifier for efficient recursive subview search:
  /// ```swift
  /// view.bfsSubviews.lazy.first { $0 is UIButton }
  /// ```
  var bfsSubviews: AnySequence<UIView> {
    AnySequence { () -> AnyIterator<UIView> in
      var subviews: [UIView] = self.subviews
      return AnyIterator {
        if subviews.isEmpty { return nil }
        let view = subviews.removeFirst()
        subviews.append(contentsOf: view.subviews)
        return view
      }
    }
  }

  // MARK: - Accessibility

  /// Sets the view's `accessibilityLabel` and `isAccessibilityElement` properties if `altText` is
  /// non-`nil`.
  /// - Parameters:
  ///   - altText: Accessibility alt text to be read for the view's image or icon (if any) when in
  ///   VoiceOver mode.
  func addAccessibilityAltText(_ altText: String?) {
    if let altText, altText != "" {
      accessibilityLabel = altText
      isAccessibilityElement = true
    } else {
      isAccessibilityElement = false
    }
  }

  /// Sets the `accessibilityLanguage` property of the view and all of its subviews.
  /// - Parameters:
  ///   - language:The language (BCP 47 format) of narrator to use when reading the view's text
  ///   content in accessibility VoiceOver mode.
  func applyAccessibilityLanguage(_ language: String?) {
    self.accessibilityLanguage = language
    for subview in self.subviews {
      subview.applyAccessibilityLanguage(language)
    }
  }

}

extension UIResponder {

  /// A sequence representing the instance's responder chain starting with the instance's next
  /// responder.
  var responders: AnySequence<UIResponder> {
    AnySequence { () -> AnyIterator<UIResponder> in
      var responder: UIResponder? = self
      return AnyIterator {
        responder = responder?.next
        return responder
      }
    }
  }

}

extension String {

  func attributed(
    with attributes: [NSAttributedString.Key: Any]? = nil,
    _ setup: (NSMutableParagraphStyle) -> Void
  ) -> NSAttributedString {
    let attributedText = NSMutableAttributedString(string: self, attributes: attributes)
    let style = NSMutableParagraphStyle()
    setup(style)
    attributedText.addAttribute(
      .paragraphStyle,
      value: style,
      range: NSRange(location: 0, length: attributedText.length)
    )
    return attributedText
  }

}

extension UIColor {

  static var brazeTableViewBackgroundColor: UIColor {
    #if os(visionOS)
      return .systemGroupedBackground
    #else
      if #available(iOS 13.0, *) {
        return .systemGroupedBackground
      } else {
        return .groupTableViewBackground
      }
    #endif
  }

  static var brazeCellBackgroundColor: UIColor {
    if #available(iOS 13.0, *) {
      return .secondarySystemGroupedBackground
    } else {
      return .white
    }
  }

  static var brazeCellBorderColor: UIColor {
    if #available(iOS 13.0, *) {
      return .systemGray5
    } else {
      return UIColor(white: 0.88, alpha: 1)
    }
  }

  static var brazeCellShadowColor: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor { traits in
        switch traits.userInterfaceStyle {
        case .dark:
          return .systemGray6
        default:
          return .systemGray2
        }
      }
    } else {
      return UIColor(white: 0.7, alpha: 1)
    }
  }

  static var brazeCellHighlightColor: UIColor {
    if #available(iOS 13.0, *) {
      return .systemGray4
    } else {
      return UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1)
    }
  }

  static var brazeCellImageBackgroundColor: UIColor {
    return .clear
  }

  static var brazeRetryButtonColor: UIColor {
    if #available(iOS 13.0, *) {
      return .secondarySystemFill
    } else {
      return UIColor(red: 0.87, green: 0.87, blue: 0.89, alpha: 1.00)
    }
  }

  static var brazeLabel: UIColor {
    if #available(iOS 13.0, *) {
      return .label
    } else {
      return .black
    }
  }

}

extension UIColor {

  func brazeResolvedColor(with traitCollection: UITraitCollection) -> UIColor {
    if #available(iOS 13.0, *) {
      return self.resolvedColor(with: traitCollection)
    } else {
      return self
    }
  }

}

extension CGColor {

  static func brazeCellBorderColor(_ traits: UITraitCollection) -> CGColor {
    if #available(iOS 13.0, *) {
      return UIColor.brazeCellBorderColor.resolvedColor(with: traits).cgColor
    } else {
      return UIColor.brazeCellBorderColor.cgColor
    }
  }

}

extension UIGestureRecognizer {

  /// Cancels the gesture recognizer.
  func cancel() {
    guard isEnabled else { return }
    isEnabled = false
    isEnabled = true
  }

}

@available(iOS 17.0, *)
extension UICornerCurve {

  init(layerCornerCurve: CALayerCornerCurve) {
    switch layerCornerCurve {
    case .continuous:
      self = .continuous
    case .circular:
      self = .circular
    default:
      self = .continuous
    }
  }

}

extension UIEdgeInsets {

  var directionalEdgeInsets: NSDirectionalEdgeInsets {
    NSDirectionalEdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
  }

}
