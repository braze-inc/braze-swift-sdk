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
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.1.0/BrazeKit.zip",
      checksum: "714560e8157832e72c1378a66d3a7700a9ceb3de8da0f30b80dfcc24df980049"
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
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.1.0/BrazeLocation.zip",
      checksum: "1c97c98bde84ce28ef398ad5a738bba874cfe76b7d149480db234ff6099381c1"
    ),
    .binaryTarget(
      name: "BrazeNotificationService",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.1.0/BrazeNotificationService.zip",
      checksum: "75eae3528ae3b0c4a520b4f93195e68989c84487e3a8fe4a9cd0fd67bf49b743"
    ),
    .binaryTarget(
      name: "BrazePushStory",
      url: "https://github.com/braze-inc/braze-swift-sdk/releases/download/5.1.0/BrazePushStory.zip",
      checksum: "f41bd5d00391c914609e67a2119c47bcbbb02de1573f56bb152dcd0755b7406d"
    ),
  ]
)
