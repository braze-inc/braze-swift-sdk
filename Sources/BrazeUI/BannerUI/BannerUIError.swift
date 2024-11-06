import BrazeKit

extension BrazeBannerUI {

  public enum Error: Swift.Error, Hashable {
    case noContextLogImpression
    case noContextLogClick
    case noContextProcessClickAction
    case bannerHeightUnavailable
    case webViewNavigation(Braze.ErrorString)
    case webViewScript(Braze.WebViewBridge.ScriptMessageHandler.Error)
    case webViewScheme(Braze.WebViewBridge.SchemeHandler.Error)
    case webViewQuery(Braze.WebViewBridge.QueryHandler.Error)
    case webViewFeatureNotAvailable
  }

}

// MARK: - Messages

extension BrazeBannerUI.Error {

  var logDescription: String {
    switch self {
    case .webViewFeatureNotAvailable:
      return "Braze web view bridge method not available for banners. Skipping."
    case .noContextLogImpression:
      return "Cannot log impression for non-Braze banner."
    case .noContextLogClick:
      return "Cannot log click for non-Braze banner."
    case .noContextProcessClickAction:
      return "Cannot process click action for non-Braze banner."
    case .webViewNavigation(let error):
      return "Unable to load html in web view - \(error.logDescription)"
    case .webViewScript(let error):
      return error.logDescription
    case .webViewScheme(let error):
      return error.logDescription
    case .webViewQuery(let error):
      return error.logDescription
    case .bannerHeightUnavailable:
      return
        "Height of banner was zero or unavailable. Please check your banner content or adjust the banner size manually."
    }
  }

  var flattened: Braze.ErrorString {
    .init(logDescription)
  }

}
