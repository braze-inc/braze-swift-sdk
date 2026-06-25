import BrazeKit
import UIKit

final class CardsInfoViewController: UITableViewController {

  // Represents a card property
  struct Field {
    let name: String
    var value: Any
    var indentation: Int = 0
  }

  // Represents a table view section
  struct Section {
    let name: String?
    var fields: [Field]
  }

  // MARK: - Properties

  let braze: Braze
  private var cards: [Braze.ContentCard] = []
  private var sections: [Section] = []

  // The subscription must be retained to keep it active.
  // Cancelling it re-applies local analytics (viewed/clicked/removed) and notifies other subscribers.
  private var subscription: Braze.Cancellable?

  // Tracks cards already impressed in this presentation to avoid duplicate impression events.
  private var impressedCardIDs: Set<String> = []

  // MARK: - Initialization

  init(braze: Braze) {
    self.braze = braze
    super.init(style: .grouped)
    title = "Content Cards Info"
    let doneButton = UIBarButtonItem(
      barButtonSystemItem: .done, target: self, action: #selector(dismissModal))
    navigationItem.setRightBarButton(doneButton, animated: false)

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44.0
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    // Subscribe to content cards updates. Delivers an initial snapshot of cached cards
    // immediately, then subsequent updates as cards change. Cancelling re-applies local
    // analytics (viewed/clicked/removed) and notifies any remaining subscribers.
    // Note: impressions, clicks, and dismissals do not trigger the subscription callback
    subscription = braze.contentCards.subscribeToUpdates { [weak self] cards in
      guard let self else { return }
      self.cards = cards
      self.sections = cards.enumerated().map { Self.cardSection(from: $1, index: $0) }
      self.tableView.reloadData()
    }
  }

  @objc
  func dismissModal() {
    dismiss(animated: true)
  }

  // MARK: - UITableViewDataSource

  override func numberOfSections(in tableView: UITableView) -> Int {
    sections.count
  }

  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    sections[section].fields.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell =
      tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
      ?? UITableViewCell(style: .value1, reuseIdentifier: "cellIdentifier")

    let field = sections[indexPath.section].fields[indexPath.row]
    cell.textLabel?.text = field.name
    cell.detailTextLabel?.text = "\(field.value)"
    cell.indentationLevel = field.indentation

    cell.textLabel?.numberOfLines = 0
    if #available(iOS 13.0, tvOS 13.0, *) {
      cell.textLabel?.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
      cell.detailTextLabel?.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
    }

    return cell
  }

  override func tableView(
    _ tableView: UITableView,
    titleForHeaderInSection section: Int
  ) -> String? {
    sections[section].name
  }

  override func tableView(
    _ tableView: UITableView,
    viewForFooterInSection section: Int
  ) -> UIView? {
    let dismissButton = UIButton(type: .system)
    dismissButton.setTitle("Log Dismissal", for: .normal)
    dismissButton.tag = section
    dismissButton.addTarget(self, action: #selector(logDismissal(_:)), for: .touchUpInside)

    let clickButton = UIButton(type: .system)
    clickButton.setTitle("Log Click", for: .normal)
    clickButton.tag = section
    clickButton.addTarget(self, action: #selector(logClick(_:)), for: .touchUpInside)

    let stack = UIStackView(arrangedSubviews: [clickButton, dismissButton])
    stack.axis = .vertical
    stack.spacing = 8

    let container = UIView()
    container.addSubview(stack)
    stack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
      stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
    ])
    return container
  }

  // Log an impression when the first row of each card section becomes visible.
  // Deduplication prevents a second impression if the card scrolls off-screen and back.
  override func tableView(
    _ tableView: UITableView,
    willDisplay cell: UITableViewCell,
    forRowAt indexPath: IndexPath
  ) {
    guard indexPath.row == 0 else { return }
    let card = cards[indexPath.section]
    guard !impressedCardIDs.contains(card.id) else { return }
    impressedCardIDs.insert(card.id)
    card.context?.logImpression()
  }

  @objc
  func logClick(_ sender: UIButton) {
    let card = cards[sender.tag]
    card.context?.logClick()
    if let clickAction = card.clickAction {
      card.context?.processClickAction(clickAction)
    }
    sender.setTitle("Log Click ✅", for: .normal)
  }

  @objc
  func logDismissal(_ sender: UIButton) {
    cards[sender.tag].context?.logDismissed()
    sender.setTitle("Log Dismissal ✅", for: .normal)
    // logDismissed marks the card locally but does not immediately trigger the subscription
    // callback. In a production UI, you would also remove the card from your view here
    // rather than waiting for the next update.
  }

  // MARK: - Helpers

  static func cardSection(from card: Braze.ContentCard, index: Int) -> Section {
    var section = Section(name: "Card \(index)", fields: [])

    var type = Field(name: "type", value: "")
    var cardFields: [Field] = []
    switch card {
    case .classic(let classic):
      type.value = "classic"
      cardFields += [
        Field(name: "title", value: classic.title),
        Field(name: "description", value: classic.description),
        Field(name: "domain", value: classic.domain ?? "nil"),
      ]
    case .classicImage(let classicImage):
      type.value = "classicImage"
      cardFields += [
        Field(name: "image", value: classicImage.image),
        Field(name: "title", value: classicImage.title),
        Field(name: "description", value: classicImage.description),
        Field(name: "domain", value: classicImage.domain ?? "nil"),
      ]
    case .imageOnly(let imageOnly):
      type.value = "imageOnly"
      cardFields += [
        Field(name: "image", value: imageOnly.image),
        Field(name: "imageAspectRatio", value: imageOnly.imageAspectRatio ?? "nil"),
      ]
    case .captionedImage(let captionedImage):
      type.value = "captionedImage"
      cardFields += [
        Field(name: "image", value: captionedImage.image),
        Field(name: "imageAspectRatio", value: captionedImage.imageAspectRatio ?? "nil"),
        Field(name: "title", value: captionedImage.title),
        Field(name: "description", value: captionedImage.description),
        Field(name: "domain", value: captionedImage.domain ?? "nil"),
      ]
    case .control:
      type.value = "control"
    @unknown default:
      break
    }
    section.fields += [type] + cardFields

    section.fields += [Field(name: "id", value: card.id)]
    section.fields += fields(from: card.clickAction)
    section.fields += [
      Field(name: "viewed", value: card.viewed),
      Field(name: "dismissible", value: card.dismissible),
      Field(name: "removed", value: card.removed),
      Field(name: "pinned", value: card.pinned),
      Field(name: "clicked", value: card.clicked),
      Field(name: "test", value: card.test),
      Field(name: "createdAt", value: card.createdAt),
      Field(name: "expiresAt", value: card.expiresAt),
    ]

    return section
  }

  static func fields(
    from clickAction: Braze.ContentCard.ClickAction?,
    indentation: Int = 0
  ) -> [Field] {
    var fields: [Field] = []

    // Click Action
    var header = Field(name: "clickAction", value: "", indentation: indentation)
    switch clickAction {
    case .none:
      header.value = "none"
    case .url(let url, let useWebView):
      header.value = "url"
      fields = [
        Field(name: "url", value: url, indentation: indentation + 1),
        Field(name: "useWebView", value: useWebView, indentation: indentation + 1),
      ]
    @unknown default:
      break
    }

    return [header] + fields
  }

}
