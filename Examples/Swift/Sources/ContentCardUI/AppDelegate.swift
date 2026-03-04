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

  // MARK: - Displaying Content Cards

  func pushContentCardsViewController() {
    guard let braze = Self.braze,
      let navigationController = window?.rootViewController as? UINavigationController
    else { return }

    // Create a content card view controller that can be pushed onto a navigation stack.
    let viewController = BrazeContentCardUI.ViewController(braze: braze)
    // Set the delegate
    viewController.delegate = self
    // Push it onto the navigation stack
    navigationController.pushViewController(viewController, animated: true)
  }

  func presentModalContentCardsViewController() {
    guard let braze = Self.braze,
      let navigationController = window?.rootViewController as? UINavigationController
    else { return }

    // Create a content card modal view controller that can be presented modally.
    let modalViewController = BrazeContentCardUI.ModalViewController(braze: braze)
    // Set the delegate
    modalViewController.viewController.delegate = self
    // Present modally
    navigationController.present(modalViewController, animated: true)
  }

  func presentModalContentCardsViewControllerCustomized() {
    guard let braze = Self.braze,
      let navigationController = window?.rootViewController as? UINavigationController
    else { return }

    // Create custom attributes to change how the content cards view controller behaves and appears.
    var attributes = BrazeContentCardUI.ViewController.Attributes.defaults
    attributes.pullToRefresh = false
    attributes.cellAttributes.cornerRadius = 16
    attributes.cellAttributes.highlightColor = .systemGreen
    attributes.cellAttributes.titleFont = .italicSystemFont(ofSize: 16)
    attributes.cellAttributes.shadow = nil

    // Create a content card modal view controller using the custom attributes.
    let modalViewController = BrazeContentCardUI.ModalViewController(
      braze: braze,
      attributes: attributes
    )
    // Set the delegate
    modalViewController.viewController.delegate = self
    // Present modally
    navigationController.present(modalViewController, animated: true)
  }

}

// MARK: - Content Cards delegate

extension AppDelegate: BrazeContentCardUIViewControllerDelegate {

  func contentCard(
    _ controller: BrazeContentCardUI.ViewController,
    shouldProcess clickAction: Braze.ContentCard.ClickAction,
    card: Braze.ContentCard
  ) -> Bool {
    // Intercept the content card click action here
    return true
  }

}
