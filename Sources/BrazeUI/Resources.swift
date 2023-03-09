import Foundation

/// The override bundle BrazeUI uses to load resources (default: `nil`).
///
/// Set this property to the bundle containing BrazeUI resources when your project cannot
/// automatically include the resources (e.g. Tuist setup)
///
/// - Important: This property needs to be set before the SDK initialization.
public var overrideResourceBundle: Bundle?

private class BundleFinder {}

/// UI resources bundle.
var resourcesBundle: Bundle? = {
  // Use overriden resource bundle
  if let overrideResourceBundle = overrideResourceBundle {
    return overrideResourceBundle
  }

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
