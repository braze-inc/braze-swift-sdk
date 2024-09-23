import BrazeKit
import UIKit

let readme =
  """
  This sample demonstrates multiple ways to customize the In-App Message UI appearance and behavior.

  Customizations are applied in the `inAppMessage(_:prepareWith:)` delegate method implemented by the `AppDelegate`.
  """

@MainActor
let actions: [(String, String, @MainActor (ReadmeViewController) -> Void)] = [
  (
    "Slideup - Default",
    "A non-customized slideup.",
    slideupDefault
  ),
  (
    "Slideup - Attributes",
    "A slideup with its font, corner radius and image size customized using the attributes object.",
    slideupAttributes
  ),
  (
    "Slideup - Full-width",
    "A full-width slideup, implemented by subclassing the slideup view.",
    slideupFullWidth
  ),
  (
    "Slideup - Confirm button",
    "A non-dismissible slideup with a confirm button that perform the message click action, implemented by subclassing the slideup view.",
    slideupConfirmButton
  ),
  (
    "Modal - Default",
    "A non-customized modal.",
    modalDefault
  ),
  (
    "Modal - Attributes",
    "A modal with its fonts, corner radius customized using the attributes object.",
    modalAttributes
  ),
  (
    "Modal - Dismiss on background tap",
    "A modal that can be dismissed when tapping the background. Customized using the attributes object.",
    modalDismissOnBackgroundTap
  ),
  (
    "Modal - Custom button font",
    "A modal with its button font modified using the attributes object.",
    modalButtonFont
  ),
  (
    "ModalImage - Default",
    "A non-customized modal image.",
    modalImageDefault
  ),
  (
    "ModalImage - Attributes",
    "A modal image with its corner radius customized using the attributes object.",
    modalImageAttributes
  ),
  (
    "ModalImage - Dismiss on background tap",
    "A modal image that can be dismissed when tapping the background. Customized using the attributes object.",
    modalImageDismissOnBackgroundTap
  ),
  (
    "Full - Default",
    "A non-customized full.",
    fullDefault
  ),
  (
    "Full - Attributes",
    "A full with its fonts, corner radius customized (iPad) using the attributes object.",
    fullAttributes
  ),
  (
    "Full - Dismiss on background tap (iPad)",
    "A full that can be dismissed when tapping the background when appearing as a modal (iPad). Customized using the attributes object.",
    fullDismissOnBackgroundTap
  ),
  (
    "FullImage - Default",
    "A non-customized full image.",
    fullImageDefault
  ),
  (
    "FullImage - Attributes",
    "A full image with its corner radius customized (iPad) using the attributes object.",
    fullImageAttributes
  ),
  (
    "FullImage - Dismiss on background tap (iPad)",
    "A full image that can be dismissed when tapping the background when appearing as a modal (iPad). Customized using the attributes object.",
    fullImageDismissOnBackgroundTap
  ),
]

// MARK: - Internal

@MainActor
let slideup: Braze.InAppMessage = .slideup(
  .init(
    graphic: .image(
      .mockImage(
        width: 200, height: 200, text: "🧁", textSize: 128, backgroundColor: .systemBlue,
        drawCorners: false)),
    message: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake."
  )
)

@MainActor
let modal: Braze.InAppMessage = .modal(
  .init(
    graphic: .image(
      .mockImage(
        width: 1450, height: 500, text: "🧁", textSize: 256, backgroundColor: .systemBlue,
        drawCorners: false)),
    header: "Hello world!",
    message:
      "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
    buttons: [.init(id: 0, text: "OK", clickAction: .none, themes: ["light": .primary])]
  )
)

@MainActor
let modalImage: Braze.InAppMessage = .modalImage(
  .init(
    imageURL: .mockImage(
      width: 1200, height: 1200, text: "🧁", textSize: 512, backgroundColor: .systemBlue,
      drawCorners: false),
    buttons: [.init(id: 0, text: "OK", clickAction: .none, themes: ["light": .primary])]
  )
)

