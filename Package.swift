// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "braze-swift-sdk",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v11),
    .tvOS(.v11)
  ],
  products: [
    .library(
      name: "BrazeKit",
      targets: ["BrazeKit", "BrazeKitResources"]
    ),
    .library(
      name: "BrazeUI",
      targets: ["BrazeUI"]
    ),
    .library(
      name: "BrazeLocation",
      targets: ["BrazeLocation"]
    ),
    .library(
      name: "BrazeNotificationService",
      targets: ["BrazeNotificationService"]
    ),
    .library(
      name: "BrazePushStory",
      targets: ["BrazePushStory"]
    ),
    .library(
      name: "BrazeKitCompat",
      targets: ["BrazeKitCompat"]
    ),
    .library(
      name: "BrazeUICompat",
      targets: ["BrazeUICompat"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.13.2"),
    /* ${dependencies-start} */
    /* ${dependencies-end} */
  ],
  targets: [
    .binaryTarget(
      name: "BrazeKit",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/6.2.0/BrazeKit.zip",
      checksum: "c04c6e7b47f7911223d37bad568deb7caefee53c49062c2620b96cb5a75e67dc"
    ),
    .target(
      name: "BrazeKitResources",
      resources: [
        .process("Resources"),
      ]
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
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/6.2.0/BrazeLocation.zip",
      checksum: "5568e6363155a2b836622405bba12c78c76184fb5e5ddd9153e84e703ac9f743"
    ),
    .binaryTarget(
      name: "BrazeNotificationService",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/6.2.0/BrazeNotificationService.zip",
      checksum: "5a3d743c8cc7bab42e2e20f25ccea20d37f6f1fe540cad9c4de7d2bf59698d41"
    ),
    .binaryTarget(
      name: "BrazePushStory",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/6.2.0/BrazePushStory.zip",
      checksum: "acda427a3d6995f9e64c3bb03b42a48eeef26e7d67279808736e1d7ef27bb8c5"
    ),
    .target(
      name: "BrazeKitCompat",
      dependencies: [
        .target(name: "BrazeKit"),
        .target(name: "BrazeLocation"),
      ]
    ),
    .target(
      name: "BrazeUICompat",
      dependencies: [
        "BrazeKitCompat",
        "SDWebImage",
      ],
      resources: [
        .process("ABKNewsFeed/Resources"),
        .process("ABKInAppMessage/Resources"),
        .process("ABKContentCards/Resources")
      ],
      publicHeadersPath: "include/AppboyUI"
    ),
  ]
)
