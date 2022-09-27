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
public struct GIFViewProvider {

  /// The GIF view provider used for all BrazeUI components.
  ///
  /// By default, Braze displays animated GIFs as static images.
  /// See ``GIFViewProvider-swift.struct`` for details about how to add support for animated GIFs.
  public static var shared: GIFViewProvider = .nonAnimating

  /// Creates a view able to display static and animated GIF images.
  /// - Parameters:
  ///   - url: The local file url for the image.
  public var view: (_ url: URL?) -> UIView

  /// Updates the passed view with a new image at `url`.
  /// - Parameters:
  ///   - view: The view to update.
  ///   - url: The local file url for the image.
  public var updateView: (_ view: UIView, _ url: URL?) -> Void

  /// Creates a GIF view provider.
  /// - Parameters:
  ///   - view: See ``view``.
  ///   - updateView: See ``updateView``.
  public init(
    view: @escaping (URL?) -> UIView,
    updateView: @escaping (UIView, URL?) -> Void
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
