import UIKit
import BrazeKit

let readme =
  """
  This sample presents how to use the Braze provided in-app message UI:

  - AppDelegate.swift:
    - In-app message UI configuration
    - In-app message UI delegate
  - SDWebImageGIFViewProvider.swift:
    - Use SDWebImage to provide gif support to the in-app message UI
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
  )
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

