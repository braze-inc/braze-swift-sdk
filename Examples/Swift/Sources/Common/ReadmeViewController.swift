import UIKit

@MainActor
final class ReadmeViewController: UITableViewController {

  let actions: [(String, String, @MainActor (ReadmeViewController) -> Void)]

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
    self.actions = actions
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

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    actions.count
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
  {
    "Actions"
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let identifier = "cellIdentifier"
    let cell =
      tableView.dequeueReusableCell(withIdentifier: identifier)
      ?? UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
    cell.textLabel?.text = actions[indexPath.row].0
    cell.detailTextLabel?.text = actions[indexPath.row].1
    cell.detailTextLabel?.numberOfLines = 0
    return cell
  }

  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let action = actions[indexPath.row].2
    action(self)
    tableView.deselectRow(at: indexPath, animated: true)
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
