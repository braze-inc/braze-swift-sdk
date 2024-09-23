import BrazeKit
import UIKit

let readme =
  """
  This sample demonstrates how to use the Braze provided Content Cards UI:

  - AppDelegate.swift:
    - Content cards UI presentation
    - Content cards UI delegate
  - SDWebImageGIFViewProvider.swift:
    - Use SDWebImage to provide GIF support to the Braze UI components
  """

@MainActor
let actions: [(String, String, @MainActor (ReadmeViewController) -> Void)] = [
  (
    "Push content cards view controller",
    "",
    pushContentCardsViewController
  ),
  (
    "Present modal content cards view controller",
    "",
    presentModalContentCardsViewController
  ),
  (
    "Present modal content cards view controller",
    "(customized)",
    presentModalContentCardsViewControllerCustomized
  ),
]

// MARK: - Internal

@MainActor
func pushContentCardsViewController(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.pushContentCardsViewController()
}

@MainActor
func presentModalContentCardsViewController(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.presentModalContentCardsViewController()
}

@MainActor
func presentModalContentCardsViewControllerCustomized(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?
    .presentModalContentCardsViewControllerCustomized()
}
