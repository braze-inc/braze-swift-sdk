import BrazeKit
import BrazeUI
import SwiftUI

@available(iOS 13.0, *)
struct FullScreenBannerView: View {

  @State var hasBannerForPlacement: Bool = false
  @State var contentHeight: CGFloat = 0

  var body: some View {
    fullScreenView
      .onAppear {
        AppDelegate.braze?.banners.getBanner(
          for: BannerUI.Constants.fullBannerPlacementID,
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
      sampleBannerView(braze: braze)
    } else {
      Text("An error occurred while loading the banner.")
    }
  }

  private func sampleBannerView(braze: Braze) -> BrazeBannerUI.BannerView {
    var bannerView = BrazeBannerUI.BannerView(
      placementId: BannerUI.Constants.fullBannerPlacementID,
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
    bannerView.onDismiss = { event in
      print("Successfully dismissed banner: \(event.placementId ?? "")")
    }
    return bannerView
  }

}
