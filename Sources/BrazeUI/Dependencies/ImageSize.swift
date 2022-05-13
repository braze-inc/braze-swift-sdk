import Foundation
import ImageIO

/// Returns the size of the image at the passed file url without fully loading the image in memory.
/// - Parameter url: The image file url.
/// - Returns: The size of the image if valid, `nil` otherwise.
func imageSize(url: URL) -> CGSize? {
  guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
    let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [AnyHashable: Any],
    let width = properties[kCGImagePropertyPixelWidth] as? Double,
    let height = properties[kCGImagePropertyPixelHeight] as? Double
  else {
    return nil
  }

  guard
    let orientationRawValue = properties[kCGImagePropertyOrientation] as? UInt32,
    let orientation = CGImagePropertyOrientation(rawValue: orientationRawValue)
  else {
    return CGSize(width: width, height: height)
  }

  let swapDimensions = [.left, .leftMirrored, .right, .rightMirrored].contains(orientation)
  return swapDimensions
    ? CGSize(width: height, height: width)
    : CGSize(width: width, height: height)
}
