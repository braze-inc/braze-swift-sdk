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
      didSet { updateTextViewContent() }
    }

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
    public init(header: String, message: String, attributes: Attributes) {
      self.header = header
      self.message = message
      self.attributes = attributes

      super.init(frame: .zero)

      // Hierarchy
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
    }

    // MARK: - Misc.

    /// Manually-tuned values to get us closer to our visual spec.
    private enum Layout {
      static let headerLineSpacingScaleFactor = 0.78
      static let messageLineSpacingScaleFactor = 0.47
      static let headerMessageSpacingOffset = 1.0
    }

    private func updateTextViewContent() {
      let text = NSMutableAttributedString()

      // Header
      text.append(
        header.attributed(
          with: [
            .font: attributes.header.font,
            .foregroundColor: attributes.header.color,
          ],
          {
            $0.lineSpacing = 2 * Layout.headerLineSpacingScaleFactor
            $0.alignment = attributes.header.alignment
            $0.paragraphSpacing = max(
              0.0,
              attributes.headerMessageSpacing - Layout.headerMessageSpacingOffset
            )
          })
      )

      // Users don't add newlines to the end of their header text
      // Insert a newline between header and message, but not with the possible extra styling of the header (e.g. font size, etc.)
      // The paragraph spacing set above will occur between the header text and this linebreak.
      text.append(NSAttributedString(string: "\n"))

      // Message
      text.append(
        message.attributed(
          with: [
            .font: attributes.message.font,
            .foregroundColor: attributes.message.color,
          ]
        ) {
          $0.lineSpacing = 4 * Layout.messageLineSpacingScaleFactor
          $0.alignment = attributes.message.alignment
        }
      )

      textView.attributedText = text
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
      attributes: .init(modal: modal, attributes: attributes, traitCollection: traitCollection)
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
