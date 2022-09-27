import BrazeKit
import UIKit

let readme =
  """
  This sample presents how to implement your own custom In-App Message UI:

  - AppDelegate.swift:
    - Sets the custom in-app message presenter
  - CustomInAppMessagePresenter.swift:
    - Explains how to use the `Braze.InAppMessage` data model and present the message in a custom view controller.
  """

let actions: [(String, String, (ReadmeViewController) -> Void)] = [
  (
    "Present local slideup in-app message",
    "",
    localSlideup
  ),
  (
    "Present local modal in-app message",
    "",
    localModal
  ),
]

// MARK: - Internal

func localSlideup(_ viewController: ReadmeViewController) {
  let slideup: Braze.InAppMessage = .slideup(
    .init(
      data: .init(
        clickAction: .url(URL(string: "https://example.com")!, useWebView: true),
        extras: ["key1": "value1", "key2": "value2"]
      ),
      graphic: .icon(""),
      message: "Local slideup in-app message"
    )
  )
  AppDelegate.braze?.inAppMessagePresenter?.present(message: slideup)
}

func localModal(_ viewController: ReadmeViewController) {
  let modal: Braze.InAppMessage = .modal(
    .init(
      data: .init(
        clickAction: .url(URL(string: "https://example.com")!, useWebView: true),
        extras: ["key1": "value1", "key2": "value2"]
      ),
      graphic: .icon(""),
      header: "Header text",
      message: "Local modal in-app message"
    )
  )
  AppDelegate.braze?.inAppMessagePresenter?.present(message: modal)
}
