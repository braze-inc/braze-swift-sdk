import BrazeKit

extension BrazeInAppMessageUI {

  public enum Error: Swift.Error, Hashable {
    case noContextLogImpression
    case noContextLogClick
    case noContextProcessClickAction
    case invalidBrazeActions

    case rawToTypedConversion(Braze.ErrorString)

    case noMainThread
    case noMessageView
    case noAppRootViewController
    case noFontAwesome
    case noMatchingOrientation
    case assetsFailure(Braze.ErrorString)

    case otherMessagePresented(push: Bool)
    case messageContextInvalid

    case htmlNoBaseURL
    case webViewNavigation(Braze.ErrorString)
    case webViewScript(Braze.WebViewBridge.ScriptMessageHandler.Error)
    case webViewScheme(Braze.WebViewBridge.SchemeHandler.Error)
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
    case .assetsFailure(let error):
      return
        """
        Unable to present message - failed to retrieve assets
        - description: \(error.localizedDescription)
        - error: \(error)
        """

    case .otherMessagePresented(let push):
      return
        "Unable to present message - another message is already presented.\(push ? " The message has been pushed to the top of the stack." : "")"
    case .messageContextInvalid:
      return
        "Unable to present message - message context is invalid. The message has been discarded and removed from the stack."

    case .htmlNoBaseURL:
      return "Unable to present html in-app message - no base url."
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
    case .deprecation(let message):
      return message
    case .pushAlreadyEnabled:
      return
        """
        Unable to process JavaScript bridge action to request push permission.
        - Push is already enabled.
        """
    case .invalidPushAuthStatus:
      return
        """
        Unable to process JavaScript bridge action to request push permission.
        - Push authorization status not found.
        """
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
