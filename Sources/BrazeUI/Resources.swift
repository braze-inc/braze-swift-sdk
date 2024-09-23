import Foundation

/// Lock guarding ``BrazeUI/overrideResourcesBundle``.
private let lock = NSRecursiveLock()

/// The override bundle BrazeUI uses to load resources (default: `nil`).
///
/// Set this property to the bundle containing BrazeUI resources when your project cannot
/// automatically include the resources (e.g. Tuist setup)
///
/// - Important: This property needs to be set before the SDK initialization.
public var overrideResourcesBundle: Bundle? {
  get { lock.sync { _overrideResourcesBundle } }
  set { lock.sync { _overrideResourcesBundle = newValue } }
}
// nonisolated(unsafe) attribute for global variable is only available in Xcode 15.3 and later.
#if compiler(>=5.10)
  nonisolated(unsafe) private var _overrideResourcesBundle: Bundle?
#else
  private var _overrideResourcesBundle: Bundle?
#endif

private class BundleFinder {}

/// Resources related utilities.
@objc(BRZUIResources)
public final class BrazeUIResources: NSObject {

  /// The resources bundle.
  @objc
  public static let bundle: Bundle? = {
    // Use overriden resources bundle
    if let overrideResourcesBundle = overrideResourcesBundle {
      return overrideResourcesBundle
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

    // Returns the framework bundle if available
    let frameworkBundle = Bundle(for: BundleFinder.self)
    if let name = frameworkBundle.infoDictionary?["CFBundleName"] as? String,
      name.hasPrefix("BrazeUI")
    {
      return frameworkBundle
    }

    print(
      "[braze] Error: Unable to find UI resources bundle, cannot load localizations and acknowledgments"
    )
    return nil
  }()

  /// Acknowledgments for third-party open-source libraries used by BrazeUI.
  ///
  /// The dictionary maps the library name to the path to the license on the file system.
  @objc
  public static let acknowledgments: [String: URL] = {
    var acknowledgments: [String: URL] = [:]

    if let align = bundle?.url(forResource: "align", withExtension: "license") {
      acknowledgments["align"] = align
    }

    return acknowledgments
  }()

}
