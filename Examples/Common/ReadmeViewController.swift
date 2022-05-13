import UIKit

final class ReadmeViewController: UITableViewController {

  let readme: String

  let actions: [(String, String, (ReadmeViewController) -> Void)]

  init(readme: String, actions: [(String, String, (ReadmeViewController) -> Void)]) {
    self.readme = readme
    self.actions = actions
    super.init(style: .grouped)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - UITableViewDataSource

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    actions.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let identifier = "cellIdentifier"
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
      ?? UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
    cell.textLabel?.text = actions[indexPath.row].0
    cell.detailTextLabel?.text = actions[indexPath.row].1
    return cell
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let textView = UITextView()
    if #available(iOS 13.0, *) {
      textView.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
    }
    textView.backgroundColor = .clear
    textView.text =
      """
      # Readme

      \(readme)

      \(actions.isEmpty ? "# No actions for this sample" : "# Actions")
      """
    textView.textContainerInset = UIEdgeInsets(top: 64, left: 10, bottom: 16, right: 10)
    return textView
  }

  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let action = actions[indexPath.row].2
    action(self)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - AutoReadme

private var _window: UIWindow? = {
  let window = UIWindow(frame: UIScreen.main.bounds)
  window.rootViewController = ReadmeViewController(readme: readme, actions: actions)
  return window
}()

extension AppDelegate {

  var window: UIWindow? {
    get { _window }
    set { _window = newValue }
  }

}
