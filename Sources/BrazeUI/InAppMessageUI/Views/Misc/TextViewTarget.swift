import UIKit

extension BrazeInAppMessageUI {

  // MARK: - TextViewTarget Protocol

  /// A protocol abstracting the interface required by text stylers to update a text view.
  ///
  /// This protocol decouples the styling logic from concrete UIKit classes, enabling:
  /// - Easier unit testing with mock implementations
  /// - Flexibility to support different text view types
  /// - Clear contract for text manipulation capabilities
  ///
  /// ## Conforming Types
  ///
  /// The SDK provides a default conformance for `UITextView`. Custom implementations
  /// can conform to this protocol for specialized text rendering needs.
  ///
  protocol TextViewTarget: AnyObject {
    /// The attributed text content displayed by the text view.
    ///
    /// - Note: The force-unwrapped type matches `UITextView.attributedText` for seamless conformance.
    var attributedText: NSAttributedString! { get set }

    /// The text storage backing the text view, enabling efficient in-place attribute modifications.
    ///
    /// Direct manipulation of `NSTextStorage` allows for optimized partial updates (e.g., color changes)
    /// without triggering expensive full layout recalculations.
    var textStorage: NSTextStorage { get }

    /// Adds alternative text for accessibility purposes.
    ///
    /// - Parameter altText: The alternative text to announce via VoiceOver and other assistive technologies.
    func addAccessibilityAltText(_ altText: String?)
  }

}

// MARK: - UITextView Conformance

extension UITextView: BrazeInAppMessageUI.TextViewTarget {
  // `attributedText` and `textStorage` are already satisfied by UITextView.
  // `addAccessibilityAltText` is provided by UIView extension in `UIKitExt.swift`.
}
