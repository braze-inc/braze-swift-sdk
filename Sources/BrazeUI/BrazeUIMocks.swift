import Foundation
import UIKit

#if DEBUG

  extension URL {

    /// Creates a mock png image, store it on disk and returns the file url.
    /// - Parameters:
    ///   - width: The pixel width of the image.
    ///   - height: The pixel height of the image
    ///   - textSize: The size of the text at the center of the image, set to `nil` to automatically
    ///               infer the size from the image width and height.
    ///   - textColor: The text color.
    ///   - backgroundColor: The background color.
    /// - Returns: An url for a mock image.
    public static func mockImage(
      width: CGFloat,
      height: CGFloat,
      textSize: CGFloat? = nil,
      textColor: UIColor = .white,
      backgroundColor: UIColor = .systemBlue
    ) -> URL {
      let frame = CGRect(x: 0, y: 0, width: width, height: height)
      let textSize = textSize ?? min(floor(height / 6), floor(width / 12))
      let lineWidth = max(width / 50, 8)
      let cornerLength = width / 20

      // Draw image to png data
      let format = UIGraphicsImageRendererFormat.default()
      format.scale = 1
      let data = UIGraphicsImageRenderer(size: frame.size, format: format).pngData { ctx in
        backgroundColor.set()
        ctx.fill(frame)

        // Corners
        func drawCorner(at pos: CGPoint) {
          ctx.cgContext.setStrokeColor(UIColor.black.withAlphaComponent(0.3).cgColor)
          ctx.cgContext.setLineWidth(lineWidth)
          var pos = pos
          pos.x -= cornerLength
          ctx.cgContext.move(to: pos)
          pos.x += 2 * cornerLength
          ctx.cgContext.addLine(to: pos)
          pos.x -= cornerLength
          pos.y -= cornerLength
          ctx.cgContext.move(to: pos)
          pos.y += 2 * cornerLength
          ctx.cgContext.addLine(to: pos)
          ctx.cgContext.drawPath(using: .fillStroke)
        }
        drawCorner(at: .init(x: frame.minX, y: frame.minY))
        drawCorner(at: .init(x: frame.minX, y: frame.maxY))
        drawCorner(at: .init(x: frame.maxX, y: frame.minY))
        drawCorner(at: .init(x: frame.maxX, y: frame.maxY))

        // Draw text
        let font: UIFont
        if #available(iOS 13.0, *) {
          font = UIFont.monospacedSystemFont(ofSize: textSize, weight: .regular)
        } else {
          font = UIFont(name: "Courier", size: textSize)!
        }
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.minimumLineHeight = frame.height / 2 + textSize / 2
        let text = NSAttributedString(
          string: "\(Int(width))x\(Int(height))",
          attributes: [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: style,
          ]
        )
        text.draw(in: frame)
      }

      // Write to temporary cache
      let cacheUrl = try! FileManager.default.url(
        for: .cachesDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: false
      )
      let imageUrl = cacheUrl.appendingPathComponent("\(Int(width))x\(Int(height)).png")
      try! data.write(to: imageUrl)

      return imageUrl
    }

  }

#endif
