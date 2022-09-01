import BrazeKit
import UIKit

struct CustomInAppMessagePresenter: BrazeInAppMessagePresenter {

  func present(message: Braze.InAppMessage) {

    // Braze.InAppMessage is an enum representing the different kind of in-app messages supported
    // by the Braze platform.
    //
    // All `Braze.InAppMessage` have a `.data` property that contains common fields.
    // For instance, you can retrieve the `extras` dictionary / `uri` on all in-app messages:

    print("extras:", message.data.extras)
    print("uri:", message.data.clickAction.uri ?? "none")

    // All `.data` properties are directly accessible on the message itself.
    // For instance, you can access the `extras` dictionary / `uri` omitting the `.data` key path:

    print("extras:", message.extras)
    print("uri:", message.clickAction.uri ?? "none")

    // To access message specific fields, you can switch on the `message` enum:
    switch message {
    case .slideup(let slideup):
      print("slideup - slide from:", slideup.slideFrom)
    case .full(let full):
      print("full - header:", full.header)
    default:
      break
    }

    // Alternatively, you can access and modify the message specific properties by using one of the
    // message type optional accessor:

    if let slideFrom = message.slideup?.slideFrom {
      print("slideup - slide from:", slideFrom)
    }

    if let header = message.full?.header {
      print("full - header:", header)
    }

    // Here, we present a custom view controller for the message

    let controller = InAppMessageInfoViewController(message: message)
    let navigationController = UINavigationController(rootViewController: controller)
    Braze.UIUtils.activeTopmostViewController?.present(navigationController, animated: true)
  }

}
