import BrazeKit
import UIKit

extension BrazeInAppMessageUI {

  /// The view controller presenting the in-app message view in the ``Window``.
  ///
  /// This view controller is responsible for:
  /// - orientation handling
  /// - keyboard avoidance (via its view being a ``ContainerView``)
  /// - status bar hide behavior
  /// - preferences proxying
  open class ViewController: UIViewController {

    /// The message displayed by `messageView`.
    var message: Braze.InAppMessage

    /// The message view diplayed.
    var messageView: InAppMessageView

    /// The message view container view.
    var containerView: ContainerView

    /// The message view presented state.
    var presented: Bool = false

    /// The in-app message ui instance.
    ///
    /// Used by the in-app message view for delegate handling.
    weak var ui: BrazeInAppMessageUI?

    /// The preferences proxy.
    ///
    /// See ``BrazeInAppMessageUI/PresentationContext/preferencesProxy``.
    weak var preferencesProxy: UIViewController?

    /// The preferred orientation.
    ///
    /// The view controller will adopt the preferred orientation until the **device** orientation
    /// changes. At that point, the view controller will adopt any orientation matching
    /// `supportedOrientations`.
    var preferredOrientation: UIInterfaceOrientation

    /// The orientations supported by the message.
    var supportedOrientations: UIInterfaceOrientationMask

    /// The status bar hide behavior.
    ///
    /// See ``BrazeInAppMessageUI/PresentationContext/statusBarHideBehavior`.`
    var statusBarHideBehavior: StatusBarHideBehavior

    /// The message view preferred status bar hidden state.
    ///
    /// The message view can set this value via ``InAppMessageView/prefersStatusBarHidden`` to
    /// customize the status bar hidden state.
    var messageViewPrefersStatusBarHidden: Bool? {
      didSet { setNeedsStatusBarAppearanceUpdate() }
    }

    // MARK: - Initialization

    /// Creates an in-app message view controller.
    /// - Parameters:
    ///   - ui: The in-app message ui instance.
    ///   - context: The in-app message presentaiton context.
    ///   - messageView: The in-app message view.
    ///   - keyboard: The keybord frame notifier.
    init(
      ui: BrazeInAppMessageUI,
      context: PresentationContext,
      messageView: InAppMessageView,
      keyboard: KeyboardFrameNotifier = .shared
    ) {
      let traits = context.preferencesProxy?.traitCollection

      self.ui = ui
      message = context.message
      self.messageView = messageView
      preferencesProxy = context.preferencesProxy
      preferredOrientation = context.preferredOrientation
      supportedOrientations = context.message.orientation.mask(for: traits)
      statusBarHideBehavior = context.statusBarHideBehavior
      containerView = .init(keyboard: keyboard)

      super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    open override func loadView() {
      self.view = containerView
    }

    open override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      if presented { return }

      view.addSubview(messageView)
      messageView.present(completion: nil)
      presented = true
    }

    // MARK: - Orientation

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
      !isViewLoaded
        ? preferredOrientationMask
        : supportedOrientations
    }

    var preferredOrientationMask: UIInterfaceOrientationMask {
      switch preferredOrientation {
      case .unknown:
        return .all
      case .portrait:
        return .portrait
      case .portraitUpsideDown:
        return .portraitUpsideDown
      case .landscapeLeft:
        return .landscapeLeft
      case .landscapeRight:
        return .landscapeRight
      @unknown default:
        return .all
      }
    }

    open override func viewWillTransition(
      to size: CGSize,
      with coordinator: UIViewControllerTransitionCoordinator
    ) {
      super.viewWillTransition(to: size, with: coordinator)

      // Hide shadow view during modal / full rotation animation
      let modalShadowView =
        (self.messageView as? ModalView)?.shadowView
        ?? (self.messageView as? ModalImageView)?.shadowView
      // Apply attributes during animation so that modals / fulls can adapt to the size changes
      let modalApplyAttributes =
        (self.messageView as? ModalView)?.applyAttributes
        ?? (self.messageView as? ModalImageView)?.applyAttributes

      coordinator.animate(
        alongsideTransition: { context in
          modalShadowView?.isHidden = true
          modalApplyAttributes?()
        },
        completion: { context in
          modalShadowView?.isHidden = false
        }
      )
    }

    // MARK: - Preferences

    open override var prefersStatusBarHidden: Bool {
      switch statusBarHideBehavior {
      case .auto:
        return messageViewPrefersStatusBarHidden
          ?? preferencesProxy?.prefersStatusBarHidden
          ?? false
      case .hidden:
        return true
      case .visible:
        return false
      }
    }

    open override var childForStatusBarStyle: UIViewController? {
      preferencesProxy
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
      preferencesProxy?.preferredStatusBarStyle ?? .default
    }

    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
      preferencesProxy?.preferredStatusBarUpdateAnimation ?? .fade
    }

    @available(iOS 11.0, *)
    open override var prefersHomeIndicatorAutoHidden: Bool {
      preferencesProxy?.prefersHomeIndicatorAutoHidden ?? false
    }

    @available(iOS 11.0, *)
    open override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
      preferencesProxy?.preferredScreenEdgesDeferringSystemGestures ?? []
    }

    @available(iOS 14.0, *)
    open override var prefersPointerLocked: Bool {
      preferencesProxy?.prefersPointerLocked ?? false
    }

  }

}
