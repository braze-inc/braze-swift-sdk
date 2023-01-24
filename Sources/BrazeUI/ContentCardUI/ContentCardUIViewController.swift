import BrazeKit
import UIKit

extension BrazeContentCardUI {

  /// A view controller which displays Braze Content Cards.
  @objc(BRZContentCardUIViewController)
  open class ViewController: UITableViewController, UITableViewDataSourcePrefetching {

    /// The content cards currently displayed.
    open var cards: [Braze.ContentCard] = [] {
      didSet { emptyStateLabel.isHidden = cards.isEmpty == false }
    }

    /// The delegate notified of the content cards UI lifecycle.
    open weak var delegate: BrazeContentCardUIViewControllerDelegate?

    /// The internal refresh implementation. Use ``refreshCards()`` instead.
    var refresh: ((@escaping (Result<[Braze.ContentCard], Error>) -> Void) -> Void)?

    /// The internal cards updates subscription implementation.
    var subscribe: ((@escaping ([Braze.ContentCard]) -> Void) -> Braze.Cancellable)?

    /// The date the content cards where last updated.
    var lastUpdate: Date?

    /// The current cards update subscription.
    private var subscription: Braze.Cancellable?

    /// The current asynchronous image loading operations.
    var imageLoads: [URL: AsyncImageView.ImageLoad] = [:]

    // MARK: - Attributes

    /// The attributes supported by the view controller.
    ///
    /// Attributes allows customizing the view controller and its associated cells.
    public struct Attributes {

      /// The _cell identifier_ to _cell class_ map.
      ///
      /// You can replace the _cell class_ by one of your own subclass to customize the appearance
      /// of the content card.
      ///
      /// See ``cellAttributes`` to customize cells without subclassing.
      public var cells: [String: UITableViewCell.Type] = [
        ClassicCell.identifier: ClassicCell.self,
        ClassicImageCell.identifier: ClassicImageCell.self,
        BannerCell.identifier: BannerCell.self,
        CaptionedImageCell.identifier: CaptionedImageCell.self,
        ControlCell.identifier: ControlCell.self,
      ]

      /// The cell attributes customizing the content card appearance.
      public var cellAttributes: BrazeContentCardUI.Cell.Attributes = .defaults

      /// The background color.
      public var backgroundColor: UIColor = .brazeTableViewBackgroundColor

      /// Flag specifying whether the pull to refresh gesture is enabled.
      public var pullToRefresh: Bool = true

      /// Timeout for refreshing content cards when the list is initially presented (default: `60`
      /// seconds).
      ///
      /// When content cards were last updated more than `automaticRefreshTimeout` seconds ago,
      /// the view controller automatically requests a refresh when it is displayed.
      ///
      /// Sets this value to `nil` to disable the automatic refresh.
      public var automaticRefreshTimeout: TimeInterval? = 60

      /// Flag specifying whether the controller should subscribe to card updates.
      public var automaticUpdates: Bool = true

      /// Closure allowing the modification of the content cards list presented.
      ///
      /// This closure is executed every time the controller receives content cards to display.
      public var transform: ([Braze.ContentCard]) -> [Braze.ContentCard] = { $0 }

      /// The message displayed when there is no content cards available.
      public var emptyStateMessage: String = localize(
        "braze.content-cards.no-card.text",
        for: .contentCard
      )

      /// The empty state message font.
      public var emptyStateMessageFont: UIFont = .preferredFont(forTextStyle: .body)

      /// The empty state message color.
      public var emptyStateMessageColor: UIColor = .brazeLabel

      /// The default attributes.
      public static let defaults = Self()
    }

    /// The attributes customizing the table view and its cells.
    open var attributes: Attributes {
      didSet { applyAttributes() }
    }

