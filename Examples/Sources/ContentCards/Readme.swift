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

let actions: [(String, String, (ReadmeViewController) -> Void)] = [
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

func pushContentCardsViewController(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.pushContentCardsViewController()
}

func presentModalContentCardsViewController(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.presentModalContentCardsViewController()
}

func presentModalContentCardsViewControllerCustomized(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?
    .presentModalContentCardsViewControllerCustomized()
}
