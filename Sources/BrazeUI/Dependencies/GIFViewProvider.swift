import UIKit

/// A type providing methods to create and update views supporting animated GIF images.
///
/// Braze does not provide animated GIF support out of the box. Support can be added by wrapping a
/// third party or your own view in an instance of `GIFViewProvider`.
///
/// Sample implementations for popular third party libraries are provided in
/// <doc:gif-support-integrations>.
///
/// Adding any of those libraries to your project allows you to enable animated GIF support in
/// Braze's UI components.
/// For instance, a project including SDWebImage and using the compatible sample code can do:
/// ```swift
/// GIFViewProvider.shared = .sdWebImage
/// ```
public struct GIFViewProvider: Sendable {

  /// The lock guarding the static properties.
  private static let lock = NSRecursiveLock()

  /// The GIF view provider used for all BrazeUI components.
  ///
  /// By default, Braze displays animated GIFs as static images.
  /// See ``GIFViewProvider-swift.struct`` for details about how to add support for animated GIFs.
  public static var shared: GIFViewProvider {
    get { lock.sync { _shared } }
    set { lock.sync { _shared = newValue } }
  }
  #if compiler(>=5.10)
    nonisolated(unsafe) private static var _shared: GIFViewProvider = .nonAnimating
  #else
    private static var _shared: GIFViewProvider = .nonAnimating
  #endif

  /// Creates a view able to display static and animated GIF images.
  /// - Parameters:
  ///   - url: The local file url for the image.
  public var view: @MainActor @Sendable (_ url: URL?) -> UIView

  /// Updates the passed view with a new image at `url`.
  /// - Parameters:
  ///   - view: The view to update.
  ///   - url: The local file url for the image.
  public var updateView: @MainActor @Sendable (_ view: UIView, _ url: URL?) -> Void

  /// Creates a GIF view provider.
  /// - Parameters:
  ///   - view: See ``view``.
  ///   - updateView: See ``updateView``.
  public init(
    view: @MainActor @Sendable @escaping (URL?) -> UIView,
    updateView: @MainActor @Sendable @escaping (UIView, URL?) -> Void
  ) {
    self.view = view
    self.updateView = updateView
  }

  /// The default, non-animating provider.
  ///
  /// This provider does not support animated images and display them as static images.
  public static let nonAnimating = GIFViewProvider(
    view: { UIImageView(image: ($0?.path).flatMap(UIImage.init(contentsOfFile:))) },
    updateView: { ($0 as? UIImageView)?.image = ($1?.path).flatMap(UIImage.init(contentsOfFile:)) }
  )

}
