import Foundation
import UIKit

#if os(iOS) || os(macOS) || os(visionOS)
  import WebKit
#endif

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
    static func mockImage(
      width: CGFloat,
      height: CGFloat,
      text: String? = nil,
      textSize: CGFloat? = nil,
      textColor: UIColor = .white,
      backgroundColor: UIColor = .systemBlue,
      drawCorners: Bool = true
    ) -> URL {
      let frame = CGRect(x: 0, y: 0, width: width, height: height)
      let textSize = textSize ?? min(floor(height / 6), floor(width / 12))
      let lineWidth = max(width / 50, 8)
      let cornerLength = width / 20
      let text = text ?? "\(Int(width))x\(Int(height))"

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
        if drawCorners {
          drawCorner(at: .init(x: frame.minX, y: frame.minY))
          drawCorner(at: .init(x: frame.minX, y: frame.maxY))
          drawCorner(at: .init(x: frame.maxX, y: frame.minY))
          drawCorner(at: .init(x: frame.maxX, y: frame.maxY))
        }

        // Draw text
        let font: UIFont
        if #available(iOS 13.0, tvOS 13.0, *) {
          font = UIFont.monospacedSystemFont(ofSize: textSize, weight: .regular)
        } else {
          font = UIFont(name: "Courier", size: textSize)!
        }
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.minimumLineHeight = frame.height / 2 + textSize / 2
        let attributedText = NSAttributedString(
          string: text,
          attributes: [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: style,
          ]
        )
        attributedText.draw(in: frame)
      }

      // Write to temporary cache
      let cacheURL = try! FileManager.default.url(
        for: .cachesDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: false
      )
      let imageURL = cacheURL.appendingPathComponent("\(text)-\(Int(width))x\(Int(height)).png")
      try! data.write(to: imageURL)

      return imageURL
    }

  }

  #if !os(tvOS)
    class MockCustomInAppMessageView: UIView, InAppMessageView {
      var presented: Bool = true

      func present(completion: (() -> Void)?) {}

      func dismiss(completion: (() -> Void)?) {}
    }
  #endif

  #if os(iOS) || os(macOS) || os(visionOS)

    // MARK: - WebKit Mocks

    /// Holds permanent strong references to mock WebKit objects for the lifetime of the test process.
    ///
    /// Mocks like ``MockFrameInfo`` and ``MockNavigationAction`` subclass WebKit types but never run a
    /// real WebKit initializer, so their internal WebKit state is left uninitialized. `-[WKFrameInfo dealloc]` (and related destructors) unconditionally release that internal state, which crashes in `CFRelease`.
    /// Retaining the mocks here prevents them from being deallocated during the test run,
    /// so the crashing destructor never executes.
    private enum MockWebKitObjectRetainer {
      private static let lock = NSLock()
      nonisolated(unsafe) private static var objects: [AnyObject] = []

      static func retain(_ object: AnyObject) {
        lock.lock()
        defer { lock.unlock() }
        objects.append(object)
      }
    }

    final class MockNavigationDelegate: NSObject, WKNavigationDelegate {}

    final class MockNavigationAction: WKNavigationAction {
      override var request: URLRequest { _request }
      private let _request: URLRequest

      override var sourceFrame: WKFrameInfo { _sourceFrame }
      private let _sourceFrame: WKFrameInfo

      override var targetFrame: WKFrameInfo? { _targetFrame }
      private let _targetFrame: WKFrameInfo?

      override var navigationType: WKNavigationType { _navigationType }
      private let _navigationType: WKNavigationType

      init(
        request: URLRequest,
        sourceFrame: WKFrameInfo = MockFrameInfo(isMainFrame: true),
        targetFrame: WKFrameInfo? = nil,
        navigationType: WKNavigationType = .linkActivated
      ) {
        self._request = request
        self._sourceFrame = sourceFrame
        self._targetFrame = targetFrame
        self._navigationType = navigationType
        super.init()
        MockWebKitObjectRetainer.retain(self)
      }
    }

    final class MockFrameInfo: WKFrameInfo {
      override var isMainFrame: Bool { _isMainFrame }
      private let _isMainFrame: Bool

      init(isMainFrame: Bool) {
        self._isMainFrame = isMainFrame
        super.init()
        MockWebKitObjectRetainer.retain(self)
      }
    }

  #endif

#endif
