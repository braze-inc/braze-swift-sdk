import BrazeKit
import Foundation

@objc(BrazeContentCardUIViewControllerDelegate)
public protocol _OBJC_BrazeContentCardUIViewControllerDelegate: AnyObject {

  /// Defines whether Braze should process the Content Card click action.
  ///
  /// If the method returns `true` (default return value), Braze processes the click action.
  ///
  /// - Important: When this method returns `true` and the click action is a url, Braze will
  ///              **still** execute the `BrazeDelegate.braze(_:shouldOpenURL:)` delegate method
  ///              offering a last opportunity to modify or replace Braze url handling behavior.
  ///              If your implementation only needs access to the `url`, use
  ///              `BrazeDelegate.braze(_:shouldOpenURL:)` instead.
  ///
  /// - Parameters:
  ///   - controller: The view controller containing the Content Card.
  ///   - url: The url to process.
  ///   - card: The Content Card.
  /// - Returns: `true` to let Braze process the click action, `false` otherwise
  @objc(contentCardController:shouldProcess:card:)
  optional func _objc_contentCard(
    _ controller: BrazeContentCardUI.ViewController,
    shouldProcess url: URL,
    card: Braze.ContentCardRaw
  ) -> Bool

}

// MARK: - Delegate Wrapper

final class _OBJC_BrazeContentCardUIViewControllerDelegateWrapper:
  BrazeContentCardUIViewControllerDelegate
{

  /// Property used as a unique key for the wrapper lifecycle behavior.
  private static var wrapperKey: Void?

  /// The ObjC content card UI view controller delegate.
  weak var delegate: _OBJC_BrazeContentCardUIViewControllerDelegate?

  init(_ delegate: _OBJC_BrazeContentCardUIViewControllerDelegate) {
    self.delegate = delegate
    objc_setAssociatedObject(delegate, &Self.wrapperKey, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }

  deinit {
    if let delegate = delegate {
      objc_setAssociatedObject(delegate, &Self.wrapperKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  func contentCard(
    _ controller: BrazeContentCardUI.ViewController,
    shouldProcess clickAction: Braze.ContentCard.ClickAction,
    card: Braze.ContentCard
  ) -> Bool {
    switch clickAction {
    case .url(let url, _):
      return delegate?._objc_contentCard?(controller, shouldProcess: url, card: .init(card)) ?? true
    @unknown default:
      return true
    }
  }
}