    /// Apply the current attributes to the UI, setup subscriptions.
    open func applyAttributes() {
      // Cells
      attributes.cells.forEach { tableView.register($1, forCellReuseIdentifier: $0) }

      // Background
      view.backgroundColor = attributes.backgroundColor

      // Pull to refresh
      let isCatalyst = {
        #if targetEnvironment(macCatalyst)
          return true
        #else
          return false
        #endif
      }()
      if attributes.pullToRefresh, !isCatalyst, refresh != nil {
        refreshControl = UIRefreshControl()
        refreshControl?.layer.zPosition = -1
        refreshControl?.addTarget(self, action: #selector(refreshCards), for: .valueChanged)
      } else {
        refreshControl = nil
      }

      // Automatic updates
      if attributes.automaticUpdates, view.window != nil {
        subscription = subscribeToUpdates()
      } else {
        subscription?.cancel()
      }

      // EmptyStateLabel
      emptyStateLabel.text = attributes.emptyStateMessage
      emptyStateLabel.font = attributes.emptyStateMessageFont
      emptyStateLabel.textColor = attributes.emptyStateMessageColor
    }

    // MARK: Initialization

    /// Creates and return a table view controller displaying the latest content cards fetched by
    /// the Braze SDK.
    ///
    /// - Parameters:
    ///   - braze: The Braze instance.
    ///   - attributes: An attributes struct allowing customization of the table view controller
    ///                 and its cells.
    public convenience init(braze: Braze, attributes: Attributes = .defaults) {
      self.init(
        initialCards: braze.contentCards.cards,
        refresh: { [weak braze] fulfill in
          braze?.contentCards.requestRefresh { result in fulfill(result) }
        },
        subscribe: { [weak braze] update in
          braze?.contentCards.subscribeToUpdates(update) ?? .empty
        },
        lastUpdate: braze.contentCards.lastUpdate,
        attributes: attributes
      )
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
    ///   - attributes: An attributes struct allowing customization of the table view controller
    ///                 and its cells.
    public init(
      initialCards: [Braze.ContentCard],
      refresh: ((@escaping (Result<[Braze.ContentCard], Error>) -> Void) -> Void)? = nil,
      subscribe: ((@escaping ([Braze.ContentCard]) -> Void) -> Braze.Cancellable)? = nil,
      lastUpdate: Date? = nil,
      attributes: Attributes = .defaults
    ) {
      self.cards = attributes.transform(initialCards)
      self.refresh = refresh
      self.subscribe = subscribe
      self.lastUpdate = lastUpdate
      self.attributes = attributes
      super.init(style: .plain)
    }

    /// Does not support interface-builder / storyboards.
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    /// See ``init(braze:attributes:)``.
    @objc
    @available(*, unavailable)
    public init() {
      // This init exists only to override the ObjC `NSObject.init` and disable it.
      fatalError("init is not available")
    }

    // MARK: - LifeCycle

    open override func viewDidLoad() {
      super.viewDidLoad()
      setupTableView()
      setupEmptyState()
      applyAttributes()
    }

    open override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      if attributes.automaticUpdates {
        subscription = subscribeToUpdates()
      }

      if let timeout = attributes.automaticRefreshTimeout,
        Date().timeIntervalSince(lastUpdate ?? .distantPast) > timeout
      {
        refreshCards()
      }

      impressionTracker.start()
    }

    open override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)

      subscription?.cancel()

      impressionTracker.stop()
    }

    // MARK: - Layout

    open override func viewWillTransition(
      to size: CGSize,
      with coordinator: UIViewControllerTransitionCoordinator
    ) {
      super.viewWillTransition(to: size, with: coordinator)
      coordinator.animate { _ in self.tableView.reloadData() }
    }

    // MARK: - UITableView

    /// Setup the table view
    open func setupTableView() {

      // Cells
      // - iOS 10 requires explicitly setting `estimatedRowHeight` to enable self-sizing cells
      if #available(iOS 11.0, *) {
      } else {
        tableView.estimatedRowHeight = 200
      }

      // - iOS 10 & 11 `cellLayoutMarginsFollowReadableWidth` default to true
      tableView.cellLayoutMarginsFollowReadableWidth = false

      // Appearance
      tableView.separatorStyle = .none

