import BrazeKit
import BrazeUI
import SwiftUI

@available(iOS 13.0, *)
struct WideBannerView: View {

  @State var hasBannerForPlacement: Bool = false
  @State var contentHeight: CGFloat = 0

  var body: some View {
    VStack {
      Text("Your Content Here")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      if let braze = AppDelegate.braze,
        hasBannerForPlacement
      {
        sampleBannerView(braze: braze)
          .frame(height: min(contentHeight, BannerUI.Constants.wideBannerMaxHeight))
      }
    }.onAppear {
      AppDelegate.braze?.banners.getBanner(
        for: BannerUI.Constants.wideBannerPlacementID,
        { banner in
          hasBannerForPlacement = banner != nil
        }
      )
    }
  }

  private func sampleBannerView(braze: Braze) -> BrazeBannerUI.BannerView {
    var bannerView = BrazeBannerUI.BannerView(
      placementId: BannerUI.Constants.wideBannerPlacementID,
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
    bannerView.onDismiss = { dismissedBanner in
      print("Successfully dismissed banner: \(dismissedBanner.placementId)")
    }
    return bannerView
  }
}
