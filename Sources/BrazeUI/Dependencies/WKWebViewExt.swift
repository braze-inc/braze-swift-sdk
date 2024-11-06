import BrazeKit
import WebKit

extension WKWebViewConfiguration {

  /// Returns a web view configuration equipped with Braze bridge scripting.
  ///
  /// - Parameter scriptMessageHandler: The script handler for executing bridge API methods.
  static func forBrazeBridge(scriptMessageHandler: WKScriptMessageHandler) -> WKWebViewConfiguration
  {
    let configuration = WKWebViewConfiguration()
    configuration.suppressesIncrementalRendering = true
    configuration.allowsInlineMediaPlayback = true

    typealias ScriptMessageHandler = Braze.WebViewBridge.ScriptMessageHandler
    configuration.userContentController.addUserScript(ScriptMessageHandler.script)
    configuration.userContentController.add(
      scriptMessageHandler,
      name: ScriptMessageHandler.name
    )

    return configuration
  }

}

extension WKNavigationDelegate {

  /// Validates if a navigation action should occur from a web view context.
  func shouldProcessNavigationAction(_ navigationAction: WKNavigationAction) -> Bool {
    let isIframeLoad =
      navigationAction.targetFrame != nil
      && navigationAction.sourceFrame != navigationAction.targetFrame
    let isIframeNavigation = navigationAction.targetFrame?.isMainFrame == false

    if let url = navigationAction.request.url {
      return !url.isFileURL && !isIframeLoad && !isIframeNavigation
    }

    return false
  }

}

extension WKWebView {

  func disableDragAndDrop() {
    bfsSubviews
      .lazy
      .first { $0.interactions.contains(where: { $0 is UIDragInteraction }) }?
      .interactions
      .filter { $0 is UIDragInteraction }
      .forEach { $0.view?.removeInteraction($0) }
  }

  func disableSelection() {
    evaluateJavaScript(
      """
      const css = `* {
          -webkit-touch-callout: none;
          -webkit-user-select: none;
      }
      input, textarea {
          -webkit-touch-callout: initial !important;
          -webkit-user-select: initial !important;
      }`
      var style = document.createElement('style')
      style.type = 'text/css'
      style.appendChild(document.createTextNode(css))
      head.appendChild(style)
      """
    )
  }

}