@MainActor
let full: Braze.InAppMessage = .full(
  .init(
    imageURL: .mockImage(
      width: 1200, height: 1000, text: "🧁", textSize: 512, backgroundColor: .systemBlue,
      drawCorners: false),
    header: "Hello world!",
    message:
      "Cupcake ipsum dolor sit amet topping. Cookie candy chupa chups jujubes pastry soufflé. Danish cake cheesecake liquorice wafer marshmallow macaroon.",
    buttons: [.init(id: 0, text: "OK", clickAction: .none, themes: ["light": .primary])]
  )
)

@MainActor
let fullImage: Braze.InAppMessage = .fullImage(
  .init(
    imageURL: .mockImage(
      width: 1200, height: 2000, text: "🧁", textSize: 512, backgroundColor: .systemBlue,
      drawCorners: false),
    buttons: [.init(id: 0, text: "OK", clickAction: .none, themes: ["light": .primary])]
  )
)

@MainActor
func slideupDefault(_ viewController: ReadmeViewController) {
  present(message: slideup)
}

@MainActor
func slideupAttributes(_ viewController: ReadmeViewController) {
  var message = slideup
  message.extras = ["customization": "slideup-attributes"]
  present(message: message)
}

@MainActor
func slideupFullWidth(_ viewController: ReadmeViewController) {
  var message = slideup
  message.extras = ["customization": "slideup-full-width"]
  present(message: message)
}

@MainActor
func slideupConfirmButton(_ viewController: ReadmeViewController) {
  var message = slideup
  message.extras = ["customization": "slideup-confirm-button"]
  present(message: message)
}

@MainActor
func modalDefault(_ viewController: ReadmeViewController) {
  present(message: modal)
}

@MainActor
func modalAttributes(_ viewController: ReadmeViewController) {
  var message = modal
  message.extras = ["customization": "modal-attributes"]
  present(message: message)
}

@MainActor
func modalDismissOnBackgroundTap(_ viewController: ReadmeViewController) {
  var message = modal
  message.extras = ["customization": "modal-dismiss-on-background-tap"]
  present(message: message)
}

@MainActor
func modalButtonFont(_ viewController: ReadmeViewController) {
  var message = modal
  message.extras = ["customization": "modal-button-font"]
  present(message: message)
}

@MainActor
func modalImageDefault(_ viewController: ReadmeViewController) {
  present(message: modalImage)
}

@MainActor
func modalImageAttributes(_ viewController: ReadmeViewController) {
  var message = modalImage
  message.extras = ["customization": "modal-image-attributes"]
  present(message: message)
}

@MainActor
func modalImageDismissOnBackgroundTap(_ viewController: ReadmeViewController) {
  var message = modalImage
  message.extras = ["customization": "modal-image-dismiss-on-background-tap"]
  present(message: message)
}

@MainActor
func fullDefault(_ viewController: ReadmeViewController) {
  present(message: full)
}

@MainActor
func fullAttributes(_ viewController: ReadmeViewController) {
  var message = full
  message.extras = ["customization": "full-attributes"]
  present(message: message)
}

@MainActor
func fullDismissOnBackgroundTap(_ viewController: ReadmeViewController) {
  var message = full
  message.extras = ["customization": "full-dismiss-on-background-tap"]
  present(message: message)
}

@MainActor
func fullImageDefault(_ viewController: ReadmeViewController) {
  present(message: fullImage)
}

@MainActor
func fullImageAttributes(_ viewController: ReadmeViewController) {
  var message = fullImage
  message.extras = ["customization": "full-image-attributes"]
  present(message: message)
}

@MainActor
func fullImageDismissOnBackgroundTap(_ viewController: ReadmeViewController) {
  var message = fullImage
  message.extras = ["customization": "full-image-dismiss-on-background-tap"]
  present(message: message)
}

@MainActor
private func present(message: Braze.InAppMessage) {
  AppDelegate.braze?.inAppMessagePresenter?.present(message: message)
}
