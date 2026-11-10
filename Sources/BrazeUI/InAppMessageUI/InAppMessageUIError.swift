#if !os(tvOS)

  import BrazeKit

  extension BrazeInAppMessageUI {

    /// The errors reported by the in-app message UI.
    public enum Error: Swift.Error, Hashable {

      /// An impression cannot be logged because the message is not a Braze message.
      case noContextLogImpression

      /// A click cannot be logged because the message is not a Braze message.
      case noContextLogClick

      /// A click action cannot be processed because the message is not a Braze message.
      case noContextProcessClickAction

      /// The click action contains Braze actions that are invalid, so the message is not displayed.
      case invalidBrazeActions

      /// The push primer is invalid.
      case invalidPushPrimer

      /// The raw message could not be converted to a typed message.
      case rawToTypedConversion(Braze.ErrorString)

      /// The in-app message UI was called from a thread other than the main thread.
      case noMainThread

      /// The message view is invalid, so the message is discarded.
      case noMessageView

      /// The application has no root view controller to present from.
      case noAppRootViewController

      /// The Font Awesome font could not be loaded, so icons render incorrectly.
      case noFontAwesome

      /// The message does not support the current orientation or size classes.
      case noMatchingOrientation

      /// No window scene is available to present the message in.
      case noWindowScene

      /// An image or other asset required by the message failed to load.
      case assetsFailure(Braze.ErrorString)

      /// The message constraints are invalid or missing.
      case invalidConstraints

      /// The message was triggered for a user who is no longer the current user.
      case triggeredUserCurrentUserMismatch(
        messageId: String?, currentUser: String?, previousUser: String?)

      /// Another message is already presented.
      /// The associated value indicates whether the message was pushed to the top of the stack.
      case otherMessagePresented(push: Bool)

      /// The presentation context is invalid, so the message is discarded and removed from the stack.
      case messageContextInvalid

      /// The HTML message has no base URL.
      case htmlNoBaseURL

      /// The HTML message could not be written to disk.
      case htmlFileWrite(Braze.ErrorString)

      /// The HTML message failed to load in the web view.
      case webViewNavigation(Braze.ErrorString)

      /// The web view bridge received an invalid script message.
      case webViewScript(Braze.WebViewBridge.ScriptMessageHandler.Error)

      /// The web view bridge received an invalid scheme request.
      case webViewScheme(Braze.WebViewBridge.SchemeHandler.Error)

      /// The web view bridge received an invalid query.
      case webViewQuery(Braze.WebViewBridge.QueryHandler.Error)
    }

  }

  // MARK: - Messages

  extension BrazeInAppMessageUI.Error {

    var logDescription: String {
      switch self {
      case .noContextLogImpression:
        return "Cannot log impression for non-braze in-app message."
      case .noContextLogClick:
        return "Cannot log click for non-braze in-app message."
      case .noContextProcessClickAction:
        return "Cannot process click action for non-braze in-app message."
      case .invalidBrazeActions:
        return "Invalid Braze Actions found in click action. Skipping display."
      case .invalidPushPrimer:
        return "Invalid push primer."

      case .rawToTypedConversion(let error):
        return
          """
          Cannot convert raw in-app message to typed in-app message, error:
          - description: \(error.localizedDescription)
          - error: \(error)
          """

      case .noMainThread:
        return
          "Unable to present message - BrazeInAppMessageUI apis must be called from the main thread."
      case .noMessageView:
        return
          "Unable to present message - invalid in-app message view. The message has been discarded."
      case .noAppRootViewController:
        return "Unable to present message - unable to find the app root view controller."
      case .noFontAwesome:
        return "Unable to load FontAwesome - icons will not be rendered correctly."
      case .noMatchingOrientation:
        return
          "Unable to present message - current orientation / size classes are not supported by the message."
      case .noWindowScene:
        return "Unable to present message - no window scene available to present message."
      case .assetsFailure(let error):
        return
          """
          Unable to present message - failed to retrieve assets
          - description: \(error.localizedDescription)
          - error: \(error)
          """
      case .invalidConstraints:
        return
          "Unable to present message - constraints were invalid or nil."
      case .triggeredUserCurrentUserMismatch(let messageId, let currentUser, let previousUser):
        return
          """
          Skipping message presentation - the current user is not the user who triggered the message.
          - in-app message: \(messageId ?? "No message ID")
          - current user: \(currentUser ?? "anonymous user")
          - original user: \(previousUser ?? "anonymous user")
          """

      case .otherMessagePresented(let push):
        return
          "Unable to present message - another message is already presented.\(push ? " The message has been pushed to the top of the stack." : "")"
      case .messageContextInvalid:
        return
          "Unable to present message - message context is invalid. The message has been discarded and removed from the stack."

      case .htmlNoBaseURL:
        return "Unable to present html in-app message - no base url."
      case .htmlFileWrite(let error):
        return
          """
          Unable to write HTML in-app message file.
          - description: \(error.localizedDescription)
          - error: \(error)
          """
      case .webViewNavigation(let error):
        return "Unable to load html in web view - \(error.logDescription)"
      case .webViewScript(let error):
        return error.logDescription
      case .webViewScheme(let error):
        return error.logDescription
      case .webViewQuery(let error):
        return error.logDescription
      }
    }

    var flattened: Braze.ErrorString {
      .init(logDescription)
    }

  }

  extension Braze.WebViewBridge.ScriptMessageHandler.Error {

    var logDescription: String {
      switch self {
      case .invalidPayload(let payload):
        return
          """
          Unable to process JavaScript bridge action - payload received from JavaScript side is invalid.
          - payload: \(String(describing: payload))
          """
      case .noBrazeInstance(let action, let args):
        return
          """
          Unable to process JavaScript bridge action - missing Braze instance.
          - action: \(action)
          - args: \(args)
          """
      case .invalidArg(let action, let index, let arg, let type):
        return
          """
          Unable to process JavaScript bridge action - invalid argument.
          - action: \(action ?? "<unknown>")
          - index: \(index)
          - arg: \(arg)
          - type: \(type)
          """
      case .noBridgeWebView:
        return
          """
          The web view does not integrate the JavaScript bridge.
          """
      case .jsError(let error):
        return
          """
          Encountered error when executing JavaScript.
          - error: \(error)
          """
      case .deprecation(let message):
        return message
      case .unknown(let error):
        return error.logDescription
      @unknown default:
        return "@unknown error"
      }
    }

  }

  extension Braze.WebViewBridge.SchemeHandler.Error {

    var logDescription: String {

      switch self {
      case .invalidCustomEvent(let url):
        return
          """
          Unable to process custom event from url.
          - url: \(url)
          """
      case .invalidAction(let url):
        return
          """
          Unable to process action from url.
          - url: \(url)
          """
      case .noBrazeInstance(let url):
        return
          """
          Unable to process action from url - missing Braze instance.
          - url: \(url)
          """
      @unknown default:
        return "@unknown error"
      }

    }

  }

  extension Braze.WebViewBridge.QueryHandler.Error {

    var logDescription: String {

      switch self {
      case .invalidButtonId(let id):
        return
          """
          Unable to log button click - only 0 and 1 are valid button ids.
          - id: \(String(describing: id))
          """
      @unknown default:
        return "@unknown error"
      }

    }

  }

#endif
