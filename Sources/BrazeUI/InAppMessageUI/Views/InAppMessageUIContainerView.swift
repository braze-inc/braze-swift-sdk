import UIKit

extension BrazeInAppMessageUI {

  /// The in-app message container view.
  ///
  /// This view is keyboard aware and updates its frame to take all available space. When the
  /// keyboard is hidden, the view edges extends past the safe area.
  open class ContainerView: UIView {

    // MARK: - LifeCycle

    /// Creates and returns a container view initialized with a keyboard frame notifier.
    /// - Parameter keyboard: The keyboard frame notifier.
    public init(keyboard: KeyboardFrameNotifier? = nil) {
      self.keyboard = keyboard ?? .shared
      super.init(frame: .zero)
      self.keyboard.subscribe(identifier: ObjectIdentifier(self)) { [weak self] _ in
        self?.updateConstraintsForKeyboard()
      }
    }

    required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    deinit {
      isolatedMainActorDeinit { [id = ObjectIdentifier(self), keyboard] in
        keyboard.unsubscribe(identifier: id)
      }
    }

    // MARK: - Layout

    open var layoutConstraintsInstalled = false
    open var bottomConstraint: NSLayoutConstraint?

    open override func layoutSubviews() {
      super.layoutSubviews()
      installLayoutConstraintsIfNeeded()
    }

    open func installLayoutConstraintsIfNeeded() {
      if layoutConstraintsInstalled { return }
      layoutConstraintsInstalled = true

      anchors.edges.pin(axis: .horizontal)
      anchors.top.pin()
      bottomConstraint = anchors.bottom.pin()
      superview?.layoutIfNeeded()

      updateConstraintsForKeyboard()
    }

    // MARK: - Keyboard

    public let keyboard: KeyboardFrameNotifier

    open func updateConstraintsForKeyboard() {
      guard let window = window,
        keyboard.windows.contains(window),
        let superview = superview
      else {
        return
      }
      #if os(visionOS)
        let frameEnd =
          window.windowScene?.coordinateSpace.convert(keyboard.frame, to: superview)
          ?? .zero
      #else
        let frameEnd = window.screen.coordinateSpace.convert(keyboard.frame, to: superview)
      #endif
      let frame = superview.bounds.intersection(frameEnd)
      bottomConstraint?.constant = -frame.height

      UIView.animate(
        withDuration: 0.25,
        delay: 0,
        options: .beginFromCurrentState,
        animations: { self.superview?.layoutIfNeeded() },
        completion: nil
      )
    }

    // MARK: - Touch

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
      subviews.first?.point(inside: convert(point, to: subviews.first), with: event) ?? false
    }

  }

}
