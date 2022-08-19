let readme =
  """
  This sample presents a complete push notification integration supporting:

  - PushNotifications/AppDelegate.swift:
    - Silent push notifications
    - Foreground push notifications
      - Action buttons
      - Display push notifications when app is already open

  - PushNotificationsServiceExtension:
    - Rich push notification support (image, GIF, audio, video)

  - PushNotificationsContentExtension:
    - Braze Push Story implementation
  """

let actions: [(String, String, (ReadmeViewController) -> Void)] = []
