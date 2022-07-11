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
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.0.1/BrazeKit.zip",
      checksum: "c71cb83398f626b2684d3f6224b31c7485b43b3075d5b27b3b7765915058288e"
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
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.0.1/BrazeLocation.zip",
      checksum: "8aa54a909d3d1f799f0e979a237165bb2e05f1e8feeb144c3f81194da6511dfa"
    ),
    .binaryTarget(
      name: "BrazeNotificationService",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.0.1/BrazeNotificationService.zip",
      checksum: "b697c8735de6f3bfc4a47b74fe3c3441163be78d626a344d1fce9e41a0775d5b"
    ),
    .binaryTarget(
      name: "BrazePushStory",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.0.1/BrazePushStory.zip",
      checksum: "8427de1ffab1fff49004546d9ec3a4fd4589391a99b7e8d4d9f0cf4ddf2b7ab4"
    ),
  ]
)
