import BrazeKit
import BrazeUI
import UIKit

class FullWidthSlideupView: BrazeInAppMessageUI.SlideupView {

  static let defaultAttributes: Attributes = {
    var attributes = Attributes.defaults
    attributes.maxWidth = 720
    attributes.padding = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    return attributes
  }()

  let backgroundView = ShadowView(.inAppMessage)

  init(
    message: Braze.InAppMessage.Slideup,
    attributes: Attributes = FullWidthSlideupView.defaultAttributes
  ) {
    super.init(
      message: message,
      attributes: attributes
    )

    // Hide the original shadow view
    shadowView.isHidden = true

    // Setup the full-width background view
    insertSubview(backgroundView, belowSubview: shadowView)

    // - Auto-layout
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    let verticalConstraint: NSLayoutConstraint
    switch message.slideFrom {
    case .top:
      verticalConstraint = backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
    case .bottom:
      verticalConstraint = backgroundView.topAnchor.constraint(equalTo: topAnchor)
    @unknown default:
      verticalConstraint = backgroundView.topAnchor.constraint(equalTo: topAnchor)
    }
    NSLayoutConstraint.activate([
      verticalConstraint,
      backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
      backgroundView.heightAnchor.constraint(equalToConstant: 1000),
    ])

    // Move gesture recognizer to background view
    contentView.isUserInteractionEnabled = false
    contentView.removeGestureRecognizer(pressGesture)
    contentView.removeGestureRecognizer(panGesture)
    backgroundView.addGestureRecognizer(pressGesture)
    backgroundView.addGestureRecognizer(panGesture)

    // Update hover style
    if #available(iOS 17.0, *) {
      contentView.hoverStyle = nil
      backgroundView.hoverStyle = UIHoverStyle(shape: .rect(cornerRadius: attributes.cornerRadius))
    }

    applyTheme()
    applyAttributes()
  }

  open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    backgroundView.point(inside: convert(point, to: backgroundView), with: event)
  }

  override func applyAttributes() {
    super.applyAttributes()
    backgroundView.shadow = attributes.shadow
    backgroundView.layer.cornerRadius = attributes.cornerRadius
    if #available(iOS 13.0, *) {
      backgroundView.layer.cornerCurve = attributes.cornerCurve
    }
    if #available(iOS 17.0, *) {
      backgroundView.hoverStyle?.shape = .rect(cornerRadius: attributes.cornerRadius)
    }
    contentView.backgroundColor = .clear
  }

  override func applyTheme() {
    super.applyTheme()
    let theme = message.theme(for: traitCollection)
    backgroundView.backgroundColor = theme.backgroundColor.uiColor
  }

}
