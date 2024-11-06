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

      /// Internal state property to trigger `updateUIView` whenever new banners are received from the platform.
      @State var banner: Braze.Banner? = nil

      /// Internal state property to trigger `updateUIView` whenever banners are refreshed with an error.
      @State var error: Swift.Error? = nil

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
        BannerUIView(
          placementId: self.placementId,
          braze: self.braze,
          processContentUpdates: self.processContentUpdates,
          impressionTracker: .shared
        )
      }

      public func updateUIView(_ uiView: BannerUIView, context: Context) {
        if let banner {
          uiView.render(with: banner)
        } else if let error {
          uiView.notifyError(error)
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

      var didReceiveUpdate: (Result<Braze.Banner, Swift.Error>) -> Void

      init(
        placementId: String,
        didReceiveUpdate: @escaping (Result<Braze.Banner, Swift.Error>) -> Void,
        impressionTracker: BrazeBannerUI.BannersImpressionTracker = .shared
      ) {
        self.placementId = placementId
        self.didReceiveUpdate = didReceiveUpdate
        self.impressionTracker = impressionTracker
      }

      public func render(with banner: BrazeKit.Braze.Banner) {
        didReceiveUpdate(.success(banner))
      }

      public func notifyError(_ error: Error) {
        didReceiveUpdate(.failure(error))
      }

    }

    public func makeCoordinator() -> Coordinator {
      let coordinator = Coordinator(placementId: self.placementId) { result in
        switch result {
        case .success(let banner):
          self.banner = banner
        case .failure(let error):
          self.error = error
        }
      }
      self.braze.banners.registerView(coordinator)
      coordinator.impressionTracker.startSessionTracking(with: braze)
      return coordinator
    }

  }

#endif
