import BrazeKit
import UIKit

extension BrazeContentCardUI {

  /// Wraps ``ViewController`` in a `UINavigationController` with a _Done_ button. Use this class
  /// for presenting the content cards modally.
  @objc(BRZContentCardUIModalViewController)
  open class ModalViewController: UINavigationController {

    // MARK: - Properties

    @objc
    public let viewController: ViewController

    // MARK: - Initialization

    /// Creates and return a table view controller displaying the latest content cards fetched by
    /// the Braze SDK.
    ///
    /// - Parameters:
    ///   - braze: The Braze instance.
    ///   - attributes: An attributes struct allowing customization of the table view controller
    ///                 and its cells.
    ///   - title: The navigation bar title (default: `""`).
    public init(
      braze: Braze,
      attributes: ViewController.Attributes = .defaults,
      title: String = ""
    ) {
      viewController = .init(braze: braze, attributes: attributes)
      viewController.title = title
      super.init(rootViewController: viewController)
    }

    /// Creates and returns a table view controller able to display content cards.
    ///
    /// For most use cases, prefer using ``init(braze:attributes:)`` instead.
    ///
    /// - Parameters:
    ///   - initialCards: The initial Content Cards displayed.
    ///   - refresh: An optional closure implementing the refresh logic. `nil` disables pull to
    ///              refresh.
    ///   - subscribe: An optional closure implementing the subscription to new cards logic. `nil`
    ///                disables automatic updates.
    ///   - lastUpdate: The last time the content cards were updated.
    ///   - attributes: An attributes struct allowing customization of the table view controller
    ///                 and its cells.
    ///   - title: The navigation bar title (default: `""`)
    public init(
      initialCards: [Braze.ContentCard],
      refresh: ((@escaping (Result<[Braze.ContentCard], Error>) -> Void) -> Void)? = nil,
      subscribe: ((@escaping ([Braze.ContentCard]) -> Void) -> Braze.Cancellable)? = nil,
      lastUpdate: Date? = nil,
      attributes: ViewController.Attributes = .defaults,
      title: String = ""
    ) {
      viewController = .init(
        initialCards: initialCards,
        refresh: refresh,
        subscribe: subscribe,
        lastUpdate: lastUpdate,
        attributes: attributes
      )
      viewController.title = title
      super.init(rootViewController: viewController)
    }

    /// Does not support interface-builder / storyboards.
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    /// See ``init(braze:attributes:title:)``.
    @objc
    @available(*, unavailable)
    public init() {
      // This init exists only to override the ObjC `NSObject.init` and disable it.
      fatalError("init is not available")
    }

    // MARK: - LifeCycle

    open override func viewDidLoad() {
      super.viewDidLoad()
      viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .done,
        target: self,
        action: #selector(dismissModal)
      )
    }

    @objc
    open func dismissModal() {
      dismiss(animated: true)
    }

  }

}
