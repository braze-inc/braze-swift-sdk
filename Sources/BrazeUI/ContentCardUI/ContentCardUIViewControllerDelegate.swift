import BrazeKit

/// Methods for reacting to the content card UI lifecycle.
public protocol BrazeContentCardUIViewControllerDelegate: AnyObject {

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
  ///   - clickAction: The click action.
  ///   - card: The Content Card.
  /// - Returns: `true` to let Braze process the click action, `false` otherwise
  func contentCard(
    _ controller: BrazeContentCardUI.ViewController,
    shouldProcess clickAction: Braze.ContentCard.ClickAction,
    card: Braze.ContentCard
  ) -> Bool

}

// MARK: - Default implementation

extension BrazeContentCardUIViewControllerDelegate {

  public func contentCard(
    _ controller: BrazeContentCardUI.ViewController,
    shouldProcess clickAction: Braze.ContentCard.ClickAction,
    card: Braze.ContentCard
  ) -> Bool {
    true
  }

}
