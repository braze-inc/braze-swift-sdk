import BrazeKit
import Foundation

extension BrazeContentCardUI.ViewController {

  /// The content cards currently displayed.
  @objc(cards)
  @available(swift, obsoleted: 0.0.1)
  open var _objc_cards: [Braze.ContentCardRaw] {
    get { cards.map(Braze.ContentCardRaw.init) }
    set { cards = newValue.compactMap { try? .init($0) } }
  }

  /// The delegate notified of the content cards UI lifecycle.
  @objc(delegate)
  @available(swift, obsoleted: 0.0.1)
  public weak var _objc_delegate: _OBJC_BrazeContentCardUIViewControllerDelegate? {
    get { (delegate as? _OBJC_BrazeContentCardUIViewControllerDelegateWrapper)?.delegate }
    set { delegate = newValue.flatMap(_OBJC_BrazeContentCardUIViewControllerDelegateWrapper.init) }
  }

  /// Creates and return a table view controller displaying the latest content cards fetched by
  /// the Braze SDK.
  ///
  /// - Parameter braze: The Braze instance.
  @objc
  @available(swift, obsoleted: 0.0.1)
  public convenience init(braze: Braze) {
    self.init(braze: braze, attributes: .defaults)
  }

  /// Creates and return a table view controller able to display content cards. For most use
  /// cases, prefer using ``init(braze:attributes:)`` instead.
  ///
  /// - Parameters:
  ///   - initialCards: The initial Content Cards displayed.
  ///   - refresh: An optional closure implementing the refresh logic. `nil` disables pull to
  ///              refresh.
  ///   - subscribe: An optional closure implementing the subscription to new cards logic. `nil`
  ///                disables automatic updates.
  ///   - lastUpdate: The last time the content cards were updated.
  @objc
  @available(swift, obsoleted: 0.0.1)
  public convenience init(
    initialCards: [Braze.ContentCardRaw],
    refresh: ((@escaping ([Braze.ContentCardRaw]?, Error?) -> Void) -> Void)? = nil,
    subscribe: ((@escaping ([Braze.ContentCardRaw]) -> Void) -> Braze.Cancellable)? = nil,
    lastUpdate: Date? = nil
  ) {
    self.init(
      initialCards: initialCards.compactMap { try? .init($0) },
      refresh: refresh.flatMap { refresh in
        { completion in
          refresh { cards, error in
            switch (cards, error) {
            case (.some(let cards), nil):
              completion(.success(cards.compactMap { try? Braze.ContentCard($0) }))
            case (_, .some(let error)):
              completion(.failure(error))
            case (nil, nil):
              completion(.failure(URLError(.cannotOpenFile)))
            }
          }
        }
      },
      subscribe: subscribe.flatMap { subscribe in
        { update in
          subscribe { cards in
            update(cards.compactMap { try? Braze.ContentCard($0) })
          }
        }
      },
      lastUpdate: lastUpdate,
      attributes: .defaults
    )
  }
}
