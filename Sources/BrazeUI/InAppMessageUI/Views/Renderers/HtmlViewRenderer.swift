import Foundation
@preconcurrency import WebKit

/// Renders HTML in-app messages by persisting their payload to disk before loading it into a
/// web view. The renderer keeps track of the last state to prevent stale writes from updating the
/// web view after newer content has been requested.
@MainActor
final class HtmlViewRenderer: InAppMessageRenderer {

  struct Payload {
    var html: String
    var baseURL: URL
    /// When `true` the renderer uses `loadFileURL` so relative paths to on-disk assets resolve
    /// correctly. When `false` it uses `loadHTMLString` with an https:// base URL so that
    /// embedded iframes (e.g. YouTube) receive a valid Referer instead of a file:// origin.
    var hasLocalAssets: Bool = false
  }

  /// Synthetic https:// base URL passed to `loadHTMLString` for asset-free HTML IAMs.
  ///
  /// Giving the document an https:// origin ensures YouTube iframes (and similar embeds) receive a
  /// valid Referer header. YouTube rejects `file://` origins on iOS with a player error.
  ///
  /// Matches the dummy domain Android uses in `loadDataWithBaseURL` for the same reason
  /// (`WebContentUtils.ASSET_LOADER_DUMMY_DOMAIN = "iamcache.braze"`).
  static let httpsBaseURL = URL(string: "https://iamcache.braze")

  private enum RendererError: Error {
    case encodingFailure
  }

  private let persistence: InAppMessagePersistenceProtocol
  private let fileName: String
  private let webViewProvider: () -> WKWebView?
  private let onFailure: (Error) -> Void
  private var lastState: InAppMessageContentState?

  init(
    persistence: InAppMessagePersistenceProtocol,
    fileName: String = "index.html",
    webViewProvider: @escaping () -> WKWebView?,
    onFailure: @escaping (Error) -> Void
  ) {
    self.persistence = persistence
    self.fileName = fileName
    self.webViewProvider = webViewProvider
    self.onFailure = onFailure
  }

  func update(with state: InAppMessageContentState, payload: Payload) {
    // Remember the most recent state so we can drop stale write completions later on.
    lastState = state

    // Fast path: if the file already exists, jump straight to rendering.
    if persistence.availableFileURL(named: fileName, in: payload.baseURL) != nil {
      loadWebView(payload: payload)
      return
    }

    // Convert the HTML string into UTF-8 data before hitting the persistence layer.
    guard let data = payload.html.data(using: .utf8) else {
      onFailure(RendererError.encodingFailure)
      return
    }

    let expectedState = state
    let savedPayload = payload

    persistence.write(
      content: data,
      named: fileName,
      in: payload.baseURL
    ) { [weak self] result in
      DispatchQueue.main.async { [weak self] in
        guard let renderer = self else { return }
        // Discard writes that were kicked off for older states.
        guard renderer.lastState == expectedState else { return }

        switch result {
        case .success:
          renderer.loadWebView(payload: savedPayload)
        case .failure(let error):
          // Surface write failures so callers can dismiss and report.
          renderer.onFailure(error)
        }
      }
    }
  }

  private func loadWebView(payload: Payload) {
    guard let webView = webViewProvider() else { return }
    if payload.hasLocalAssets {
      webView.loadFileURL(
        payload.baseURL.appendingPathComponent(fileName),
        allowingReadAccessTo: payload.baseURL
      )
    } else {
      webView.loadHTMLString(payload.html, baseURL: Self.httpsBaseURL)
    }
  }
}
