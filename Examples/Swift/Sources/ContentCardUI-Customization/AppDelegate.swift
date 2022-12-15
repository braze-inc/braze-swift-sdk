import BrazeKit
import BrazeUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  static var braze: Braze? = nil

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Setup Braze
    let configuration = Braze.Configuration(apiKey: brazeApiKey, endpoint: brazeEndpoint)
    configuration.logger.level = .info
    let braze = Braze(configuration: configuration)
    AppDelegate.braze = braze

    // - GIF support
    GIFViewProvider.shared = .sdWebImage

    window?.makeKeyAndVisible()
    return true
  }

}

// MARK: - Customizations

#warning("""
For demonstration purposes, this example application uses an alternate Content Card view controller initializer.

In your implementation, you are expected to use the standard `init(braze:attributes:)` initializer to automatically link the UI to your braze instance.

See https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/brazecontentcardui/viewcontroller/init(braze:attributes:)
""")

extension AppDelegate {

  static func noCustomization() {
    let viewController = BrazeContentCardUI.ViewController(initialCards: cards)
    viewController.title = "No customization"
    navigationController.pushViewController(viewController, animated: true)
  }

  static func attributesCustomization() {
    var attributes = BrazeContentCardUI.ViewController.Attributes.defaults

    // Customize the cell attributes to customize the cell
    attributes.cellAttributes.cornerRadius = 20
    attributes.cellAttributes.classicImageCornerRadius = 10
    if #available(iOS 13.0, *) {
      attributes.cellAttributes.cornerCurve = .continuous
    }

    attributes.cellAttributes.titleFont = UIFont(name: "AvenirNext-Heavy", size: 18)!
    attributes.cellAttributes.descriptionFont = UIFont(name: "BradleyHandITCTT-Bold", size: 16)!
    attributes.cellAttributes.domainFont = UIFont(name: "TimesNewRomanPSMT", size: 12)!
    if #available(iOS 13.0, *) {
      attributes.cellAttributes.domainColor = .secondaryLabel
    } else {
      attributes.cellAttributes.domainColor = .gray
    }
    attributes.cellAttributes.highlightColor = .systemGreen.withAlphaComponent(0.8)

    let viewController = BrazeContentCardUI.ViewController(
      initialCards: cards,
      attributes: attributes
    )
    viewController.title = "Attributes"
    navigationController.pushViewController(viewController, animated: true)
  }

  static func tintColorCustomization() {
    let viewController = BrazeContentCardUI.ViewController(initialCards: cards)

    // The unviewed indicator, pin image and domain label color inherit the app's tint color
    viewController.view.tintColor = .systemGreen

    viewController.title = "Tint color"
    navigationController.pushViewController(viewController, animated: true)
  }

  static func subclassClassicImageCellCustomization() {
    var attributes = BrazeContentCardUI.ViewController.Attributes.defaults
    attributes.cells[BrazeContentCardUI.ClassicImageCell.identifier] = CustomClassicImageCell.self

    let viewController = BrazeContentCardUI.ViewController(
      initialCards: cards,
      attributes: attributes
    )
    viewController.title = "Classic Image Cell subclass"
    navigationController.pushViewController(viewController, animated: true)
  }

  static func staticCardsCustomization() {
    var attributes = BrazeContentCardUI.ViewController.Attributes.defaults

    // Create two static cards
    let headerCard: Braze.ContentCard = .banner(
      .init(
        data: .init(viewed: true),
        image: .mockImage(
          width: 1200, height: 675, text: "Static header card", backgroundColor: .systemOrange,
          drawCorners: false)
      )
    )
    let footerCard: Braze.ContentCard = .banner(
      .init(
        data: .init(viewed: true),
        image: .mockImage(
          width: 1200, height: 675, text: "Static footer card", backgroundColor: .systemOrange,
          drawCorners: false)
      )
    )

    // Set the transform attributes which allows the modification of the list of content cards
    // presented.
    // Here we return the braze cards with static header and footer cards.
    attributes.transform = { cards in
      [headerCard] + cards + [footerCard]
    }

    let viewController = BrazeContentCardUI.ViewController(
      initialCards: cards,
      attributes: attributes
    )
    viewController.title = "Static cards"
    navigationController.pushViewController(viewController, animated: true)
  }

  static func filterCardsCustomization() {
    var attributes = BrazeContentCardUI.ViewController.Attributes.defaults

    // Set the transform attributes which allows the modification of the list of content cards
    // presented.
    // Here we return the braze cards filtered to keep only the classic cards.
    attributes.transform = { cards in
      cards.filter { $0.classic != nil }
    }

    let viewController = BrazeContentCardUI.ViewController(
      initialCards: cards,
      attributes: attributes
    )
    viewController.title = "Filtered cards"
    navigationController.pushViewController(viewController, animated: true)
  }

  static func transformCardsCustomization() {
    var attributes = BrazeContentCardUI.ViewController.Attributes.defaults

    // Set the transform attributes which allows the modification of the list of content cards
    // presented.
    // Here we return the braze cards modified so that the title and description properties have the
    // "[modified]" prefix.
    attributes.transform = { cards in
      return cards.map { card in
        var card = card
        if let title = card.title {
          card.title = "[modified] \(title)"
        }
        if let description = card.description {
          card.description = "[modified] \(description)"
        }
        return card
      }
    }

    let viewController = BrazeContentCardUI.ViewController(
      initialCards: cards,
      attributes: attributes
    )
    viewController.title = "Transform cards"
    navigationController.pushViewController(viewController, animated: true)
  }

  static func emptyStateCustomization() {
    var attributes = BrazeContentCardUI.ViewController.Attributes.defaults

    attributes.emptyStateMessage = "This is a custom empty state message"
    attributes.emptyStateMessageFont = .preferredFont(forTextStyle: .title1)
    if #available(iOS 13.0, *) {
      attributes.emptyStateMessageColor = .secondaryLabel
    } else {
      attributes.emptyStateMessageColor = .lightGray
    }

    let viewController = BrazeContentCardUI.ViewController(initialCards: [], attributes: attributes)
    viewController.title = "Empty State"
    navigationController.pushViewController(viewController, animated: true)
  }

}

// MARK: - Helpers

private var cards: [Braze.ContentCard] = [
  classicPinned,
  classic,
  classicImage,
  banner,
  captionedImage,
]

private var navigationController: UINavigationController {
  UIApplication.shared.delegate!.window!!.rootViewController! as! UINavigationController
}
