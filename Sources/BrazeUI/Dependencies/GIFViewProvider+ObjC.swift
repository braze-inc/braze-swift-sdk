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
@objc(BRZGIFViewProvider)
public final class _OBJC_BRZGIFViewProvider: NSObject {

  /// The GIF view provider used for all BrazeUI components.
  ///
  /// By default, Braze displays animated GIFs as static images.
  /// See ``GIFViewProvider-swift.struct`` for details about how to add support for animated GIFs.
  @objc
  public static var shared: _OBJC_BRZGIFViewProvider {
    get { .init(GIFViewProvider.shared) }
    set { GIFViewProvider.shared = newValue.gifViewProvider }
  }

  /// Creates a view able to display static and animated GIF images.
  /// - Parameters:
  ///   - url: The local file url for the image.
  @objc
  public var view: (_ url: URL?) -> UIView {
    get { gifViewProvider.view }
    set { gifViewProvider.view = newValue }
  }

  /// Updates the passed view with a new image at `url`.
  /// - Parameters:
  ///   - view: The view to update.
  ///   - url: The local file url for the image.
  @objc
  public var updateView: (_ view: UIView, _ url: URL?) -> Void {
    get { gifViewProvider.updateView }
    set { gifViewProvider.updateView = newValue }
  }

  var gifViewProvider: GIFViewProvider

  /// Creates a GIF view provider.
  /// - Parameters:
  ///   - view: See ``view``.
  ///   - updateView: See ``updateView``.
  @objc
  public convenience init(
    view: @escaping (_ url: URL?) -> UIView,
    updateView: @escaping (_ view: UIView, _ url: URL?) -> Void
  ) {
    self.init(.init(view: view, updateView: updateView))
  }

  init(_ gifViewProvider: GIFViewProvider) {
    self.gifViewProvider = gifViewProvider
  }

  /// Creates a GIF view provider.
  /// - Parameters:
  ///   - view: See ``view``.
  ///   - updateView: See ``updateView``.
  @objc
  public static func provider(
    view: @escaping (_ url: URL?) -> UIView,
    updateView: @escaping (_ view: UIView, _ url: URL?) -> Void
  ) -> _OBJC_BRZGIFViewProvider {
    .init(view: view, updateView: updateView)
  }

  /// The default, non-animating provider.
  ///
  /// This provider does not support animated images and display them as static images.
  @objc
  public static let nonAnimating = _OBJC_BRZGIFViewProvider(.nonAnimating)

}
