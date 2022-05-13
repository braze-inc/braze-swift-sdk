import BrazeKit
import UIKit

extension BrazeInAppMessageUI {

  /// Presentation context for an in-app message.
  ///
  /// A writable instance of this type is passed to the ``BrazeInAppMessageUI/delegate`` via the
  /// ``BrazeInAppMessageUIDelegate/inAppMessage(_:prepareWith:)-11fog`` method.
  public struct PresentationContext {

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
    /// context.message.slideup?.slideFrom = .top
    ///
    /// // Read custom text from extras and apply it to multiple message types.
    /// if let customText = context.message.extras["custom_text"] as? String {
    ///   context.message.slideup?.message = customText
    ///   context.message.modal?.message = customText
    ///   context.message.full?.message = customText
    /// }
    /// ```
    ///
    /// - Important: Customizing the campaign via the Braze platform is preferred to using this
    ///              property directly.
    public var message: Braze.InAppMessage

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
    public var attributes: ViewAttributes?

    /// A user-provided custom in-app message view to be used in place of the Braze in-app message
    /// view.
    public var customView: InAppMessageView?

    /// The preferred orientation used to present the message (default: current interface
    /// orientation)
    ///
    /// The orientation is applied only for the presentation of the message. Once the device
    /// changes orientation, the message view adopts one of the orientation it's support.
    /// Use `message.orientation` to modify the supported orientations.
    ///
    /// - Important: On smaller devices (iPhones, iPod Touch), setting a landscape orientation for
    ///              a modal or full in-app message may lead to truncated content.
    public var preferredOrientation: UIInterfaceOrientation

    /// Defines the status bar hide behavior (default: `.auto`).
    ///
    /// When set to ``BrazeInAppMessageUI/StatusBarHideBehavior/auto``, the in-app message view is
    /// responsible for hiding and displaying the status bar when appropriate.
    public var statusBarHideBehavior: StatusBarHideBehavior = .auto

    /// The window level for the in-app message window (default: `.normal`).
    public var windowLevel: UIWindow.Level = .normal

    /// The window scene used to present the message (default: current active window scene).
    @available(iOS 13.0, tvOS 13.0, *)
    public var windowScene: UIWindowScene? {
      get { _windowScene as? UIWindowScene }
      set { _windowScene = newValue }
    }
    var _windowScene: Any?

    /// The view controller used to proxy `UIViewController` based preferences. (default: topmost
    /// presented view controller on the application root view controller)
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
    public var preferencesProxy: UIViewController?
  }

  /// Different behaviors supported to hide and display the status bar.
  public enum StatusBarHideBehavior {

    /// The message view decides the status bar hidden state.
    case auto

    /// Always hide the status bar.
    case hidden

    /// Always display the status bar.
    case visible

  }

}
