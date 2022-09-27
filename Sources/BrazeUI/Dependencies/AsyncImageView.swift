import BrazeKit
import UIKit

/// An image view able to represent multiple state of an asynchronous image loading operation.
open class AsyncImageView: UIView {

  /// The image loading operation states
  public enum ImageLoad {
    case loading(Braze.Cancellable)
    case failed(Error)
    case success(URL, CGSize)
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    // ImageView
    addSubview(imageView)
    imageView.anchors.edges.pin()

    // Activity indicator
    addSubview(activityIndicator)
    activityIndicator.anchors.center.align()

    // Retry button
    addSubview(retryButton)
    retryButton.anchors.center.align()

    // Aspect ratio
    aspectRatioConstraint = imageView.anchors.size.height.equal(
      anchors.width * (1 / effectiveAspectRatio))
  }

  /// Does not support interface-builder / storyboards.
  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Layout

  open override func layoutSubviews() {
    super.layoutSubviews()
    updateImageCornerRadius()
  }

  // MARK: - Aspect Ratio

  public var fixedAspectRatio: Double? {
    didSet { updateAspectRatio() }
  }

  public var aspectRatio: Double = 1.0 {
    didSet {
      guard aspectRatio != oldValue, fixedAspectRatio == nil else { return }
      updateAspectRatio()
    }
  }

  private var effectiveAspectRatio: Double {
    fixedAspectRatio ?? aspectRatio
  }

  private var aspectRatioConstraint: NSLayoutConstraint!

  open func updateAspectRatio() {
    aspectRatioConstraint.isActive = false
    aspectRatioConstraint = imageView.anchors.height.equal(
      anchors.width * (1.0 / effectiveAspectRatio))
    aspectRatioConstraint.isActive = true
  }

  // MARK: - Image

  public var imageLoad: ImageLoad? {
    didSet { updateImage() }
  }

  public let imageView: UIView = {
    let view = GIFViewProvider.shared.view(nil)
    view.contentMode = .scaleAspectFit
    return view
  }()

  public let activityIndicator: UIActivityIndicatorView = {
    let indicator: UIActivityIndicatorView
    if #available(iOS 13.0, *) {
      indicator = UIActivityIndicatorView(style: .large)
    } else {
      indicator = UIActivityIndicatorView()
    }
    indicator.hidesWhenStopped = true
    return indicator
  }()

  private func updateImage() {
    // Reset
    activityIndicator.stopAnimating()
    GIFViewProvider.shared.updateView(imageView, nil)
    retryButton.isHidden = true

    switch imageLoad {
    case .none:
      break
    case .loading:
      activityIndicator.startAnimating()
    case .failed:
      retryButton.isHidden = retry == nil
    case .success(let url, let size):
      aspectRatio = size.width / size.height
      GIFViewProvider.shared.updateView(imageView, url)
      updateImageCornerRadius()
    }
  }

  // MARK: - Corner Radius

  public var imageCornerRadius: Double? {
    didSet { updateImageCornerRadius() }
  }

  func updateImageCornerRadius() {
    guard let cornerRadius = imageCornerRadius else {
      layer.mask = nil
      return
    }
    let width = bounds.width
    let height = bounds.height

    let rect: CGRect
    if aspectRatio < 1 {
      let maskWidth = height * aspectRatio
      let maskX = (width - maskWidth) / 2
      rect = CGRect(x: maskX, y: 0, width: maskWidth, height: height)
    } else {
      let maskHeight = width / aspectRatio
      let maskY = (height - maskHeight) / 2
      rect = CGRect(x: 0, y: maskY, width: width, height: maskHeight)
    }

    let mask = layer.mask as? CAShapeLayer ?? CAShapeLayer()
    mask.path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
    layer.mask = mask
  }

  // MARK: - Retry / Error

  public var retry: (() -> Void)?
  public lazy var retryButton: UIButton = {
    let image = UIImage(
      named: "ContentCard/retry",
      in: resourcesBundle,
      compatibleWith: traitCollection
    )?
    .withRenderingMode(.alwaysTemplate)
    .imageFlippedForRightToLeftLayoutDirection()

    let button = UIButton()
    button.setImage(image, for: .normal)
    button.addAction { [weak self] in self?.retry?() }

    return button
  }()

}
