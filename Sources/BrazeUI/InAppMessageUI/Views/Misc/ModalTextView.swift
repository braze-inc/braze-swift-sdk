import BrazeKit
import UIKit

extension BrazeInAppMessageUI {

  // A view displaying modal and full in-app messages' header and message according the Braze's
  // specs.
  public final class ModalTextView: UIScrollView {

    /// The view's header string.
    public var header: String {
      didSet { updateTextViewContent() }
    }

    /// The view's message string.
    public var message: String {
      didSet { updateTextViewContent() }
    }

    /// The view's attributes for customization.
    public var attributes: Attributes {
      didSet {
        updateTextViewContent(oldAttributes: oldValue)
      }
    }

    /// The language (BCP 47 format) of narrator to use when reading content in accessibility VoiceOver mode.
    ///
    /// If `nil`, the user's system language is used.
    public var language: String? {
      didSet {
        textView.accessibilityLanguage = language
      }
    }

    /// The object responsible for styling the text view.
    private let styler: any ModalTextStyling

    private let textView: UITextView = {
      let textView = UITextView()

      // Override defaults
      textView.backgroundColor = .clear
      textView.isEditable = false
      textView.isSelectable = false
      textView.adjustsFontForContentSizeCategory = true

      // Don't allow scrolling; the textview's parent (a scrollview) will control that.
      // This will force the textView to render its full content height,
      // and the textViewContainer can then take that as its content and scroll it for us.
      // (This hot tip brought to you by https://archive.is/fMUR7 and many other results.)
      textView.isScrollEnabled = false

      // Layout defaults
      textView.setContentCompressionResistancePriority(.required, for: .vertical)
      textView.setContentHuggingPriority(.required, for: .vertical)

      return textView
    }()

    var heightConstraint: NSLayoutConstraint!

    // MARK: - Initialization

    /// Creates and returns a modal text view.
    /// - Parameters:
    ///   - header: The header string.
    ///   - message: The message string.
    ///   - attributes: The attributes for customization.
    ///   - language: The language (BCP 47 format) of narrator to use when reading content in accessibility
    ///   VoiceOver mode. Defaults to using the user's system language.
    ///   - styler: The object responsible for styling the text view. Defaults to `ModalTextStyler`.
    internal init(
      header: String,
      message: String,
      attributes: Attributes,
      language: String? = nil,
      styler: any ModalTextStyling
    ) {
      self.header = header
      self.message = message
      self.attributes = attributes
      self.language = language
      self.styler = styler

      super.init(frame: .zero)

      // Hierarchy
      textView.addAccessibilityAltText(textView.text)
      addSubview(textView)

      // Constraints
      textView.anchors.top.equal(anchors.topMargin)
      textView.anchors.bottom.equal(anchors.bottomMargin)
      textView.anchors.edges.pin(to: layoutMarginsGuide, axis: .horizontal)
      textView.anchors.height.lessThanOrEqual(layoutMarginsGuide.anchors.height)
        .priority = .defaultHigh
      heightConstraint = textView.anchors.height.equal(layoutMarginsGuide.anchors.height)
      heightConstraint.priority = .defaultLow
    }

    /// Creates and returns a modal text view.
    /// - Parameters:
    ///   - header: The header string.
    ///   - message: The message string.
    ///   - attributes: The attributes for customization.
    ///   - language: The language (BCP 47 format) of narrator to use when reading content in accessibility
    ///   VoiceOver mode. Defaults to using the user's system language.
    public convenience init(
      header: String,
      message: String,
      attributes: Attributes,
      language: String? = nil
    ) {
      self.init(
        header: header,
        message: message,
        attributes: attributes,
        language: language,
        styler: ModalTextStyler()
      )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Attributes

    /// The attributes supported by the modal text view.
    public struct Attributes: Sendable {
      /// The style for the header.
      public var header = TextStyle()

      /// The style for the message.
      public var message = TextStyle()

      /// The spacing between the header and message.
      public var headerMessageSpacing = 10.0
    }

    /// The style for displaying text in the modal text view.
    public struct TextStyle: Sendable {
      /// The text color.
      public var color: UIColor = .brazeLabel

      /// The text font.
      public var font: UIFont = UIFont()

      /// The text alignment.
      public var alignment: NSTextAlignment = .natural

      /// The text line spacing (default: `nil`).
      public var lineSpacing: CGFloat? = nil

      /// The maximum line height (default: `0.0`).
      public var maxLineHeight: CGFloat = 0.0

      /// The minimum line height (default: `0.0`).
      public var minLineHeight: CGFloat = 0.0

      /// The line height multiple (default: `0.0`).
      public var lineHeightMultiple: CGFloat = 0.0
    }

    // MARK: - Content Updates

    private func updateTextViewContent(oldAttributes: Attributes? = nil) {
      styler.apply(
        to: textView,
        header: header,
        message: message,
        attributes: attributes,
        oldAttributes: oldAttributes
      )
    }

  }

}

// MARK: - Extensions

extension BrazeInAppMessageUI.ModalTextView {

  /// Creates and returns a modal text view suitable for modal and full in-app messages.
  /// - Parameters:
  ///   - modal: The modal in-app message.
  ///   - attributes: The text view attributes.
  ///   - traitCollection: The current trait collection.
  public convenience init(
    modal: Braze.InAppMessage.Modal,
    attributes: BrazeInAppMessageUI.ModalView.Attributes,
    traitCollection: UITraitCollection
  ) {
    self.init(
      header: modal.header,
      message: modal.message,
      attributes: .init(modal: modal, attributes: attributes, traitCollection: traitCollection),
      language: modal.language
    )
  }

}

extension BrazeInAppMessageUI.ModalTextView.Attributes {

  /// Creates and returns a modal text view attributes struct from a modal in-app message.
  /// - Parameters:
  ///   - modal: The modal in-app message.
  ///   - attributes: The text view attributes.
  ///   - traitCollection: The current trait collection.
  public init(
    modal: Braze.InAppMessage.Modal,
    attributes: BrazeInAppMessageUI.ModalView.Attributes,
    traitCollection: UITraitCollection
  ) {
    let theme = modal.theme(for: traitCollection)
    self.init(
      header: .init(
        color: theme.headerTextColor.uiColor,
        font: attributes.headerFont,
        alignment: modal.headerTextAlignment.nsTextAlignment(forTraits: traitCollection)
      ),
      message: .init(
        color: theme.textColor.uiColor,
        font: attributes.messageFont,
        alignment: modal.messageTextAlignment.nsTextAlignment(forTraits: traitCollection)
      ),
      headerMessageSpacing: attributes.labelsSpacing
    )
  }

}
