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
  }

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
    if let url = persistence.availableFileURL(named: fileName, in: payload.baseURL) {
      loadWebView(at: url, allowingReadAccessTo: payload.baseURL)
      return
    }

    // Convert the HTML string into UTF-8 data before hitting the persistence layer.
    guard let data = payload.html.data(using: .utf8) else {
      onFailure(RendererError.encodingFailure)
      return
    }

    persistence.write(
      content: data,
      named: fileName,
      in: payload.baseURL
    ) { [weak self] result in
      guard let self else { return }
      // Discard writes that were kicked off for older states.
      guard self.lastState == state else { return }

      switch result {
      case .success(let url):
        // Once the write succeeds, hand the file off to the web view.
        self.loadWebView(at: url, allowingReadAccessTo: payload.baseURL)
      case .failure(let error):
        // Surface write failures so callers can dismiss and report.
        self.onFailure(error)
      }
    }
  }

  private func loadWebView(at url: URL, allowingReadAccessTo baseURL: URL) {
    guard let webView = webViewProvider() else { return }
    webView.loadFileURL(url, allowingReadAccessTo: baseURL)
  }
}
