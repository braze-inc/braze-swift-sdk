import BrazeKit
import WebKit

extension BrazeBannerUI.BannerUIView {

  /// Creates and returns a script message handler implementing the Braze JavaScript bridge API.
  public func webViewScriptMessageHandler() -> Braze.WebViewBridge.ScriptMessageHandler {
    .init(
      channel: .banner,
      logClick: { [weak self] in
        self?.logClick(buttonId: $0)
      },
      logError: { [weak self] in self?.logError(.webViewScript($0)) },
      closeMessage: { [weak self] in self?.logError(.webViewFeatureNotAvailable) },
      setBannerHeight: { [weak self] height in
        self?.processContentUpdates?(.success(.init(height: Double(height))))
      },
      braze: self.braze
    )
  }

  /// Creates and returns a custom scheme handler implementing the logic for scheme-based actions.
  public func webViewSchemeHandler() -> Braze.WebViewBridge.SchemeHandler {
    .init(
      channel: .banner,
      logError: { [weak self] in self?.logError(.webViewScheme($0)) },
      closeMessage: { [weak self] in self?.logError(.webViewFeatureNotAvailable) },
      queryHandler: queryHandler,
      braze: self.braze
    )
  }

  /// Creates and returns an url query handler implementing the logic for query-based actions.
  public func webViewQueryHandler() -> Braze.WebViewBridge.QueryHandler {
    .init(
      logClick: { [weak self] in self?.logClick(buttonId: $0) },
      logError: { [weak self] in self?.logError(.webViewQuery($0)) }
    )
  }

}
