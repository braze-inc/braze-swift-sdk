// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "braze-swift-sdk",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v10), 
    .tvOS(.v10),
  ],
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
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.2/BrazeKit.zip",
      checksum: "f7cb7563ad60598bec09948a1f5694d62443d237e9f4f6e15011176b6d36971f"
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
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.2/BrazeLocation.zip",
      checksum: "83896e93aa4880bccf01827aa9c3a60f75b786e23e316c8986240bd7f52b85d9"
    ),
    .binaryTarget(
      name: "BrazeNotificationService",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.2/BrazeNotificationService.zip",
      checksum: "eb1dc33d9412accce3734cf3ba774cee624993faaf52b5d14cc295d2ae9e3537"
    ),
    .binaryTarget(
      name: "BrazePushStory",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.2/BrazePushStory.zip",
      checksum: "621fc728f28007134b4099fe0204b8f8f1919186404849fbd2d8b2fb4651c53f"
    ),
  ]
)
