# Braze Examples

The Braze Examples project showcases different Braze feature integrations.
See our [Integration Path](https://braze-inc.github.io/braze-swift-sdk/tutorials/00-integration-path) tutorials for full context.

Follow the instructions below for your preferred integration method to get started.

#### Swift Package Manager

- Navigates to the `Swift` or `ObjC` directory
- Open `Examples-SwiftPM.xcodeproj`

#### CocoaPods

- Navigates to the `Swift` or `ObjC` directory
- Run `pod install`
- Open `Examples-CocoaPods.xcworkspace`

#### Manual Integration

- Navigates to the `Swift` or `ObjC` directory
- Run `./manual-integration-setup.sh` to download the prebuilt Braze SDK
- Open `Examples-Manual.xcodeproj`

### Available Schemes

#### Analytics

- iOS, tvOS, Mac Catalyst.
- Swift, Objective-C.
- Demonstrates how to use the analytics features of the SDK.
- Related tutorial: [Analytics](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/a3-analytics).

#### ContentCardUI

- iOS, Mac Catalyst.
- Swift, Objective-C.
- Demonstrates how to use the Braze provided Content Cards UI.
- Related tutorial: [Content Cards UI](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/c2-contentcardsui).

#### ContentCardUI-Customization

- iOS, Mac Catalyst.
- Swift only.
- Demonstrates how to customize the Braze provided Content Cards UI.
- Related article: [Content Cards UI Customization](https://braze-inc.github.io/braze-swift-sdk/documentation/braze/content-cards-customization).

#### ContentCards-Custom-UI

- iOS, tvOS, Mac Catalyst.
- Swift, Objective-C.
- Demonstrates how to implement your own custom Content Cards UI.
- Related article: [Content Cards UI Customization](https://braze-inc.github.io/braze-swift-sdk/documentation/braze/content-cards-customization).

#### InAppMessageUI

- iOS, Mac Catalyst.
- Swift, Objective-C.
- Demonstrates how to use the Braze provided In-App Message UI.
- Related tutorial: [In-App Messages](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/c1-inappmessageui).

#### InAppMessageUI-Customization

- iOS, Mac Catalyst.
- Swift only.
- Demonstrates how to customize the Braze provided In-App Message UI.
- Related article: [In-App Message UI Customization](https://braze-inc.github.io/braze-swift-sdk/documentation/braze/in-app-message-customization)

#### InAppMessages-Custom-UI

- iOS, tvOS, Mac Catalyst.
- Swift, Objective-C.
- Demonstrates how to implement your own custom In-App Message UI.
- Related article: [In-App Message UI Customization](https://braze-inc.github.io/braze-swift-sdk/documentation/braze/in-app-message-customization)

#### Location

- iOS, tvOS, Mac Catalyst.
- Swift, Objective-C.
- Presents a complete BrazeLocation integration which enables location tracking and geofence monitoring.
- Related tutorial: [Location and Geofences](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/d1-brazelocation).

#### PushNotifications

- iOS, Mac Catalyst.
- Swift, Objective-C.
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

- iOS, Mac Catalyst.
- Swift only.
- Braze Push Story implementation.
- Related tutorial: [Push Stories](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/b3-push-stories).

#### PushNotificationsServiceExtension

- iOS, Mac Catalyst
- Swift only.
- Rich push notification support (image, GIF, audio, video).
- Related tutorial: [Rich Push Notifications](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/b2-rich-push-notifications).
