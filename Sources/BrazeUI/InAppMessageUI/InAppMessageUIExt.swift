import BrazeKit

extension BrazeInAppMessageUI {

  private typealias Slideup = Braze.InAppMessage.Slideup
  private typealias Modal = Braze.InAppMessage.Modal
  private typealias ModalImage = Braze.InAppMessage.ModalImage
  private typealias Full = Braze.InAppMessage.Full
  private typealias FullImage = Braze.InAppMessage.FullImage
  private typealias Html = Braze.InAppMessage.Html
  private typealias Control = Braze.InAppMessage.Control

  /// The different display choices supported when receiving an in-app message from the Braze SDK.
  ///
  /// See ``BrazeInAppMessageUIDelegate/inAppMessage(_:displayChoiceForMessage:)-9w1nb``.
  public enum DisplayChoice: Sendable {

    /// The in-app message is displayed immediately.
    case now

    /// The in-app message is **not displayed** and placed on top of the ``BrazeInAppMessageUI/stack``.
    ///
    /// Use ``BrazeInAppMessageUI/presentNext()`` to display the message at the top of the stack.
    case reenqueue

    /// Has identical behavior to ``BrazeInAppMessageUI/DisplayChoice/reenqueue``.
    ///
    /// This option has been deprecated and will be removed in a future update.
    /// Please use ``BrazeInAppMessageUI/DisplayChoice/reenqueue`` instead.
    @available(*, deprecated, renamed: "reenqueue")
    public static var later: Self {
      .reenqueue
    }

    /// The in-app message is discarded.
    case discard
  }

  /// Creates and return an in-app message view when `message` and `attributes` are valid,
  /// returns `nil` otherwise.
  func createMessageView(
    for message: Braze.InAppMessage,
    attributes: ViewAttributes?,
    gifViewProvider: GIFViewProvider
  ) -> InAppMessageView? {

    switch (message, attributes) {

    case (.slideup(let slideup), .slideup(let attributes)):
      return SlideupView(
        message: slideup,
        attributes: attributes,
        gifViewProvider: gifViewProvider
      )

    case (.modal(let modal), .modal(let attributes)):
      return ModalView(
        message: modal,
        attributes: attributes,
        gifViewProvider: gifViewProvider
      )

    case (.modalImage(let modalImage), .modalImage(let attributes)):
      return ModalImageView(
        message: modalImage,
        attributes: attributes,
        gifViewProvider: gifViewProvider
      )

    case (.full(let full), .full(let attributes)):
      return FullView(
        message: full,
        attributes: attributes,
        gifViewProvider: gifViewProvider
      )

    case (.fullImage(let fullImage), .fullImage(let attributes)):
      return FullImageView(
        message: fullImage,
        attributes: attributes,
        gifViewProvider: gifViewProvider
      )

    case (.html(let html), .html(let attributes)):
      return HtmlView(message: html, attributes: attributes)

    case (.control(let control), _):
      return ControlView(message: control)

    default:
      return nil
    }
  }

}

extension BrazeInAppMessageUI {

  /// Wrapper class to contain the corresponding `BrazeKit` struct.
  ///
  /// InAppMessage types are represented as structs and imported from BrazeKit.
  /// This wrapper acts as a workaround to prevent Objective-C metaclass errors.
  final class MessageWrapper<WrappedType> {
    var wrappedValue: WrappedType

    /// Initializes the wrapper with the wrapped struct.
    ///
    /// - Parameter wrappedValue: The wrapped struct type.
    init(wrappedValue: WrappedType) {
      self.wrappedValue = wrappedValue
    }
  }

}
