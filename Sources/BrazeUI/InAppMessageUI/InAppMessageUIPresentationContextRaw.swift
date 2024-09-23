import BrazeKit
import Foundation
import UIKit

extension BrazeInAppMessageUI {

  /// A compatibility representation of the presentation context for an in-app message.
  ///
  /// This representation is provided for compatibility with Objective-C and wrapper SDKs. When
  /// developing in Swift, prefer using the type-safe, always valid ``BrazeInAppMessageUI/PresentationContext`` instead.
  ///
  /// A writable instance of this type is passed to the ``BrazeInAppMessageUI/delegate`` via the
  /// ``BrazeInAppMessageUIDelegate/inAppMessage(_:prepareWith:)-11fog`` method.
  @objc(BrazeInAppMessageUIPresentationContextRaw)
  @MainActor
  public final class PresentationContextRaw: NSObject {

    /// The message to be presented.
    ///
    /// The message can be modified before presentation in
    /// ``BrazeInAppMessageUIDelegate/inAppMessage(_:prepareWith:)-11fog``:
    /// ```swift
    /// // Disable animations on all message types
    /// context.message.animateIn = false
    /// context.message.animateOut = false
    ///
    /// // Force slideup messages to animate from the top
    /// context.message.slideFrom = .top
    ///
    /// // Read custom text from extras and apply it to multiple message types.
    /// if let customText = context.message.extras["custom_text"] as? String {
    ///   context.message.message = customText
    /// }
    /// ```
    ///
    /// - Important: Customizing the campaign via the Braze platform is preferred to using this
    ///              property directly.
    @objc
    public var message: Braze.InAppMessageRaw

    /// The attributes for the message view to be presented.
    ///
    /// The view attributes can be modified before presentation in
    /// ``BrazeInAppMessageUIDelegate/inAppMessage(_:prepareWith:)-11fog``:
    /// ```swift
    /// // Increase slideup image size
    /// context.attributes?.slideup?.imageSize = CGSize(width: 100, height: 100)
    ///
    /// // Remove modals corner radius
    /// context.attributes?.modal?.cornerRadius = 0
    /// context.attributes?.modalImage?.cornerRadius = 0
    /// ```
    ///
    /// `attributes` is `nil` when displaying a control in-app message.
    ///
    /// To modify the default attributes, modify the `defaults` property on the attribute type.
    /// For instance, the previous image size increase can be applied to all slideup in-app message
    /// by setting:
    /// ```swift
    /// BrazeInAppMessageUI.SlideupView.Attributes.defaults.imageSize = CGSize(width: 100, height: 100)
    /// ```
    ///
    /// - Note: This property is not available in Objective-C.
    public var attributes: ViewAttributes?

    /// A user-provided custom in-app message view to be used in place of the Braze in-app message
    /// view.
    public var customView: InAppMessageView?

    /// The preferred orientation used to present the message (default: current interface
    /// orientation).
    ///
    /// The orientation is applied only for the presentation of the message. Once the device
    /// changes orientation, the message view adopts one of the orientation it supports.
    /// Use `message.orientation` to modify the supported orientations.
    ///
    /// - Important: On smaller devices (iPhones, iPod Touch), setting a landscape orientation for
    ///              a modal or full in-app message may lead to truncated content.
    @objc
    public var preferredOrientation: UIInterfaceOrientation

    /// Defines the status bar hide behavior (default: `.auto`).
    ///
    /// When set to ``BrazeInAppMessageUI/StatusBarHideBehavior/auto``, the in-app message view is
    /// responsible for hiding and displaying the status bar when appropriate.
    public var statusBarHideBehavior: StatusBarHideBehavior = .auto

    /// The window level for the in-app message window (default: `.normal`).
    @objc
    public var windowLevel: UIWindow.Level = .normal

    /// The window scene used to present the message (default: current active window scene).
    @objc
    @available(iOS 13.0, tvOS 13.0, *)
    public var windowScene: UIWindowScene? {
      get { _windowScene as? UIWindowScene }
      set { _windowScene = newValue }
    }

    var _windowScene: Any?

    /// The view controller used to proxy `UIViewController` based preferences. (default: topmost
    /// presented view controller on the application root view controller).
    ///
    /// Preferences includes:
    /// - `UIViewController.prefersHomeIndicatorAutoHidden`
    /// - `UIViewController.preferredScreenEdgesDeferringSystemGestures`
    /// - `UIViewController.prefersPointerLocked`
    /// - `UIViewController.preferredStatusBarStyle`
    /// - `UIViewController.preferredStatusBarUpdateAnimation`
    /// - `UIViewController.prefersStatusBarHidden`
    ///   - Only when ``statusBarHideBehavior`` is set to `.auto` and the message view hasn't
    ///     requested any specific hidden state.
    ///
    /// Set this value to a view controller implementing some of the aforementioned properties and
    /// methods to customize the in-app message view controller presentation.
    @objc
    public var preferencesProxy: UIViewController?

    /// Initializes a raw `PresentationContext` from the Swift representation.
    ///
    /// - Parameter context: The Swift version of the ``BrazeInAppMessageUI/PresentationContext``.
    init(_ context: BrazeInAppMessageUI.PresentationContext) {
      self.message = Braze.InAppMessageRaw(context.message)
      self.attributes = context.attributes
      self.customView = context.customView
      self.preferredOrientation = context.preferredOrientation
      self.statusBarHideBehavior = context.statusBarHideBehavior
      self.windowLevel = context.windowLevel
      self.preferencesProxy = context.preferencesProxy

      super.init()

      if #available(iOS 13.0, tvOS 13.0, *) {
        self.windowScene = context.windowScene
      }
    }

    /// Default initializer.
    init(
      message: Braze.InAppMessageRaw,
      attributes: ViewAttributes? = nil,
      customView: InAppMessageView? = nil,
      preferredOrientation: UIInterfaceOrientation,
      statusBarHideBehavior: StatusBarHideBehavior = .auto,
      windowLevel: UIWindow.Level = .normal,
      preferencesProxy: UIViewController? = nil,
      windowScene: Any? = nil
    ) {

      self.message = message
      self.attributes = attributes
      self.customView = customView
      self.preferredOrientation = preferredOrientation
      self.statusBarHideBehavior = statusBarHideBehavior
      self.windowLevel = windowLevel
      self.preferencesProxy = preferencesProxy

      super.init()

      if #available(iOS 13.0, tvOS 13.0, *),
        let windowScene = windowScene as? UIWindowScene
      {
        self.windowScene = windowScene
      }
    }

  }

}

extension BrazeInAppMessageUI.PresentationContext {

  /// Initializes a Swift ``BrazeInAppMessageUI/PresentationContext`` from the raw context.
  ///
  /// - Parameter presentationContextRaw: The raw presentation context.
  init(_ presentationContextRaw: BrazeInAppMessageUI.PresentationContextRaw) throws {
    self.message = try Braze.InAppMessage(presentationContextRaw.message)
    self.attributes = presentationContextRaw.attributes
    self.customView = presentationContextRaw.customView
    self.preferredOrientation = presentationContextRaw.preferredOrientation
    self.statusBarHideBehavior = presentationContextRaw.statusBarHideBehavior
    self.windowLevel = presentationContextRaw.windowLevel
    self.preferencesProxy = presentationContextRaw.preferencesProxy

    if #available(iOS 13.0, tvOS 13.0, *) {
      self.windowScene = presentationContextRaw.windowScene
    }
  }

}
