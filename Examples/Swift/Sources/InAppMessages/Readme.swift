import BrazeKit
import UIKit

let readme =
  """
  This sample demonstrates how to use the Braze provided In-App Message UI:

  - AppDelegate.swift:
    - In-app message UI configuration
    - In-app message UI delegate
  - SDWebImageGIFViewProvider.swift:
    - Use SDWebImage to provide GIF support to the Braze UI components
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
      graphic: .icon(""),
      message: "Local slideup in-app message"
    )
  )
  AppDelegate.braze?.inAppMessagePresenter?.present(message: slideup)
}

func localModal(_ viewController: ReadmeViewController) {
  let modal: Braze.InAppMessage = .modal(
    .init(
      graphic: .icon(""),
      header: "Header text",
      message: "Local modal in-app message"
    )
  )
  AppDelegate.braze?.inAppMessagePresenter?.present(message: modal)
}
