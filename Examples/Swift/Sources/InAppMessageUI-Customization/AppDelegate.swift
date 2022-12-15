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
    let configuration = Braze.Configuration(apiKey: brazeApiKey, endpoint: brazeEndpoint)
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

// MARK: - Customizations

extension AppDelegate: BrazeInAppMessageUIDelegate {

  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    prepareWith context: inout BrazeInAppMessageUI.PresentationContext
  ) {
    let customization = context.message.extras["customization"] as? String

    // Slideup - Attributes
    if customization == "slideup-attributes" {
      var attributes = context.attributes?.slideup
      attributes?.font = UIFont(name: "Chalkduster", size: 17)!
      attributes?.imageSize = CGSize(width: 65, height: 65)
      attributes?.cornerRadius = 20
      attributes?.imageCornerRadius = 10
      if #available(iOS 13.0, *) {
        attributes?.cornerCurve = .continuous
        attributes?.imageCornerCurve = .continuous
      }
      context.attributes?.slideup = attributes
    }

    // Slideup - Full-width
    if customization == "slideup-full-width", let slideup = context.message.slideup {
      context.customView = FullWidthSlideupView(message: slideup)

      // The full-width view also support attributes. Uncomment the code below to setup the view
      // with more customizations.
      /*
      var attributes = FullWidthSlideupView.defaultAttributes
      attributes.cornerRadius = 0
      attributes.imageCornerRadius = 10
      context.customView = FullWidthSlideupView(message: slideup, attributes: attributes)
      */
    }

    // Slideup - Confirm button
    if customization == "slideup-confirm-button", let slideup = context.message.slideup {
      context.customView = ConfirmButtonSlideupView(message: slideup)

      // The confirm-button view also support attributes. Uncomment the code below to setup the view
      // with more customizations.
      /*
      var attributes = ConfirmButtonSlideupView.defaultAttributes
      attributes.imageSize = CGSize(width: 65, height: 65)
      attributes.cornerRadius = 20
      attributes.imageCornerRadius = 10
      if #available(iOS 13.0, *) {
        attributes.cornerCurve = .continuous
        attributes.imageCornerCurve = .continuous
      }
      context.customView = ConfirmButtonSlideupView(message: slideup, attributes: attributes)
      */
    }

    // Modal - Attributes
    if customization == "modal-attributes" {
      var attributes = context.attributes?.modal
      attributes?.headerFont = UIFont(name: "AmericanTypewriter-Bold", size: 20)!
      attributes?.messageFont = UIFont(name: "AmericanTypewriter", size: 17)!
      attributes?.cornerRadius = 20
      if #available(iOS 13.0, *) {
        attributes?.cornerCurve = .continuous
      }
      context.attributes?.modal = attributes
    }

    // Modal - Dismiss on background tap
    if customization == "modal-dismiss-on-background-tap" {
      context.attributes?.modal?.dismissOnBackgroundTap = true
    }

    // Modal - Custom button font
    if customization == "modal-button-font" {
      context.attributes?.modal?.buttonsAttributes.font = UIFont(
        name: "AmericanTypewriter-Bold", size: 17)!
    }

    // ModalImage - Attributes
    if customization == "modal-image-attributes" {
      var attributes = context.attributes?.modalImage
      attributes?.cornerRadius = 20
      if #available(iOS 13.0, *) {
        attributes?.cornerCurve = .continuous
      }
      context.attributes?.modalImage = attributes
    }

    // ModalImage - Dismiss on background tap
    if customization == "modal-image-dismiss-on-background-tap" {
      context.attributes?.modalImage?.dismissOnBackgroundTap = true
    }

    // Full - Attributes
    if customization == "full-attributes" {
      var attributes = context.attributes?.full
      attributes?.headerFont = UIFont(name: "AmericanTypewriter-Bold", size: 20)!
      attributes?.messageFont = UIFont(name: "AmericanTypewriter", size: 17)!
      attributes?.cornerRadius = 20
      if #available(iOS 13.0, *) {
        attributes?.cornerCurve = .continuous
      }
      context.attributes?.full = attributes
    }

    // Full - Dismiss on background tap
    if customization == "full-dismiss-on-background-tap" {
      context.attributes?.full?.dismissOnBackgroundTap = true
    }

    // FullImage - Attributes
    if customization == "full-image-attributes" {
      var attributes = context.attributes?.fullImage
      attributes?.cornerRadius = 20
      if #available(iOS 13.0, *) {
        attributes?.cornerCurve = .continuous
      }
      context.attributes?.fullImage = attributes
    }

    // FullImage - Dismiss on background tap
    if customization == "full-image-dismiss-on-background-tap" {
      context.attributes?.fullImage?.dismissOnBackgroundTap = true
    }
  }

}
