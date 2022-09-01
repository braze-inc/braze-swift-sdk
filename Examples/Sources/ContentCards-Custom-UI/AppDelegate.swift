import BrazeKit
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  static var braze: Braze? = nil

  // The subscription needs to be retained to be active.
  var cardsSubscription: Braze.Cancellable?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Setup Braze
    var configuration = Braze.Configuration(apiKey: brazeApiKey, endpoint: brazeEndpoint)
    configuration.logger.level = .info
    let braze = Braze(configuration: configuration)
    AppDelegate.braze = braze

    window?.makeKeyAndVisible()
    return true
  }

  // MARK: - Content Cards

  func printCurrentContentCards() {
    // Print all the cards
    print(AppDelegate.braze?.contentCards ?? [])

    guard let card = AppDelegate.braze?.contentCards.cards.first else { return }

    // Braze.ContentCard is an enum representing the different kind of content cards supported by
    // the Braze platform.
    //
    // All `Braze.ContentCard` have a `.data` property that contains common fields.
    // For instance, you can retrieve the `extras` dictionary / `uri` on all content cards:

    print("extras:", card.data.extras)
    print("uri:", card.data.clickAction?.uri ?? "none")

    // All `.data` properties are directly accessible on the card itself.
    // For instance, you can access the `extras` dictionary / `uri` omitting the `.data` key path:

    print("extras:", card.extras)
    print("uri:", card.clickAction?.uri ?? "none")

    // To access card specific fields, you can switch on the `card` enum:
    switch card {
    case .classic(let classic):
      print("classic - title:", classic.title)
    case .banner(let banner):
      print("banner - image:", banner.image)
    default:
      break
    }

    // Alternatively, you can access and modify the card specific properties by using one of the
    // card type optional accessor:

    if let title = card.classic?.title {
      print("classic - title:", title)
    }

    if let image = card.banner?.image {
      print("banner - image:", image)
    }
  }

  func refreshContentCards() {
    AppDelegate.braze?.contentCards.requestRefresh { result in
      switch result {
      case .success(let cards):
        print("cards:", cards)
      case .failure(let error):
        print("error:", error)
      }
    }
  }

  func subscribeToContentCardsUpdates() {
    cardsSubscription = AppDelegate.braze?.contentCards.subscribeToUpdates { cards in
      print("cards:", cards)
    }
  }

  func cancelContentCardsUpdatesSubscription() {
    cardsSubscription?.cancel()
  }

  func presentContentCardsInfoViewController() {
    guard let braze = Self.braze else { return }

    let viewController = CardsInfoViewController(cards: braze.contentCards.cards)
    let navigationController = UINavigationController(rootViewController: viewController)
    window?.rootViewController?.present(navigationController, animated: true)
  }

}
