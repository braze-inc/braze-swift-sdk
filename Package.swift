// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "braze-swift-sdk",
  defaultLocalization: "en",
  platforms: [.iOS(.v10)],
  products: [
    .library(
      name: "BrazeKit",
      targets: ["BrazeKit", "BrazeKitResources"]
    ),
    .library(name: "BrazeUI", targets: ["BrazeUI"]),
    .library(name: "BrazeLocation", targets: ["BrazeLocation"]),
    .library(name: "BrazeNotificationService", targets: ["BrazeNotificationService"]),
    .library(name: "BrazePushStory", targets: ["BrazePushStory"]),
  ],
  dependencies: [
    /* ${dependencies-start} */
    /* ${dependencies-end} */
  ],
  targets: [
    .binaryTarget(
      name: "BrazeKit",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.0.0/BrazeKit.zip",
      checksum: "38175fe6f34aeb55a5c0585b0f7f2d1c34bf1624540e2b811f6ffac7d9850d4d"
    ),
    .target(
      name: "BrazeKitResources",
      resources: [.process("Resources")]
    ),
    .target(
      name: "BrazeUI",
      dependencies: [
        .target(name: "BrazeKit"),
      ],
      resources: [.process("Resources")]
    ),
    .binaryTarget(
      name: "BrazeLocation",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.0.0/BrazeLocation.zip",
      checksum: "c846f1f1fbb7c60545cd4283e672e0b2d48dfbfa75f3dc954e9a7e50bb0d5a32"
    ),
    .binaryTarget(
      name: "BrazeNotificationService",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.0.0/BrazeNotificationService.zip",
      checksum: "08dfcfda3585c6df85e169ee3022a14b29e17fe9b5c744911d351069ecbe4078"
    ),
    .binaryTarget(
      name: "BrazePushStory",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.0.0/BrazePushStory.zip",
      checksum: "eeda9db7055d5c27ee10a4453a5afa9d078a318f02829794497633eba631f917"
    ),
  ]
)
