import Foundation
import UIKit
import BrazeKit

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
nonisolated(unsafe) private var _overrideResourcesBundle: Bundle?

extension UIView {
  
  /// Sets the view's `accessibilityLabel` and `isAccessibilityElement` properties if `altText` is
  /// non-`nil`.
  /// - Parameters:
  ///   - altText: Accessibility alt text to be read for the view's image or icon (if any) when in
  ///   VoiceOver mode.
  func addAccessibilityAltText(_ altText: String?) {
    if let altText {
      accessibilityLabel = altText
      isAccessibilityElement = true
    }
  }
  
  /// Sets the `accessibilityLanguage` property of the view and all of its subviews.
  /// - Parameters:
  ///   - language:The language (BCP 47 format) of narrator to use when reading the view's text
  ///   content in accessibility VoiceOver mode.
  func applyAccessibilityLanguage(_ language: String?) {
    self.accessibilityLanguage = language
    for subview in self.subviews {
      subview.applyAccessibilityLanguage(language)
    }
  }
  
}

private class BundleFinder {}

/// Resources related utilities.
@objc(BRZUIResources)
public final class BrazeUIResources: NSObject {

  /// The resources bundle.
  @objc
  public static let bundle: Bundle? = {
    // Use overriden resources bundle
    if let overrideResourcesBundle {
      return overrideResourcesBundle
    }

    #if SWIFT_PACKAGE
      // Sources w/ SwiftPM
      return Bundle.module
    #else
      // Get the module name
      let module = String(#fileID.prefix { $0 != "/" })
      // Validates that a bundle matches the module
      let isValid: (Bundle) -> Bool = {
        ["com.braze.\(module)", "org.cocoapods.\(module)"]
          .contains($0.bundleIdentifier)
      }

      var bundle: Bundle?

      // Dymamic XCFramework w/ (SwiftPM | CocoaPods | Manual)
      bundle = Bundle(for: BundleFinder.self)
      if let bundle, isValid(bundle) { return bundle }

      // Static XCFramework w/ (SwiftPM | Manual)
      bundle = {
        let frameworksURL = Bundle.main.privateFrameworksURL
        let frameworkURL = frameworksURL?.appendingPathComponent("\(module).framework")
        return frameworkURL.flatMap(Bundle.init(url:))
      }()
      if let bundle, isValid(bundle) { return bundle }

      // (Sources | Static XCFramework) w/ CocoaPods
      bundle = {
        let resourceURL = Bundle(for: BundleFinder.self).resourceURL
        let bundleURL = resourceURL?.appendingPathComponent("\(module).bundle")
        return bundleURL.flatMap(Bundle.init(url:))
      }()
      if let bundle, isValid(bundle) { return bundle }

      print(
        "[braze] Error: Unable to find UI resources bundle, cannot load localizations and acknowledgments"
      )
      return nil
    #endif
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
