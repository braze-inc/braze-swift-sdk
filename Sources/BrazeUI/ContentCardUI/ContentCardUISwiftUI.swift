// Disable SwiftUI features for:
// - `arch(arm)` (armv7 - 32 bit arm)
// - `arch(i386)` (32 bit intel simlulator)
// Those architectures do not ship with SwiftUI symbols
// See: https://archive.ph/eMbWT (FB7431741)
#if canImport(SwiftUI) && !arch(arm) && !arch(i386)

  import BrazeKit
  import SwiftUI
  import UIKit

  /// A SwiftUI view which displays Braze Content Cards.
  @available(iOS 13.0, *)
  public struct ContentCardsView: UIViewControllerRepresentable {

    /// The attributes supported by the view.
    ///
    /// Attributes allows customizing the view and its associated cells.
    public typealias Attributes = BrazeContentCardUI.ViewController.Attributes

    weak var braze: Braze?
    let shouldProcess: (Braze.ContentCard.ClickAction, Braze.ContentCard) -> Bool
    let attributes: Attributes

    /// Creates and returns a view displaying the latest content cards fetched by the Braze SDK.
    /// - Parameters:
    ///   - braze: The Braze instance.
    ///   - shouldProcess: Whether Braze should process the Content Card click action. See
    ///                    ``BrazeContentCardUIViewControllerDelegate/contentCard(_:shouldProcess:card:)-6v08v``
    ///                    for more details (default: returns true).
    ///   - attributes: An attributes struct allowing customization of the view and its cells.
    public init(
      braze: Braze?,
      shouldProcess: @escaping (Braze.ContentCard.ClickAction, Braze.ContentCard) -> Bool = {
        _, _ in true
      },
      attributes: Attributes = .defaults
    ) {
      self.braze = braze
      self.shouldProcess = shouldProcess
      self.attributes = attributes
    }

    public func makeUIViewController(context: Context) -> BrazeContentCardUI.ViewController {
      guard let braze = braze else { return .init(initialCards: []) }
      let viewController = BrazeContentCardUI.ViewController(braze: braze, attributes: attributes)
      viewController.delegate = context.coordinator
      return viewController
    }

    public func updateUIViewController(
      _ viewController: BrazeContentCardUI.ViewController,
      context: Context
    ) {
      viewController.delegate = context.coordinator
      viewController.attributes = attributes
      if let braze = braze, braze !== context.coordinator.braze {
        context.coordinator.braze = braze
        viewController.updateWithBraze(braze)
      }
    }

    public func makeCoordinator() -> Coordinator {
      Coordinator(braze: braze, shouldProcess: shouldProcess)
    }

  }

  @available(iOS 13.0, *)
  extension ContentCardsView {

    public class Coordinator: BrazeContentCardUIViewControllerDelegate {

      weak var braze: Braze?
      var shouldProcess: (Braze.ContentCard.ClickAction, Braze.ContentCard) -> Bool

      init(
        braze: Braze?,
        shouldProcess: @escaping (Braze.ContentCard.ClickAction, Braze.ContentCard) -> Bool
      ) {
        self.braze = braze
        self.shouldProcess = shouldProcess
      }

      public func contentCard(
        _ controller: BrazeContentCardUI.ViewController,
        shouldProcess clickAction: Braze.ContentCard.ClickAction,
        card: Braze.ContentCard
      ) -> Bool {
        shouldProcess(clickAction, card)
      }

    }

  }

#endif
