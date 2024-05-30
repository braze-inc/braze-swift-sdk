import BrazeKit
import Foundation
import UIKit

extension BrazeInAppMessageUI.PresentationContextRaw {

  /// Different behaviors supported to hide and display the status bar.
  @objc(BRZInAppMessageUIStatusBarHideBehavior)
  public enum _OBJC_BRZInAppMessageUIStatusBarHideBehavior: Int {

    /// The message view decides the status bar hidden state.
    case auto

    /// Always hide the status bar.
    case hidden

    /// Always display the status bar.
    case visible

    init(_ statusBarHideBehavior: BrazeInAppMessageUI.StatusBarHideBehavior) {
      switch statusBarHideBehavior {
      case .auto:
        self = .auto
      case .hidden:
        self = .hidden
      case .visible:
        self = .visible
      }
    }

    var statusBarHideBehavior: BrazeInAppMessageUI.StatusBarHideBehavior {
      switch self {
      case .auto: return .auto
      case .hidden: return .hidden
      case .visible: return .visible
      }
    }
  }

}

extension BrazeInAppMessageUI.PresentationContextRaw {

  /// A user-provided custom in-app message view to be used in place of the Braze in-app message
  /// view.
  @objc(customView)
  @available(swift, obsoleted: 0.0.1)
  public var _objc_customView: UIView? {
    get { customView }
    set {
      if let inAppMessageView = newValue as? InAppMessageView {
        customView = inAppMessageView
      }
    }
  }

  /// Defines the status bar hide behavior (default: `BRZInAppMessageUIStatusBarHideBehaviorAuto`).
  ///
  /// When set to ``BrazeInAppMessageUI/StatusBarHideBehavior/auto``, the in-app message view is
  /// responsible for hiding and displaying the status bar when appropriate.
  @objc(statusBarHideBehavior)
  @available(swift, obsoleted: 0.0.1)
  public var _objc_statusBarHideBehavior: _OBJC_BRZInAppMessageUIStatusBarHideBehavior {
    get { .init(statusBarHideBehavior) }
    set { statusBarHideBehavior = newValue.statusBarHideBehavior }
  }

}