      // Prefetch
      tableView.prefetchDataSource = self
    }

    /// Retrieves the content card for the provided index path.
    open func card(at indexPath: IndexPath) -> Braze.ContentCard? {
      guard cards.indices.contains(indexPath.row) else { return nil }
      return cards[indexPath.row]
    }

    /// Retrieves the content card with the provided id.
    open func card(id: String) -> Braze.ContentCard? {
      cards.first(where: { $0.id == id })
    }

    /// The index path for the provided content card.
    open func indexPath(for card: Braze.ContentCard) -> IndexPath? {
      guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return nil }
      return IndexPath(row: index, section: 0)
    }

    /// Dequeue and setup a matching cell for the provided content card at index path.
    /// - Parameters:
    ///   - card: The content card.
    ///   - indexPath: The index path.
    ///   - tableView: The table view displaying the cell.
    /// - Returns: The matching cell for the provided content card.
    open func cell(
      for card: Braze.ContentCard,
      at indexPath: IndexPath,
      in tableView: UITableView
    ) -> UITableViewCell {
      func dequeue<T>(as: T.Type) -> T {
        tableView.dequeueReusableCell(withIdentifier: card.cellIdentifier, for: indexPath) as! T
      }
      let attributes = self.attributes.cellAttributes
      let imageLoad = loadImage(card: card)
      let retry = { [weak self] in
        guard let self = self,
          let imageLoad = self.loadImage(card: card, retry: true)
        else { return }
        self.updateImageCell(card: card, imageLoad: imageLoad)
      }

      switch card {
      case .classic(let classic):
        let cell = dequeue(as: ClassicCell.self)
        cell.attributes = attributes
        cell.set(card: classic)
        return cell
      case .classicImage(let classicImage):
        let cell = dequeue(as: ClassicImageCell.self)
        cell.attributes = attributes
        cell.set(card: classicImage, imageLoad: imageLoad)
        return cell
      case .banner(let banner):
        let cell = dequeue(as: BannerCell.self)
        cell.contentImageView.retry = retry
        cell.attributes = attributes
        cell.set(card: banner, imageLoad: imageLoad)
        return cell
      case .captionedImage(let captionedImage):
        let cell = dequeue(as: CaptionedImageCell.self)
        cell.contentImageView.retry = retry
        cell.attributes = attributes
        cell.set(card: captionedImage, imageLoad: imageLoad)
        return cell
      case .control:
        return dequeue(as: ControlCell.self)
      @unknown default:
        return dequeue(as: ControlCell.self)
      }
    }

    // MARK: DataSource

    open override func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
    ) -> Int {
      cards.count
    }

    open override func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
      cell(for: card(at: indexPath)!, at: indexPath, in: tableView)
    }

    open override func tableView(
      _ tableView: UITableView,
      willDisplay cell: UITableViewCell,
      forRowAt indexPath: IndexPath
    ) {
      guard let card = card(at: indexPath) else { return }
      updateImageCell(cell: cell, imageLoad: loadImage(card: card))
    }

    // MARK: Delegate

    open override func tableView(
      _ tableView: UITableView,
      heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
      if case .control = card(at: indexPath) {
        // We must return at least one pixel otherwise the table view has trouble reporting the
        // control cells properly in `tableView(_:willDisplay:forRowAt:)` and
        // `tableView(_:didEndDisplaying:forRowAt:)`
        return 1.0 / UIScreen.main.scale
      }
      return UITableView.automaticDimension
    }

    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      if let card = card(at: indexPath) {
        cardClicked(card, indexPath: indexPath)
      }
    }

    open override func tableView(
      _ tableView: UITableView,
      canEditRowAt indexPath: IndexPath
    ) -> Bool {
      card(at: indexPath)?.dismissible ?? false
    }

    open override func tableView(
      _ tableView: UITableView,
      commit editingStyle: UITableViewCell.EditingStyle,
      forRowAt indexPath: IndexPath
    ) {
      guard let card = card(at: indexPath), editingStyle == .delete else { return }
      cardDismissed(card, indexPath: indexPath)
    }

    // MARK: Prefetching

    open func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
      indexPaths
        .compactMap(card(at:))
        .forEach { loadImage(card: $0) }
    }

    open func tableView(
      _ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]
    ) {
      indexPaths
        .compactMap(card(at:))
        .forEach(cancelLoadImage(card:))
    }

    // MARK: - Subscribe

    /// Subscribes to content card updates
    /// - Returns: A cancellable that must be retained for the duration of the subscription.
    open func subscribeToUpdates() -> Braze.Cancellable? {
      subscribe? { [weak self] cards in
        guard let self = self else { return }
        self.lastUpdate = Date()
        self.cards = self.attributes.transform(cards)
        self.tableView.reloadData()
      }
    }

    // MARK: - Refresh

    /// Refresh the content cards.
    @objc open func refreshCards() {
      refreshControl?.beginRefreshing()
      refresh? { [weak self] result in
        guard let self = self else { return }
        if case .success(let cards) = result {
          self.lastUpdate = Date()
          self.cards = self.attributes.transform(cards)
          self.tableView.reloadData()
        }
        self.refreshControl?.endRefreshing()
      }
    }

    // MARK: - Content Cards operations

    /// Log the content card dismissed event and remove the cell.
    /// - Parameters:
    ///   - card: The card dismissed.
    ///   - indexPath: The index path for the cell to remove.
    open func cardDismissed(_ card: Braze.ContentCard, indexPath: IndexPath) {
      if card.removed { return }
      card.context?.logDismissed()
      cancelLoadImage(card: card)
      cards.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    /// Log the content card impression event.
    /// - Parameters:
    ///   - card: The visible card.
    ///   - indexPath: The index path for the cell.
    open func cardImpression(_ card: Braze.ContentCard, indexPath: IndexPath) {
      if card.viewed { return }
      card.context?.logImpression()

      // We just update the local data model here, the unviewed indicator is updated separately via
      // `cardViewed(_:indexPath:cell:)`
      cards[indexPath.row].viewed = true
    }

    /// Mark the card as viewed, hide the cell's unviewed indicator.
    /// - Parameters:
    ///   - card: The card viewed.
    ///   - indexPath: The index path for the cell.
    ///   - cell: The cell to update, it is automatically retrieved from the table view when `nil`.
    open func cardViewed(_ card: Braze.ContentCard, indexPath: IndexPath, cell: Cell? = nil) {
      cards[indexPath.row].viewed = true
      if let cell = cell ?? tableView.cellForRow(at: indexPath) as? Cell {
        cell.viewed = true
      }
    }

    /// Log the content card click event and process the click action.
    /// - Parameters:
    ///   - card: The card clicked.
    ///   - indexPath: The index path for the cell to update.
    open func cardClicked(_ card: Braze.ContentCard, indexPath: IndexPath) {
      cardViewed(card, indexPath: indexPath)

      card.context?.logClick()
      cards[indexPath.row].clicked = true

      guard let clickAction = card.clickAction else {
        return
      }
      let process = delegate?.contentCard(self, shouldProcess: clickAction, card: card) ?? true
      if process {
        card.context?.processClickAction(clickAction)
      }
    }

    // MARK: - Visibility Tracking

    lazy var impressionTracker: VisibilityTracker<String> = .init(
      interval: 0.1,
      visibleIdentifiers: { [weak self] in
        guard let self = self,
          let visibleIndexPaths = self.tableView.indexPathsForVisibleRows
        else { return [] }
        let ids = visibleIndexPaths.compactMap(self.card(at:)).map(\.id)
        return ids
      },
      visibleForInterval: { [weak self] id in
        guard let self = self,
          let card = self.card(id: id),
          let indexPath = self.indexPath(for: card)
        else { return }
        self.cardImpression(card, indexPath: indexPath)
      },
      exitVisible: { [weak self] indexPath, afterInterval in
        guard let self = self,
          let card = self.card(id: indexPath),
          let indexPath = self.indexPath(for: card),
          afterInterval
        else { return }
        self.cardViewed(card, indexPath: indexPath)
      }
    )

    // MARK: - Image Loading

    @discardableResult
    func loadImage(card: Braze.ContentCard, retry: Bool = false) -> AsyncImageView.ImageLoad? {
      guard let imageURL = card.imageURL else { return nil }

      // Local images
      if imageURL.isFileURL {
        if imageLoads[imageURL] == nil {
          imageLoads[imageURL] = .success(imageURL, imageSize(url: imageURL) ?? .zero)
        }
        return imageLoads[imageURL]
      }

      // Remote images
      guard let contextLoadImage = card.context?.loadImage else { return nil }
      func load(_ imageURL: URL) -> AsyncImageView.ImageLoad {
        let imageLoad: AsyncImageView.ImageLoad =
          imageURL.isFileURL
          ? .success(imageURL, imageSize(url: imageURL) ?? .zero)
          : .loading(
            contextLoadImage { [weak self] result in
              guard let self = self else { return }
              switch result {
              case .success(let localURL):
                let size = imageSize(url: localURL) ?? .zero
                self.imageLoads[imageURL] = .success(localURL, size)
                self.updateImageCell(card: card, imageLoad: .success(localURL, size))
              case .failure(let error):
                self.imageLoads[imageURL] = .failed(error)
                self.updateImageCell(card: card, imageLoad: .failed(error))
              }
            }
          )
        imageLoads[imageURL] = imageLoad
        return imageLoad
      }

      switch imageLoads[imageURL] {
      case .none:
        return load(imageURL)
      case .failed where retry:
        return load(imageURL)
      case .some(let imageLoad):
        return imageLoad
      }
    }

    func cancelLoadImage(card: Braze.ContentCard) {
      guard let imageURL = card.imageURL,
        let imageLoad = imageLoads[imageURL],
        case .loading(let cancellable) = imageLoad
      else { return }
      imageLoads[imageURL] = nil
      cancellable.cancel()
    }

    func updateImageCell(card: Braze.ContentCard, imageLoad: AsyncImageView.ImageLoad?) {
      guard let indexPath = indexPath(for: card),
        let cell = tableView.cellForRow(at: indexPath) as? BrazeContentCardUI.ImageCell
      else { return }
      updateImageCell(cell: cell, imageLoad: imageLoad)
    }

    func updateImageCell(cell: UITableViewCell, imageLoad: AsyncImageView.ImageLoad?) {
      guard let cell = cell as? BrazeContentCardUI.ImageCell else { return }
      UIView.performWithoutAnimation {
        tableView.beginUpdates()
        cell.contentImageView.imageLoad = imageLoad
        tableView.endUpdates()
      }
    }

    // MARK: - Empty State

    /// The label displayed when no content card is available.
    open lazy var emptyStateLabel: UILabel = {
      let label = UILabel()
      label.adjustsFontSizeToFitWidth = true
      label.adjustsFontForContentSizeCategory = true
      label.textAlignment = .center
      label.numberOfLines = 0
      label.isHidden = cards.isEmpty == false
      return label
    }()

    /// Setup the empty state view.
    open func setupEmptyState() {
      view.addSubview(emptyStateLabel)
      emptyStateLabel.anchors.edges.pin(to: view.readableContentGuide)
    }

    // MARK: - Braze Update

    /// Updates the view controller and attach it to a new `Braze` instance.
    /// - Parameter braze: The new `Braze` instance.
    open func updateWithBraze(_ braze: Braze) {
      cards = attributes.transform(braze.contentCards.cards)
      refresh = { [weak braze] fulfill in
        braze?.contentCards.requestRefresh { result in fulfill(result) }
      }
      subscribe = { [weak braze] update in
        braze?.contentCards.subscribeToUpdates(update) ?? .empty
      }
      lastUpdate = braze.contentCards.lastUpdate
      applyAttributes()
      imageLoads = [:]
      tableView.reloadData()
    }

  }
}

// MARK: - Previews

#if UI_PREVIEWS
  import SwiftUI

  @available(iOS 13.0, *)
  struct BrazeContentCardUIViewController_Previews: PreviewProvider {

    static let cards: [Braze.ContentCard] = [
      .classic(.mockDomain),
      .classicImage(.mockUnviewed),
      .banner(.mockPinned),
      .captionedImage(.mockShort),
    ]

    public static var previews: some View {
      BrazeContentCardUI.ViewController(initialCards: cards)
        .preview()
    }
  }

  // Previews don't seem to like accessing `BrazeContentCardUI` types directly from the
  // `ViewController`. We alias them here just so that previews find them during compilation.
  extension BrazeContentCardUI.ViewController {
    public typealias Cell = BrazeContentCardUI.Cell
    public typealias ClassicCell = BrazeContentCardUI.ClassicCell
    public typealias ClassicImageCell = BrazeContentCardUI.ClassicImageCell
    public typealias BannerCell = BrazeContentCardUI.BannerCell
    public typealias CaptionedImageCell = BrazeContentCardUI.CaptionedImageCell
    public typealias ControlCell = BrazeContentCardUI.ControlCell
  }

#endif
