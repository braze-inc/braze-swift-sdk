let readme =
  """
  This sample presents a complete push notification integration using the automation features provided by the SDK.

  All the system setup required for proper push notification handling is automatically managed by the Braze SDK when the push automation configuration is enabled. Rich notifications and Push Stories are implemented via app extensions.

  - PushNotifications/AppDelegate.swift:
    - Automatic push support via SDK configuration

  - PushNotificationsServiceExtension:
    - Rich push notification support (image, GIF, audio, video)

  - PushNotificationsContentExtension:
    - Braze Push Story implementation
  """

@MainActor
let actions: [(String, String, @MainActor (ReadmeViewController) -> Void)] = []
