import BrazeKit
import UIKit

let readme =
  """
  This sample presents how to implement your own custom Content Cards UI:

  - AppDelegate.swift:
    - Content cards API usage
    - Content cards custom UI presentation
  - CardsInfoViewController.swift:
    - UIViewController subclass presenting the content cards data in a table view.
  """

@MainActor
let actions: [(String, String, @MainActor (ReadmeViewController) -> Void)] = [
  (
    "Print current Content Cards",
    "",
    printCurrentContentCards
  ),
  (
    "Print current Content Cards Raw",
    "",
    printCurrentContentCardsRaw
  ),
  (
    "Refresh Content Cards",
    "",
    refreshContentCards
  ),
  (
    "Subscribe to Content Cards updates",
    "",
    subscribeToContentCardsUpdates
  ),
  (
    "Cancel Content Cards updates subscription",
    "",
    cancelContentCardsUpdatesSubscription
  ),
  (
    "Present Content Cards Info view controller",
    "",
    presentContentCardsInfoViewController
  ),
]

// MARK: - Internal

@MainActor
func printCurrentContentCards(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.printCurrentContentCards()
}

@MainActor
func printCurrentContentCardsRaw(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.printCurrentContentCardsRaw()
}

@MainActor
func refreshContentCards(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.refreshContentCards()
}

@MainActor
func subscribeToContentCardsUpdates(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.subscribeToContentCardsUpdates()
}

@MainActor
func cancelContentCardsUpdatesSubscription(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.cancelContentCardsUpdatesSubscription()
}

@MainActor
func presentContentCardsInfoViewController(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.presentContentCardsInfoViewController()
}
