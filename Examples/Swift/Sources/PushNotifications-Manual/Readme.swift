let readme =
  """
  This sample presents a complete manual push notification integration supporting:

  - PushNotifications/AppDelegate.swift:
    - Silent push notifications
    - Foreground push notifications
      - Action buttons
      - Display push notifications when app is already open

  - PushNotificationsServiceExtension:
    - Rich push notification support (image, GIF, audio, video)

  - PushNotificationsContentExtension:
    - Braze Push Story implementation

  See the PushNotifications-Automatic example app for a configuration based integration.
  """

@MainActor
let actions: [(String, String, @MainActor (ReadmeViewController) -> Void)] = []
