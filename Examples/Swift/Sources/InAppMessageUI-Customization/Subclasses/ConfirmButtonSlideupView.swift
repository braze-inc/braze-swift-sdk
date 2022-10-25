import BrazeKit
import BrazeUI
import UIKit

class ConfirmButtonSlideupView: BrazeInAppMessageUI.SlideupView {

  static let defaultAttributes: Attributes = {
    var attributes = Attributes.defaults
    attributes.chevronVisibility = .hidden
    attributes.dismissible = false
    return attributes
  }()

  lazy var confirmButton: UIButton = {
    let button = UIButton(type: .custom)
    let size = CGSize(width: 40, height: 40)
    let image = UIGraphicsImageRenderer(size: size).image { context in
      UIColor.systemGray.setFill()
      context.fill(CGRect(origin: .zero, size: size))
    }
    let selectedImage = UIGraphicsImageRenderer(size: size).image { context in
      UIColor.systemGreen.setFill()
      context.fill(CGRect(origin: .zero, size: size))
    }
    button.layer.cornerRadius = 20
    button.layer.masksToBounds = true
    button.setBackgroundImage(image, for: .normal)
    button.setBackgroundImage(selectedImage, for: .selected)
    button.setTitle("✓", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
    button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    NSLayoutConstraint.activate([
      button.widthAnchor.constraint(equalToConstant: 40),
      button.heightAnchor.constraint(equalToConstant: 40),
    ])
    return button
  }()

  init(
    message: Braze.InAppMessage.Slideup,
    attributes: Attributes = ConfirmButtonSlideupView.defaultAttributes
  ) {
    super.init(
      message: message,
      attributes: attributes
    )

    // Disable default press gesture
    pressGesture.isEnabled = false

    // Add confirm button
    contentView.stack.addArrangedSubview(confirmButton)
  }

  @objc
  func confirmButtonTapped() {
    confirmButton.isUserInteractionEnabled = false
    UIView.transition(with: confirmButton, duration: 0.2, options: .transitionCrossDissolve) {
      self.confirmButton.isSelected = true
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.logClick()
      self.process(clickAction: self.message.clickAction)
      self.dismiss()
    }
  }

}
