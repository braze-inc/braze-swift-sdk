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
    let configuration = Braze.Configuration(apiKey: brazeApiKey, endpoint: brazeEndpoint)
    configuration.logger.level = .info
    let braze = Braze(configuration: configuration)
    AppDelegate.braze = braze

    window?.makeKeyAndVisible()
    return true
  }

  // MARK: - Content Cards

  func printCurrentContentCards() {
    // Print all the cards
    print(AppDelegate.braze?.contentCards.cards ?? [])

    guard let card = AppDelegate.braze?.contentCards.cards.first else { return }

    // Braze.ContentCard is an enum representing the different kind of content cards supported by
    // the Braze platform.
    //
    // All `Braze.ContentCard` have a `.data` property that contains common fields.
    // For instance, you can retrieve the `extras` dictionary / `url` on all content cards:

    print("extras:", card.data.extras)
    print("url:", card.data.clickAction?.url ?? "none")

    // All `.data` properties are directly accessible on the card itself.
    // For instance, you can access the `extras` dictionary / `url` omitting the `.data` key path:

    print("extras:", card.extras)
    print("url:", card.clickAction?.url ?? "none")

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

    // A wrapper / compatibility representation of the card is accessible via `.json()`
    if let jsonData = card.json(),
      let jsonString = String(data: jsonData, encoding: .utf8)
    {
      print(jsonString)
    }

    // A card can always be transformed into a `Braze.ContentCardRaw`, a compatibility
    // representation of the Content Card type.
    let cardRaw = Braze.ContentCardRaw(card)
    print("extras:", cardRaw.extras)
    print("url:", cardRaw.url ?? "none")
  }

  func printCurrentContentCardsRaw() {
    // Convert to `Braze.ContentCardRaw`
    let rawCards = AppDelegate.braze?.contentCards.cards.map {
      Braze.ContentCardRaw($0)
    }

    // Print all the cards
    print(rawCards ?? [])

    guard let cardRaw = rawCards?.first else { return }

    // Braze.ContentCardRaw is an Objective-C compatible NSObject subclass representing the
    // content card object, it matches the platform representation of the Content Card.
    //
    // All fields are directly accessible on the raw card object.

    print("extras:", cardRaw.extras)
    print("url:", cardRaw.url ?? "none")

    if let title = cardRaw.title {
      print("title:", title)
    }

    if let image = cardRaw.image {
      print("image:", image)
    }

    // A wrapper / compatibility representation of the card is accessible via `.json()`
    if let jsonData = cardRaw.json(),
      let jsonString = String(data: jsonData, encoding: .utf8)
    {
      print(jsonString)
    }

    // A raw card can be transformed into a `Braze.ContentCard`, the type-safe representation of the
    // content card object.
    guard let card = try? Braze.ContentCard(cardRaw) else {
      return
    }
    print("extras:", card.extras)
    print("url:", card.clickAction?.url ?? "none")
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
