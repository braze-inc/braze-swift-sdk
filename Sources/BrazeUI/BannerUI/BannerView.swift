// Disable SwiftUI features for:
// - `arch(arm)` (armv7 - 32 bit arm)
// - `arch(i386)` (32 bit intel simlulator)
// Those architectures do not ship with SwiftUI symbols
// See: https://archive.ph/eMbWT (FB7431741)
#if canImport(SwiftUI) && !arch(arm) && !arch(i386)

  import BrazeKit
  import SwiftUI
  import WebKit

  extension BrazeBannerUI {

    /// A SwiftUI-compatible version of the Braze banner view.
    @MainActor
    @available(iOS 13.0, *)
    public struct BannerView: UIViewRepresentable {

      let placementId: String
      let braze: Braze
      let processContentUpdates: ((Result<BrazeBannerUI.ContentUpdates, Swift.Error>) -> Void)?

      /// A callback invoked whenever a banner is dismissed. Set this for custom behavior, such as additional analytics.
      public var onDismiss: ((Braze.Banner) -> Void)?

      /// Initializes a SwiftUI-compatible version of the Braze Banner view.
      ///
      /// - Parameter placementId: The placement ID for the banner.
      /// - Parameter braze: The Braze instance.
      /// - Parameter processContentUpdates: A closure that provides updated properties.
      public init(
        placementId: String,
        braze: Braze,
        processContentUpdates: ((Result<BrazeBannerUI.ContentUpdates, Swift.Error>) -> Void)? = nil
      ) {
        self.placementId = placementId
        self.braze = braze
        self.processContentUpdates = processContentUpdates
      }

      public func makeUIView(context: Context) -> BannerUIView {
        let uiView = BannerUIView(
          placementId: self.placementId,
          braze: self.braze,
          processContentUpdates: self.processContentUpdates,
          impressionTracker: .shared
        )
        uiView.onDismiss = self.onDismiss
        return uiView
      }

      public func updateUIView(_ uiView: BannerUIView, context: Context) {
        uiView.onDismiss = onDismiss
        context.coordinator.didReceiveUpdate = { [weak uiView] event in
          guard let uiView else { return }
          switch event {
          case .render(let banner):
            uiView.render(with: banner)
          case .removeContent:
            uiView.removeBannerContent()
          case .error(let error):
            uiView.notifyError(error)
          }
        }
      }

    }

  }

  // MARK: - Coordinator

  @available(iOS 13.0, *)
  extension BrazeBannerUI.BannerView {

    // Since SwiftUI views are structs, neither they nor their underlying UIViews are retained in memory.
    // The coordinator is the only reference that persists throughout the view lifecycle.
    // We implement it as the `BrazeBannerPlacement` to receive updates from the platform.
    @MainActor
    public class Coordinator: NSObject, BrazeBannerPlacement {

      public let placementId: String
      let impressionTracker: BrazeBannerUI.BannersImpressionTracker

      var didReceiveUpdate: ((CoordinatorEvent) -> Void)?

      init(
        placementId: String,
        impressionTracker: BrazeBannerUI.BannersImpressionTracker? = nil
      ) {
        self.placementId = placementId
        self.impressionTracker = impressionTracker ?? .shared
      }

      public func render(with banner: BrazeKit.Braze.Banner) {
        didReceiveUpdate?(.render(banner))
      }

      public func notifyError(_ error: Error) {
        didReceiveUpdate?(.error(error))
      }

      public func removeBannerContent() {
        didReceiveUpdate?(.removeContent)
      }

    }

    public func makeCoordinator() -> Coordinator {
      let coordinator = Coordinator(placementId: self.placementId)
      self.braze.banners.registerView(coordinator)
      coordinator.impressionTracker.startSessionTracking(with: braze)
      return coordinator
    }

  }

  @available(iOS 13.0, *)
  extension BrazeBannerUI.BannerView {
    enum CoordinatorEvent {
      case render(Braze.Banner)
      case removeContent
      case error(Swift.Error)
    }
  }

#endif
