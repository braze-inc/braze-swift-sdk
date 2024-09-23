import BrazeKit
import UIKit

let readme =
  """
  This sample demonstrates multiple ways to customize the Content Cards UI appearance and behavior:

  Customizations are applied when presenting the Content Cards UI in the `AppDelegate` methods.
  """

@MainActor
let actions: [(String, String, @MainActor (ReadmeViewController) -> Void)] = [
  (
    "Default",
    "No customization.",
    noCustomization
  ),
  (
    "Custom attributes",
    "Corner radius, fonts, text color and highlight color.",
    attributesCustomization
  ),
  (
    "Tint color",
    "Pin image, unviewed indicator and domain label inherit the current tint color.",
    tintColorCustomization
  ),
  (
    "Custom empty state",
    "Empty state message, font and text color.",
    emptyStateCustomization
  ),
  (
    "Custom ClassicImageCell subclass",
    "Move the image to the trailing part of the cell, make it take the full height of the cell.",
    subclassClassicImageCellCustomization
  ),
  (
    "Static cards",
    "Add static first and last cards to the view controller.",
    staticCardCustomization
  ),
  (
    "Filter cards",
    "Keep only classic content card in the feed.",
    filterCardsCustomization
  ),
  (
    "Transform cards",
    "Modify the cards texts before display.",
    transformCardsCustomization
  ),
  (
    "Disable dark theme",
    "Make cards present in light theme even if the device is in dark mode.",
    disableDarkThemeCustomization
  ),
]

// MARK: - Internal

@MainActor
let classicPinned: Braze.ContentCard = withContext(
  .classic(
    .init(
      data: .init(
        clickAction: .url(URL(string: "https://example.com")!, useWebView: true), pinned: true),
      title: "Classic (pinned)",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake.",
      domain: "example.com"
    )
  )
)

@MainActor
let classic: Braze.ContentCard = withContext(
  .classic(
    .init(
      data: .init(clickAction: .url(URL(string: "https://example.com")!, useWebView: true)),
      title: "Classic",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake.",
      domain: "example.com"
    )
  )
)

@MainActor
let classicImage: Braze.ContentCard = withContext(
  .classicImage(
    .init(
      data: .init(clickAction: .url(URL(string: "https://example.com")!, useWebView: true)),
      image: .mockImage(width: 200, height: 200, text: "🧁", textSize: 128, drawCorners: false),
      title: "Classic Image",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake.",
      domain: "example.com"
    )
  )
)

@MainActor
let imageOnly: Braze.ContentCard = withContext(
  .imageOnly(
    .init(
      data: .init(clickAction: .url(URL(string: "https://example.com")!, useWebView: true)),
      image: .mockImage(width: 1200, height: 675, text: "🧁", textSize: 256, drawCorners: false),
      imageAspectRatio: 1200 / 675
    )
  )
)

@MainActor
let captionedImage: Braze.ContentCard = withContext(
  .captionedImage(
    .init(
      data: .init(clickAction: .url(URL(string: "https://example.com")!, useWebView: true)),
      image: .mockImage(width: 1200, height: 675, text: "🧁", textSize: 256, drawCorners: false),
      title: "Captioned Image",
      description: "Cupcake ipsum dolor sit amet. Topping dessert muffin fruitcake.",
      domain: "example.com"
    )
  )
)

@MainActor
func noCustomization(_ viewController: ReadmeViewController) {
  AppDelegate.noCustomization()
}

@MainActor
func attributesCustomization(_ viewController: ReadmeViewController) {
  AppDelegate.attributesCustomization()
}

@MainActor
func tintColorCustomization(_ viewController: ReadmeViewController) {
  AppDelegate.tintColorCustomization()
}

@MainActor
func emptyStateCustomization(_ viewController: ReadmeViewController) {
  AppDelegate.emptyStateCustomization()
}

@MainActor
func subclassClassicImageCellCustomization(_ viewController: ReadmeViewController) {
  AppDelegate.subclassClassicImageCellCustomization()
}

@MainActor
func staticCardCustomization(_ viewController: ReadmeViewController) {
  AppDelegate.staticCardsCustomization()
}

@MainActor
func filterCardsCustomization(_ viewController: ReadmeViewController) {
  AppDelegate.filterCardsCustomization()
}

@MainActor
func transformCardsCustomization(_ viewController: ReadmeViewController) {
  AppDelegate.transformCardsCustomization()
}

@MainActor
func disableDarkThemeCustomization(_ viewController: ReadmeViewController) {
  AppDelegate.disableDarkThemeCustomization()
}

func withContext(_ card: Braze.ContentCard) -> Braze.ContentCard {
  var card = card

  var loadImage:
    ((@MainActor @Sendable @escaping (Result<URL, Error>) -> Void) -> Braze.Cancellable)?
  if let imageURL = card.imageURL {
    loadImage = { completion in
      DispatchQueue.main.async {
        completion(.success(imageURL))
      }
      return .empty
    }
  }

  card.context = .init(
    logImpression: {},
    logClick: {},
    processClickAction: { clickAction in
      DispatchQueue.main.async {
        switch clickAction {
        case .url(let url, let useWebView):
          let alert = UIAlertController(
            title: "Opening URL",
            message:
              """
              url: \(url)
              useWebView: \(useWebView)
              """,
            preferredStyle: .actionSheet
          )
          alert.addAction(.init(title: "Dismiss", style: .cancel))
          Braze.UIUtils.activeTopmostViewController?.present(alert, animated: true)
        @unknown default:
          print("Unknown click action: \(clickAction)")
        }
      }
    },
    logDismissed: {},
    logError: { _ in },
    loadImage: loadImage
  )

  return card
}
