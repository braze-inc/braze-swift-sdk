let readme =
  """
  This sample presents a complete push notification integration allowing the SDK to be initialized asynchronously. This is an extension of the PushNotifications-Automatic sample application.

  - PushNotifications/AppDelegate.swift:
    - Delayed SDK initialization support
    - Automatic push support via SDK configuration

  - PushNotificationsServiceExtension:
    - Rich push notification support (image, GIF, audio, video)

  - PushNotificationsContentExtension:
    - Braze Push Story implementation
  """

@MainActor
let actions: [(String, String, @MainActor (ReadmeViewController) -> Void)] = [
  (
    "Initialize Braze",
    "",
    initializeBraze
  )
]

// MARK: - Internal

@MainActor
func initializeBraze(_ viewController: ReadmeViewController) {
  AppDelegate.initializeBraze()

  // Disable cell
  for cell in viewController.tableView.visibleCells {
    cell.isUserInteractionEnabled = false
    cell.textLabel?.textColor = .systemGray
    cell.detailTextLabel?.textColor = .systemGray
  }
}
