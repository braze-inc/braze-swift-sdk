import BrazeKit
import UIKit

let readme =
  """
  This sample demonstrates how to use the Braze provided Banner UI:

  - AppDelegate.swift:
    - Requesting Banners refresh
    - Banner UI presentation
  """

@MainActor
let actions: [(String, String, @MainActor (ReadmeViewController) -> Void)] = [
  (
    "Display a full-screen banner using UIKit",
    "",
    fullScreenBannerUIKit
  ),
  (
    "Display a full-screen banner using SwiftUI",
    "",
    fullScreenBannerSwiftUI
  ),
  (
    "Display a wide banner using UIKit",
    "",
    wideBannerUIKit
  ),
  (
    "Display a wide banner using SwiftUI",
    "",
    wideBannerSwiftUI
  ),
]

// MARK: - Internal

@MainActor
func fullScreenBannerUIKit(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.displayFullScreenBanner(framework: .uiKit)
}

@MainActor
func fullScreenBannerSwiftUI(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.displayFullScreenBanner(framework: .swiftUI)
}

@MainActor
func wideBannerUIKit(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.displayWideBanner(framework: .uiKit)
}

@MainActor
func wideBannerSwiftUI(_ viewController: ReadmeViewController) {
  (UIApplication.shared.delegate as? AppDelegate)?.displayWideBanner(framework: .swiftUI)
}
