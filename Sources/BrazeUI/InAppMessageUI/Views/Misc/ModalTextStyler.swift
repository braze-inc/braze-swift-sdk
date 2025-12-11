import BrazeKit
import UIKit

extension BrazeInAppMessageUI {

  /// Protocol defining the styling logic for `ModalTextView`.
  ///
  /// This protocol is specific to the modal text view's header/message structure.
  /// It uses the generic `TextViewTarget` protocol for the underlying text view abstraction.
  protocol ModalTextStyling {
    func apply(
      to textView: TextViewTarget,
      header: String,
      message: String,
      attributes: BrazeInAppMessageUI.ModalTextView.Attributes,
      oldAttributes: BrazeInAppMessageUI.ModalTextView.Attributes?
    )
  }

  /// Encapsulates the logic for styling and updating the text content of a `ModalTextView`.
  struct ModalTextStyler: ModalTextStyling {
    // MARK: - Layout Constants

    /// Manually-tuned values to get us closer to our visual spec.
    private enum Layout {
      static let headerLineSpacingScaleFactor = 0.78
      static let messageLineSpacingScaleFactor = 0.47
      static let headerMessageSpacingOffset = 1.0
    }

    // MARK: - API

    /// Applies the styled text content to the text view.
    ///
    /// This method determines whether a full layout update is necessary or if a partial update (colors only)
    /// is sufficient, optimizing performance for theme changes.
    ///
    /// - Parameters:
    ///   - textView: The text view to update.
    ///   - header: The header string.
    ///   - message: The message string.
    ///   - attributes: The current attributes to apply.
    ///   - oldAttributes: The previous attributes (if any) to check for optimization opportunities.
    func apply(
      to textView: TextViewTarget,
      header: String,
      message: String,
      attributes: BrazeInAppMessageUI.ModalTextView.Attributes,
      oldAttributes: BrazeInAppMessageUI.ModalTextView.Attributes? = nil
    ) {
      if shouldOptimizeUpdate(
        textView: textView,
        header: header,
        message: message,
        attributes: attributes,
        oldAttributes: oldAttributes
      ) {
        updateColorsOnly(
          textView: textView,
          headerLength: (header as NSString).length,
          messageLength: (message as NSString).length,
          attributes: attributes
        )
      } else {
        performFullUpdate(
          textView: textView,
          header: header,
          message: message,
          attributes: attributes
        )
      }
    }

    // MARK: - Private Implementation

    private func shouldOptimizeUpdate(
      textView: TextViewTarget,
      header: String,
      message: String,
      attributes: BrazeInAppMessageUI.ModalTextView.Attributes,
      oldAttributes: BrazeInAppMessageUI.ModalTextView.Attributes?
    ) -> Bool {
      guard let oldAttributes else { return false }

      let isLayoutEqual = attributes.isLayoutEqual(to: oldAttributes)
      let expectedLength = header.utf16.count + message.utf16.count + 1
      let contentMatches = expectedLength == textView.textStorage.length

      return isLayoutEqual && contentMatches
    }

    private func performFullUpdate(
      textView: TextViewTarget,
      header: String,
      message: String,
      attributes: BrazeInAppMessageUI.ModalTextView.Attributes
    ) {
      let newText = NSMutableAttributedString()
      newText.append(buildHeader(header, attributes: attributes))
      newText.append(NSAttributedString(string: "\n"))
      newText.append(buildMessage(message, attributes: attributes))

      let fullRange = NSRange(location: 0, length: textView.textStorage.length)

      textView.textStorage.beginEditing()
      textView.textStorage.replaceCharacters(in: fullRange, with: newText)
      textView.textStorage.endEditing()

      textView.addAccessibilityAltText(newText.string)
    }

    private func buildHeader(
      _ header: String,
      attributes: BrazeInAppMessageUI.ModalTextView.Attributes
    ) -> NSAttributedString {
      header.attributed(
        with: [
          .font: attributes.header.font,
          .foregroundColor: attributes.header.color,
        ]
      ) {
        $0.lineSpacing = attributes.header.lineSpacing ?? (2 * Layout.headerLineSpacingScaleFactor)
        $0.alignment = attributes.header.alignment
        $0.paragraphSpacing = max(
          0.0,
          attributes.headerMessageSpacing - Layout.headerMessageSpacingOffset
        )
        $0.lineHeightMultiple = attributes.header.lineHeightMultiple
        $0.minimumLineHeight = attributes.header.minLineHeight
        $0.maximumLineHeight = attributes.header.maxLineHeight
      }
    }

    private func buildMessage(
      _ message: String,
      attributes: BrazeInAppMessageUI.ModalTextView.Attributes
    ) -> NSAttributedString {
      message.attributed(
        with: [
          .font: attributes.message.font,
          .foregroundColor: attributes.message.color,
        ]
      ) {
        $0.lineSpacing =
          attributes.message.lineSpacing ?? (4 * Layout.messageLineSpacingScaleFactor)
        $0.alignment = attributes.message.alignment

        $0.lineHeightMultiple = attributes.message.lineHeightMultiple
        $0.minimumLineHeight = attributes.message.minLineHeight
        $0.maximumLineHeight = attributes.message.maxLineHeight
      }
    }

    private func updateColorsOnly(
      textView: TextViewTarget,
      headerLength: Int,
      messageLength: Int,
      attributes: BrazeInAppMessageUI.ModalTextView.Attributes
    ) {
      let messageLocation = headerLength + 1  // Header length + newline

      textView.textStorage.beginEditing()

      textView.textStorage.addAttribute(
        .foregroundColor,
        value: attributes.header.color,
        range: NSRange(location: 0, length: headerLength)
      )

      textView.textStorage.addAttribute(
        .foregroundColor,
        value: attributes.message.color,
        range: NSRange(location: messageLocation, length: messageLength)
      )

      textView.textStorage.endEditing()
    }
  }
}

// MARK: - Equatable Extensions

extension BrazeInAppMessageUI.ModalTextView.Attributes: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.header == rhs.header
      && lhs.message == rhs.message
      && lhs.headerMessageSpacing == rhs.headerMessageSpacing
  }

  public func isLayoutEqual(to other: Self) -> Bool {
    header.isLayoutEqual(to: other.header)
      && message.isLayoutEqual(to: other.message)
      && headerMessageSpacing == other.headerMessageSpacing
  }
}

extension BrazeInAppMessageUI.ModalTextView.TextStyle: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.color == rhs.color
      && lhs.font == rhs.font
      && lhs.alignment == rhs.alignment
      && lhs.lineSpacing == rhs.lineSpacing
      && lhs.maxLineHeight == rhs.maxLineHeight
      && lhs.minLineHeight == rhs.minLineHeight
      && lhs.lineHeightMultiple == rhs.lineHeightMultiple
  }

  public func isLayoutEqual(to other: Self) -> Bool {
    font == other.font
      && alignment == other.alignment
      && lineSpacing == other.lineSpacing
      && maxLineHeight == other.maxLineHeight
      && minLineHeight == other.minLineHeight
      && lineHeightMultiple == other.lineHeightMultiple
  }
}
