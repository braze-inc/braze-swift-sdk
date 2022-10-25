import BrazeKit
import UIKit

extension BrazeInAppMessageUI.StackView {

  /// Creates and returns an in-app message buttons container stack view.
  ///
  /// Buttons in the stack view are laid out as follows:
  /// - One button: The intrinsic size of the button is respected.
  /// - Two or more buttons: Buttons are laid out horizontally and occupy all the available width.
  ///
  /// - Parameters:
  ///   - buttons: An array of in-app message buttons.
  ///   - context: An optional context, used to log and process button clicks.
  public convenience init?(
    buttons: [Braze.InAppMessage.Button],
    attributes: BrazeInAppMessageUI.ButtonView.Attributes = .defaults,
    onClick: @escaping (Braze.InAppMessage.Button) -> Void
  ) {
    if buttons.isEmpty { return nil }

    let subviews: [UIView] =
      buttons
      .map { data in
        let button = BrazeInAppMessageUI.ButtonView(button: data)
        button.addAction { onClick(data) }
        return button
      }

    self.init(
      arrangedSubviews: subviews.count == 1
        ? subviews.map { $0.boundedByIntrinsicContentSize(centerY: false) }
        : subviews
    )

    stack.distribution = .fillEqually
    stack.alignment = .center
    stack.axis = .horizontal
    stack.spacing = 10
  }

}

#if UI_PREVIEWS
  import SwiftUI

  struct StackViewButtons_Previews: PreviewProvider {
    typealias StackView = BrazeInAppMessageUI.StackView

    static var previews: some View {
      StackView(
        buttons: [.mockPrimary],
        onClick: { _ in }
      )!
      .preview()
      .frame(maxHeight: 70)
      .previewDisplayName("Var. | 1 Button")

      StackView(
        buttons: [.mockSecondary, .mockPrimary],
        onClick: { _ in }
      )!
      .preview()
      .frame(maxHeight: 70)
      .previewDisplayName("Var. | 2 Button")
    }

  }

#endif
