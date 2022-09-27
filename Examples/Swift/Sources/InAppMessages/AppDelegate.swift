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

    // - InAppMessage UI
    let inAppMessageUI = BrazeInAppMessageUI()
    inAppMessageUI.delegate = self
    braze.inAppMessagePresenter = inAppMessageUI

    window?.makeKeyAndVisible()
    return true
  }

}

extension AppDelegate: BrazeInAppMessageUIDelegate {

  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    prepareWith context: inout BrazeInAppMessageUI.PresentationContext
  ) {
    // Customize the in-app message presentation here using the context
  }

  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    shouldProcess clickAction: Braze.InAppMessage.ClickAction,
    buttonId: String?,
    message: Braze.InAppMessage,
    view: InAppMessageView
  ) -> Bool {
    // Intercept the in-app message click action here
    return true
  }

  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    didPresent message: Braze.InAppMessage,
    view: InAppMessageView
  ) {
    // Executed when `message` is presented to the user
  }

}
