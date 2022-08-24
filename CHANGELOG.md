## 5.3.0

##### Added

- Adds support for tvOS.
  - See the schemes _Analytics-tvOS_ and _Location-tvOS_ in the [Examples](Examples/) project.

## 5.2.0

##### Added

- Adds [Content Cards](https://www.braze.com/docs/user_guide/message_building_by_channel/content_cards) support.
  - See the [_Content Cards UI_](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/c2-contentcardsui) tutorial to get started.

##### Changed

- Raises `BrazeUI` minimum deployment target to iOS 11.0 when integrating via CocoaPods to allow providing SwiftUI compatible Views.

## 5.1.0

##### Fixed

- Fixes an issue where the SDK would be unable to present a webview when the application was already presenting a modal view controller.
- Fixes an issue preventing a full device data update after changing the identified user.
- Fixes an issue preventing events and user attributes from being flushed automatically under certain conditions.
- Fixes an issue delaying updates to push notifications settings.

##### Added

- Adds CocoaPods support.
  - Pods:
    - [BrazeKit](https://cocoapods.org/pods/BrazeKit)
    - [BrazeUI](https://cocoapods.org/pods/BrazeUI)
    - [BrazeLocation](https://cocoapods.org/pods/BrazeLocation)
    - [BrazeNotificationService](https://cocoapods.org/pods/BrazeNotificationService)
    - [BrazePushStory](https://cocoapods.org/pods/BrazePushStory)
  - See [Examples/Podfile](Examples/Podfile) for example integration.
- Adds `Braze.UIUtils.activeTopmostViewController` to get the topmost view controller that is currently being presented by the application.

## 5.0.1

##### Fixed
- Fixes a race condition when retrieving the user's notification settings.
- Fixes an issue where duplicate data could be recorded after force quitting the application.

## 5.0.0 (Early Access)

We are excited to announce the initial release of the Braze Swift SDK!

The Braze Swift SDK is set to replace the [current Braze iOS SDK](https://github.com/Appboy/appboy-ios-sdk/) and provides a more modern API, simpler integration, and better performance.

### Current limitations

The following features are not supported yet:
- Objective-C integration
- ~~tvOS integration~~
  - Added in [5.3.0](#530)
- News Feed
- ~~Content Cards~~
  - Added in [5.2.0](#520)
