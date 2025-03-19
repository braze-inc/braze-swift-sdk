// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "braze-swift-sdk",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v12),
    .macCatalyst(.v13),
    .tvOS(.v12),
    .visionOS(.v1)
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
      targets: ["BrazeLocation", "BrazeLocationResources"]
    ),
    .library(
      name: "BrazeNotificationService",
      targets: ["BrazeNotificationService"]
    ),
    .library(
      name: "BrazePushStory",
      targets: ["BrazePushStory", "BrazePushStoryResources"]
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
    .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.19.7"),
    /* ${dependencies-start} */
    /* ${dependencies-end} */
  ],
  targets: [
    .binaryTarget(
      name: "BrazeKit",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/11.9.0/BrazeKit.zip",
      checksum: "3f3ba5edf7171d3472fa13ef9196103eed03339941e82530bb838273688b5dae"
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
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/11.9.0/BrazeLocation.zip",
      checksum: "a21ca5dbeac835f2f516747b4e8da05345841cb7177468dd1e41a30041123a04"
    ),
    .target(
      name: "BrazeLocationResources",
      resources: [
        .process("Resources"),
      ]
    ),
    .binaryTarget(
      name: "BrazeNotificationService",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/11.9.0/BrazeNotificationService.zip",
      checksum: "d7c9cc5c5e6870aa211d9b0096c52cb8b72b7278f4d7f6cf9324774157a160c0"
    ),
    .binaryTarget(
      name: "BrazePushStory",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/11.9.0/BrazePushStory.zip",
      checksum: "e9eacb28cd84c402a2c57dae07eeb0990edb214c08a2e5de4c725c9896316724"
    ),
    .target(
      name: "BrazePushStoryResources",
      resources: [
        .process("Resources"),
      ]
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
