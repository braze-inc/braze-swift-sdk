import UIKit

@MainActor
final class ReadmeViewController: UITableViewController {

  let textFieldRows: [ReadmeTextFieldRow]

  private enum Section {
    case textFields
    case actions(title: String, rows: [(String, String, @MainActor (ReadmeViewController) -> Void)])
  }
  private let sections: [Section]

  let readmeTextView: UITextView = {
    let textView = UITextView()
    textView.backgroundColor = .clear
    textView.isScrollEnabled = false

    #if os(iOS) || os(visionOS)
      textView.isEditable = false
    #endif

    #if os(iOS)
      textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
      if #available(iOS 13.0, *) {
        textView.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
      }
    #elseif os(tvOS)
      textView.textContainerInset = UIEdgeInsets(
        top: 0, left: 16 * 6, bottom: 16 * 4, right: 16 * 6)
      if #available(tvOS 13.0, *) {
        textView.font = .monospacedSystemFont(ofSize: 30, weight: .regular)
      }
    #elseif os(visionOS)
      textView.textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
      if #available(tvOS 13.0, *) {
        textView.font = .monospacedSystemFont(ofSize: 20, weight: .regular)
      }
    #endif

    return textView
  }()

  init(readme: String, actions: [(String, String, @MainActor (ReadmeViewController) -> Void)]) {
    self.textFieldRows = readmeTextFieldRows

    var sections: [Section] = []
    if !readmeTextFieldRows.isEmpty {
      sections.append(.textFields)
    }
    sections.append(.actions(title: "Actions", rows: actions))
    for section in readmeActionSections {
      sections.append(.actions(title: section.title, rows: section.actions))
    }
    self.sections = sections

    super.init(style: .grouped)

    // Set title
    title = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String

    // Set readme text
    readmeTextView.text =
      """
      # Readme

      \(readme)
      """
    tableView.tableHeaderView = readmeTextView
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Layout

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    let size = readmeTextView.systemLayoutSizeFitting(
      .init(width: tableView.bounds.width, height: 1000))
    if readmeTextView.frame.height != size.height {
      readmeTextView.frame.size.height = size.height
    }
  }

  // MARK: - UITableViewDataSource

  override func numberOfSections(in tableView: UITableView) -> Int {
    sections.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch sections[section] {
    case .textFields: return textFieldRows.count
    case .actions(_, let rows): return rows.count
    }
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
  {
    switch sections[section] {
    case .textFields: return "User"
    case .actions(let title, _): return title
    }
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    switch sections[indexPath.section] {
    case .textFields:
      let identifier = "textFieldCellIdentifier"
      let cell =
        tableView.dequeueReusableCell(withIdentifier: identifier) as? ReadmeTextFieldCell
        ?? ReadmeTextFieldCell(style: .default, reuseIdentifier: identifier)
      let row = textFieldRows[indexPath.row]
      cell.configure(placeholder: row.placeholder, buttonTitle: row.buttonTitle) {
        [weak self] text in
        guard let self else { return }
        row.action(text, self)
      }
      return cell

    case .actions(_, let rows):
      let identifier = "cellIdentifier"
      let cell =
        tableView.dequeueReusableCell(withIdentifier: identifier)
        ?? UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
      cell.textLabel?.text = rows[indexPath.row].0
      cell.detailTextLabel?.text = rows[indexPath.row].1
      cell.detailTextLabel?.numberOfLines = 0
      return cell
    }
  }

  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard case .actions(_, let rows) = sections[indexPath.section] else { return }
    rows[indexPath.row].2(self)
    tableView.deselectRow(at: indexPath, animated: true)
  }

  // MARK: - Text fields

  /// Clears the text of all text field rows.
  func clearTextFields() {
    for case let cell as ReadmeTextFieldCell in tableView.visibleCells {
      cell.clear()
    }
  }
}

// MARK: - ReadmeTextFieldCell

private final class ReadmeTextFieldCell: UITableViewCell {

  private let textField = UITextField()
  private let button = UIButton(type: .system)
  private var onSubmit: (@MainActor (String) -> Void)?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none

    textField.autocapitalizationType = .none
    textField.autocorrectionType = .no
    textField.clearButtonMode = .whileEditing
    textField.returnKeyType = .done
    textField.translatesAutoresizingMaskIntoConstraints = false

    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(submit), for: .touchUpInside)
    button.setContentHuggingPriority(.required, for: .horizontal)
    button.setContentCompressionResistancePriority(.required, for: .horizontal)

    contentView.addSubview(textField)
    contentView.addSubview(button)

    let margins = contentView.layoutMarginsGuide
    NSLayoutConstraint.activate([
      textField.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
      textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      textField.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),
      button.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
      button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(
    placeholder: String,
    buttonTitle: String,
    onSubmit: @escaping @MainActor (String) -> Void
  ) {
    textField.placeholder = placeholder
    button.setTitle(buttonTitle, for: .normal)
    self.onSubmit = onSubmit
  }

  @objc private func submit() {
    onSubmit?(textField.text ?? "")
    textField.resignFirstResponder()
  }

  func clear() {
    textField.text = nil
  }
}

// MARK: - AutoReadme

@MainActor
private var _window: UIWindow? = {
  let readmeViewController = ReadmeViewController(readme: readme, actions: actions)
  let navigationController = UINavigationController(rootViewController: readmeViewController)

  @MainActor
  @available(iOS 13.0, tvOS 13.0, *)
  func getWindowFromScene() -> UIWindow? {
    // Get active window scene or fallback to the first scene
    let windowScene =
      UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first { $0.activationState == .foregroundActive }
      ?? UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first
    return windowScene.map { UIWindow(windowScene: $0) }
  }

  let window: UIWindow? = {
    #if os(visionOS)
      return getWindowFromScene()
    #else
      if #available(iOS 26.0, tvOS 26.0, *) {
        return getWindowFromScene()
      } else {
        return UIWindow(frame: UIScreen.main.bounds)
      }
    #endif
  }()

  window?.rootViewController = navigationController
  return window
}()

extension AppDelegate {

  var window: UIWindow? {
    get { _window }
    set { _window = newValue }
  }

}
