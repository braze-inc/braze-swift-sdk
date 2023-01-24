import Foundation

private class BundleFinder {}

/// UI resources bundle.
var resourcesBundle: Bundle? = {
  let bundleNames = [
    // SwiftPM source target resources
    "braze-swift-sdk_BrazeUI",
    // SwiftPM binary target resources
    "braze-swift-sdk_BrazeUIResources",
    // Cocoapods or prebuilt resources
    "BrazeUI",
  ]

  let candidates = [
    // Bundle should be present here when the package is linked into an App.
    Bundle.main.resourceURL,
    // Bundle should be present here when the package is linked into a framework.
    Bundle(for: BundleFinder.self).resourceURL,
    // For command-line tools.
    Bundle.main.bundleURL,
  ]

  for bundleName in bundleNames {
    for candidate in candidates {
      let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
      if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
        return bundle
      }
    }
  }

  print(
    "[braze] Error: Unable to find UI resources bundle, cannot load localizations and acknowledgments"
  )
  return nil
}()
