import BrazeKit
import WebKit

extension InAppMessageView {

  /// Creates and returns a script message handler implementing the Braze JavaScript bridge api.
  public func webViewScriptMessageHandler() -> Braze.WebViewBridge.ScriptMessageHandler {
    let closeMessage: () -> Void = { [weak self] in self?.dismiss(completion: nil) }
    let braze = controller?.message.context?.braze as? Braze

    return .init(
      logClick: { [weak self] in self?.logClick(buttonId: $0) },
      logError: { [weak self] in self?.logError(.webViewScript($0)) },
      showNewsFeed: { [weak self] in self?.process(clickAction: .newsFeed, buttonId: nil) },
      closeMessage: closeMessage,
      braze: braze
    )
  }

  /// Creates and returns a custom scheme handler implementing the logic for scheme-based actions.
  public func webViewSchemeHandler() -> Braze.WebViewBridge.SchemeHandler {
    let closeMessage: () -> Void = { [weak self] in self?.dismiss(completion: nil) }
    let braze = controller?.message.context?.braze as? Braze

    return .init(
      logError: { [weak self] in self?.logError(.webViewScheme($0)) },
      showNewsFeed: { [weak self] in self?.process(clickAction: .newsFeed, buttonId: nil) },
      closeMessage: closeMessage,
      queryHandler: webViewQueryHandler(),
      braze: braze
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
