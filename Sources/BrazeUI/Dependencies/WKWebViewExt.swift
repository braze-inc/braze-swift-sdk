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
  ///
  /// - Returns: `true` if Braze SDK should intercept the navigation action and handle it internally, `false` to allow the operating system to handle it.
  func brazeShouldIntercept(_ navigationAction: WKNavigationAction) -> Bool {
    // There must be a valid URL to process.
    guard let url = navigationAction.request.url else { return false }

    // Link must be user-initiated and not a file URL.
    guard !url.isFileURL else {
      return false
    }

    // A nil target frame implies an external link navigation (i.e. opening in browser).
    // If there is a target frame, verify that the link is not meant for an embedded iframe.
    if let targetFrame = navigationAction.targetFrame {
      let isSameFrame = targetFrame == navigationAction.sourceFrame
      return isSameFrame && targetFrame.isMainFrame
    }

    return true
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

  /// Wait for the HTML page to be fully loaded.
  ///
  /// - Important: This method requires that the web view implements the Braze JavaScript bridge.
  ///              When the bridge is missing, the completion handler is never called
  ///
  /// - Parameters:
  ///   - handler: The Braze JavaScript bridge script message handler.
  ///   - completion: The completion handler executed when the page is loaded.
  func waitForLoadedState(
    _ handler: Braze.WebViewBridge.ScriptMessageHandler,
    completion: @escaping () -> Void
  ) {
    handler.callAsyncJavaScript(
      """
      Promise.all([
        new Promise(resolve =>
          document.readyState === 'complete' ? resolve() : window.addEventListener('load', resolve)
        ),
        new Promise(resolve =>
          window.brazeBridge ? resolve() : window.addEventListener('ab.BridgeReady', resolve)
        )
      ]);
      """,
      in: self
    ) { result in
      guard case .success = result else { return }
      completion()
    }
  }

}
