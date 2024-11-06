import BrazeKit
import BrazeUI
import SwiftUI

@available(iOS 13.0, *)
struct FullScreenBannerView: View {

  static let bannerPlacementID = "sdk-test-1"

  @State var hasBannerForPlacement: Bool = false
  @State var contentHeight: CGFloat = 0

  var body: some View {
    fullScreenView
      .onAppear {
        AppDelegate.braze?.banners.getBanner(
          for: FullScreenBannerView.bannerPlacementID,
          { banner in
            hasBannerForPlacement = banner != nil
          }
        )
      }
  }

  @MainActor
  @ViewBuilder
  var fullScreenView: some View {
    if let braze = AppDelegate.braze,
      hasBannerForPlacement
    {
      BrazeBannerUI.BannerView(
        placementId: FullScreenBannerView.bannerPlacementID,
        braze: braze,
        processContentUpdates: { result in
          switch result {
          case .success(let updates):
            if let height = updates.height {
              self.contentHeight = height
            }
          case .failure(_):
            return
          }
        }
      )
    } else {
      Text("An error occurred while loading the banner.")
    }
  }

}
