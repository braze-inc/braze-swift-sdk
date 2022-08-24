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
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.0/BrazeKit.zip",
      checksum: "2c14f47d6d68ff8f73b47df89f1b9ee0011404b9d8fc19c2b56be597e3b19652"
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
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.0/BrazeLocation.zip",
      checksum: "b3b9392ffa08548f5d1f45d33013815c9df08a35abccafc83cd3b7999563e04a"
    ),
    .binaryTarget(
      name: "BrazeNotificationService",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.0/BrazeNotificationService.zip",
      checksum: "90272e2d8e067aa1280635bae08eac303de2276ecf0a9dc4324e6e26546df970"
    ),
    .binaryTarget(
      name: "BrazePushStory",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.0/BrazePushStory.zip",
      checksum: "b7dbea4525251cb902cec732b6e8aa069aad3b4d3d1f43d7318142aa41314402"
    ),
  ]
)
