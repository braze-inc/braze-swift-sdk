import BrazeKit
import Foundation
import UIKit

/// The Braze provided in-app message presenter UI.
///
/// Assign an instance of this class to `braze.inAppMessagePresenter` to enable the presentation of
/// in-app messages to the user.
///
/// To add GIF support to the in-app message UI components, set a valid
/// ``gifViewProvider-swift.var``.
@objc(BrazeInAppMessageUI)
open class BrazeInAppMessageUI:
  NSObject,
  BrazeInAppMessagePresenter,
  _OBJC_BrazeInAppMessagePresenter
{

  // MARK: - Properties

  /// The currently visible message view.
  public var messageView: InAppMessageView? {
    window?.messageViewController?.messageView
  }

  /// The stack of in-app messages awaiting display.
  ///
  /// When the conditions to display a message are not met at trigger time, the message is pushed
  /// onto the stack (which is the end of this array).
  ///
  /// If an in-app message is already in the stack and fails to display again, it is moved to the top
  /// of the stack.
  public internal(set) var stack: [Braze.InAppMessage] = []

  /// The object that act as the delegate for the in-app message UI.
  ///
  /// The delegate is not retained and must conform to ``BrazeInAppMessageUIDelegate``.
  public weak var delegate: BrazeInAppMessageUIDelegate?

  /// Headless support (default: `false`).
  ///
  /// When enabled, in-app messages will be presented even when the app has no UIApplication (e.g.
  /// unit-test target without host app)
  var headless: Bool = false

  /// The keyboard frame notifier.
  var keyboard = KeyboardFrameNotifier()

  /// The timer for dismissing the message view.
  var dismissTimer: Timer?

  /// The window displaying the current in-app message view.
  var window: Window?

  /// Flag specifying whether the current in-app message is processing a click action.
  var isProcessingClickAction: Bool = false

  /// The followup message to display directly after the current one was dismissed.
  ///
  /// This property helps handling Braze Actions that triggers a new in-app message. The in-app
  /// message UI only allows one message being displayed at a time.
  ///
  /// When an in-app message is clicked, we set ``isProcessingClickAction`` to true which allows
  /// any triggered in-app message to be stored as the `followupMessage`. Once the current message
  /// is dismissed, we directly display the `followupMessage`.
  var followupMessage: Braze.InAppMessage? {
    get { _followupMessage as? Braze.InAppMessage }
    set { _followupMessage = newValue }
  }

  /// This property acts as a store for ``followupMessage``. Storing the typed `Braze.InAppMessage?`
  /// directly on the `BrazeInAppMessageUI` class leads to that class not being available in ObjC.
  ///
  /// This seems to be a compiler bug as no warning or error are printed during the compilation
  /// process.
  /// Hypothesis: storing imported Swift-only value types on an ObjC compatible class breaks ObjC
  /// compatibility. Storing the same value type as an `Any` changes the memory layout by adding
  /// a layer of indirection. Instead of allocating the space necessary for storing the value type
  /// on the class itself, the compiler use a "pointer" to somewhere in the heap.
  private var _followupMessage: Any?

  /// The cancellable for the remote URLs → local URLs message transformation.
  var localAssetsCancellable: Braze.Cancellable?

  // MARK: - Presentation / BrazeInAppMessagePresenter conformance

  open func present(message: Braze.InAppMessage) {
    guard validateMainThread(for: message),
      validateHeadless(for: message, allowHeadless: headless),
      validateFontAwesome(for: message),
      validateNoMessagePresented(
        for: message,
        pendingDestination: isProcessingClickAction ? .followup : .stack
      )
    else {
      return
    }

    let displayChoice =
      delegate?.inAppMessage(self, displayChoiceForMessage: message)
      ?? .now

    switch displayChoice {
    case .now:
      prepareAndPresent(message: message)
    case .later:
      stack.append(message)
    case .discard:
      message.context?.discard()
    }
  }

  @objc
  open func present(message: Braze.InAppMessageRaw) {
    do {
      let message = try Braze.InAppMessage(message)
      present(message: message)
    } catch {
      logError(for: message.context, error: .rawToTypedConversion(.init(error)))
    }
  }

  /// Presents the next in-app message in the stack if any.
  @objc
  public func presentNext() {
    // We use `last` instead of `popLast()` to avoid potentially modifying `stack` from a non
    // main thread. The message is removed from the stack in `prepareAndPresent`.
    guard let next = stack.last else {
      return
    }
    prepareAndPresent(message: next)
  }

  func prepareAndPresent(message: Braze.InAppMessage) {
    guard validateMainThread(for: message),
      validateHeadless(for: message, allowHeadless: headless),
      validateFontAwesome(for: message),
      validateNoMessagePresented(for: message, pendingDestination: nil),
      validateOrientation(for: message),
      validateContext(for: message)
    else {
      return
    }

    // Remove the message from the stack if needed
    stack.removeAll { $0 == message }

    // Transform remote asset URLs to local asset URLs
    // - IAMs not originating from Braze (`context == nil`) cannot go through this transformation
    //   and are expected to use local asset URLs for proper display
    guard let context = message.context else {
      self.presentNow(message: message)
      return
    }

    do {
      // Setup the assets working directory
      let assetsDirectory = try resetAssetsDirectory()

      // Load the assets and modify the `message` to reference the local assets in `assetsDirectory`
      // - Presentation is resumed in the completion closure with the updated `message`
      localAssetsCancellable = context.withLocalAssets(
        message: message,
        destinationURL: assetsDirectory
      ) { [weak self] result in
        switch result {
        case .success(let message):
          self?.presentNow(message: message)
        case .failure(let error):
          self?.logError(for: context, error: .assetsFailure(.init(error)))
        }
      }
    } catch {
      logError(for: context, error: .assetsFailure(.init(error)))
    }
  }

  func presentNow(message: Braze.InAppMessage) {
    // Prepare / user customizations
    var context = PresentationContext(
      message: message,
      attributes: .defaults(for: message),
      customView: nil,
      preferredOrientation: Braze.UIUtils.interfaceOrientation,
      statusBarHideBehavior: .auto,
      windowLevel: .normal,
      preferencesProxy: Braze.UIUtils.activeTopmostViewController
    )
    if #available(iOS 13.0, tvOS 13.0, *) {
      context.windowScene = Braze.UIUtils.activeWindowScene
    }
    delegate?.inAppMessage(self, prepareWith: &context)

    // Creates view hierarchy
    // - Message View
    let optMessageView =
      context.customView
      ?? createMessageView(
        for: context.message,
        attributes: context.attributes,
        gifViewProvider: GIFViewProvider.shared
      )
    guard let messageView = optMessageView else {
      _ = try? resetAssetsDirectory()
      message.context?.logError(flattened: Error.noMessageView.logDescription)
      return
    }

    // - View controller
    let viewController = ViewController(
      ui: self,
      context: context,
      messageView: messageView,
      keyboard: keyboard
    )

    // - Window
    let window: Window
    if #available(iOS 13.0, tvOS 13.0, *), let windowScene = context.windowScene {
      window = Window(windowScene: windowScene)
    } else {
      window = Window(frame: UIScreen.main.bounds)
    }
    window.accessibilityViewIsModal = true
    window.windowLevel = context.windowLevel
    window.rootViewController = viewController
    self.window = window

    // Dismiss Timer
    if case .auto(let interval) = message.messageClose {
      dismissTimer?.invalidate()
      dismissTimer = .scheduledTimer(
        withTimeInterval: interval,
        repeats: false
      ) { [weak self] _ in self?.dismiss() }
    }

    // Display
    if #available(iOS 15.0, *) {
      // - Use animation block to animate the status bar hidden state
      UIView.animate(withDuration: message.animateIn ? 0.25 : 0) {
        // - Use `isHidden` instead of `makeKeyAndVisible` to defer the choice of hiding the keyboard
        //   to the message view. See `InAppMessageView/makeKey`. `isHidden` just displays the window
        //   without touching the first responder.
        window.isHidden = false
      }
    } else {
      // - No animation block before iOS 15.0, it has undesired side effects
      window.isHidden = false
    }

  }

  func presentFollowup() {
    guard let followupMessage else { return }
    self.followupMessage = nil
    present(message: followupMessage)
  }

  /// Dismisses the current in-app message view.
  /// - Parameter completion: Executed once the in-app message view has been dismissed or directly
  ///                         when no in-app message view is currently presented.
  @objc
  public func dismiss(completion: (() -> Void)? = nil) {
    messageView?.dismiss(completion: completion) ?? completion?()
  }

  // MARK: - Utils

  enum PendingDestination {
    case stack
    case followup
  }

  func logError(for context: Braze.InAppMessage.Context?, error: Error) {
    context?.logError(flattened: error.logDescription) ?? print(error.logDescription)
  }

  func validateMainThread(for message: Braze.InAppMessage) -> Bool {
    guard Thread.isMainThread else {
      DispatchQueue.main.sync {
        logError(for: message.context, error: .noMainThread)
      }
      return false
    }
    return true
  }

  func validateHeadless(for message: Braze.InAppMessage, allowHeadless: Bool = false)
    -> Bool
  {
    if allowHeadless {
      return true
    }

    if Braze.UIUtils.activeRootViewController == nil {
      logError(for: message.context, error: .noAppRootViewController)
      return false
    }

    return true
  }

  func validateNoMessagePresented(
    for message: Braze.InAppMessage,
    pendingDestination destination: PendingDestination?
  )
    -> Bool
  {
    guard messageView == nil else {
      switch destination {
      case .none:
        logError(for: message.context, error: .otherMessagePresented(push: false))
      case .stack:
        // Remove message from stack (if present) and place on top
        stack.removeAll { $0.data.id == message.data.id }
        stack.append(message)
        logError(for: message.context, error: .otherMessagePresented(push: true))
      case .followup:
        if let followupMessage { stack.append(followupMessage) }
        self.followupMessage = message
      }

      return false
    }
    return true
  }

  // Always return true, font-awesome missing is not a breaking error
  func validateFontAwesome(for message: Braze.InAppMessage) -> Bool {
    guard IconView.registerFontAwesomeIfNeeded() else {
      logError(for: message.context, error: .noFontAwesome)
      return true
    }
    return true
  }

  func validateOrientation(for message: Braze.InAppMessage) -> Bool {
    let traits = Braze.UIUtils.activeTopmostViewController?.traitCollection
    guard message.orientation.supported(by: traits) else {
      stack.removeAll { $0 == message }
      logError(for: message.context, error: .noMatchingOrientation)
      return false
    }
    return true
  }

  func validateContext(for message: Braze.InAppMessage) -> Bool {
    guard let context = message.context else {
      // No context -> not a Braze in-app message.
      return true
    }

    guard context.valid else {
      stack.removeAll { $0 == message }
      logError(for: message.context, error: .messageContextInvalid)
      return false
    }

    return true
  }

  // MARK: - Assets

  /// Directory where all in-app message assets are stored.
  static func assetsDirectory() throws -> URL {
    try FileManager.default.url(
      for: .cachesDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false
    )
    .appendingPathComponent("com.braze.inappmessageui", isDirectory: true)
  }

  @discardableResult
  func resetAssetsDirectory() throws -> URL {
    let fileManager = FileManager.default
    let assetsDirectory = try Self.assetsDirectory()

    if fileManager.fileExists(atPath: assetsDirectory.path) {
      try fileManager.removeItem(at: assetsDirectory)
    }
    try fileManager.createDirectory(at: assetsDirectory, withIntermediateDirectories: true)

    return assetsDirectory
  }

  // MARK: - Compat

  /// Provided for compatibility purposes.
  @objc(_compat_tryPushOnStack:)
  @available(swift, obsoleted: 0.0.1)
  public func _compat_tryPushOnStack(message: Braze.InAppMessageRaw) {
    guard let message = try? Braze.InAppMessage(message) else { return }
    stack.append(message)
  }

}
