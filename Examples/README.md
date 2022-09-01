# Braze Examples

The Braze Examples project showcases different Braze feature integrations.
See our [Integration Path](https://braze-inc.github.io/braze-swift-sdk/tutorials/00-integration-path) tutorials for full context.

Follow the instructions below for your preferred package manager to get started.

#### Swift Package Manager

- Open `Examples-SwiftPM.xcodeproj`

#### CocoaPods

- Run `pod install`
- Open `Examples-CocoaPods.xcworkspace`

### Available Schemes

#### Analytics

- iOS, tvOS.
- Demonstrates how to use the analytics features of the SDK.
- Related tutorial: [Analytics](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/a3-analytics).

#### ContentCards

- iOS only.
- Demonstrates how to use the Braze provided Content Cards UI.
- Related tutorial: [Content Cards UI](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/c2-contentcardsui).

#### ContentCards-Custom-UI

- iOS, tvOS.
- Demonstrates how to implement your own custom Content Cards UI.

#### InAppMessages

- iOS only.
- Demonstrates how to use the Braze provided In-App Message UI.
- Related tutorial: [In-App Messages](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/c1-inappmessageui).

#### InAppMessages-Custom-UI

- iOS, tvOS.
- Demonstrates how to implement your own custom In-App Message UI.

#### Location

- iOS, tvOS.
- Presents a complete BrazeLocation integration which enables location tracking and geofence monitoring.
- Related tutorial: [Location and Geofences](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/d1-brazelocation).

#### PushNotifications

- iOS, tvOS.
- Presents a complete push notification integration supporting:
  - Silent push notifications.
  - Foreground push notifications.
    - Action buttons.
    - Display push notifications when app is already open.
  - Rich push notification support (image, GIF, audio, video).
    - Via **PushNotificationsServiceExtension**.
  - Braze Push Story implementation.
    - Via **PushNotificationsContentExtension**.
- Related tutorials:
  - [Standard Push Notifications](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/b1-standard-push-notifications).
  - [Rich Push Notifications](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/b2-rich-push-notifications).
  - [Push Stories](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/b3-push-stories).

#### PushNotificationsContentExtension

- iOS only.
- Braze Push Story implementation.
- Related tutorial: [Push Stories](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/b3-push-stories).

#### PushNotificationsServiceExtension

- iOS only.
- Rich push notification support (image, GIF, audio, video).
- Related tutorial: [Rich Push Notifications](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/b2-rich-push-notifications).
