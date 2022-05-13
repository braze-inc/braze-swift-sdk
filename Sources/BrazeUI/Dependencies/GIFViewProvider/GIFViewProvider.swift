import UIKit

/// The gif view provider used for all BrazeUI components.
///
/// By default, Braze displays animated gifs as static images.
/// See ``GIFViewProvider-swift.struct`` for details about how to add support for animated gifs.
public var gifViewProvider: GIFViewProvider = .default

/// A type providing methods to create and update views supporting animated gif images.
///
/// Braze does not provide animated gif support out of the box. Support can be added by wrapping a
/// third party or your own view in an instance of `GIFViewProvider`.
///
/// Sample implementations for popular third party libraries are provided in
/// <doc:gif-support>.
///
/// Adding any of those libraries to your project allows you to enable animated gif support in
/// Braze's UI components.
/// For instance, a project including SDWebImage and using the compatible sample code can do:
/// ```swift
/// BrazeUI.gifViewProvider = .sdWebImage
/// ```
public struct GIFViewProvider {

  /// Creates a view able to display static and animated gif images.
  /// - Parameters:
  ///   - url: The local file url for the image.
  public var view: (_ url: URL?) -> UIView

  /// Updates the passed view with a new image at `url`.
  /// - Parameters:
  ///   - view: The view to update.
  ///   - url: The local file url for the image.
  public var updateView: (_ view: UIView, _ url: URL?) -> Void

  /// Creates a gif view provider.
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

  /// The default provider.
  ///
  /// This provider does not support animated images and display them as static images.
  public static let `default` = Self(
    view: { UIImageView(image: ($0?.path).flatMap(UIImage.init(contentsOfFile:))) },
    updateView: { ($0 as? UIImageView)?.image = ($1?.path).flatMap(UIImage.init(contentsOfFile:)) }
  )

}
