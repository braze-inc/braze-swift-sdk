#if canImport(WebKit)

  import BrazeKit

  extension BrazeBannerUI {

    /// The errors reported by the banner UI.
    public enum Error: Swift.Error, Hashable {

      /// An impression cannot be logged because the banner is not a Braze banner.
      case noContextLogImpression

      /// A click cannot be logged because the banner is not a Braze banner.
      case noContextLogClick

      /// A dismissal cannot be logged because the banner is not a Braze banner.
      case noContextLogDismissed

      /// A click action cannot be processed because the banner is not a Braze banner.
      case noContextProcessClickAction

      /// The banner content reported a height of zero or no height.
      case bannerHeightUnavailable

      /// The banner HTML failed to load in the web view.
      case webViewNavigation(Braze.ErrorString)

      /// The web view bridge received an invalid script message.
      case webViewScript(Braze.WebViewBridge.ScriptMessageHandler.Error)

      /// The web view bridge received an invalid scheme request.
      case webViewScheme(Braze.WebViewBridge.SchemeHandler.Error)

      /// The web view bridge received an invalid query.
      case webViewQuery(Braze.WebViewBridge.QueryHandler.Error)

      /// The banner requested a web view bridge method that banners do not support.
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
      case .noContextLogDismissed:
        return "Cannot log dismissed for non-Braze banner."
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

#endif
