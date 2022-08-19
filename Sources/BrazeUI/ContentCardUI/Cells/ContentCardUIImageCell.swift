import UIKit

extension BrazeContentCardUI {

  /// A Content Card cell subclass providing a pre-configured image view.
  open class ImageCell: Cell {

    /// The image view used to display the content card image.
    open var contentImageView: AsyncImageView = {
      let imageView = AsyncImageView()
      imageView.backgroundColor = .brazeCellImageBackgroundColor
      imageView.tintColor = .brazeRetryButtonColor
      return imageView
    }()

  }

}
