## 5.13.0

##### Fixed
- Fixes an issue where the SDK would automatically track body clicks on non-legacy HTML in-app messages.

##### Added
- Adds the synchronous `deviceId` property on the Braze instance.
  - `deviceId(queue:completion:)` is now deprecated.
  - `deviceId() async` is now deprecated.
- Adds the `automaticBodyClicks` property to the HTML in-app message view attributes. This property can be used to enable automatic body clicks tracking on non-legacy HTML in-app messages.
  - This property is `false` by default.
  - This property is ignored for legacy HTML in-app messages.

## 5.12.0

> Starting with this release, this SDK will use [Semantic Versioning](https://semver.org/).

##### Added
- Adds `json()` and `decoding(json:)` public methods to the Feature Flag model object for JSON encoding/decoding.

## 5.11.2

##### Fixed
- Fixes a crash occurring when the SDK is configured with a flush interval of `0` and network connectivity is poor.

## 5.11.1

##### Fixed
- Fixes an issue preventing the correct calculation of the delay when retrying failed requests. This led to a more aggressive retry schedule than intended.
- Improves the performance of Live Activity tracking by de-duping push token tag requests.
- Fixes an issue in `logClick(using:)` where it would incorrectly open the `url` field in addition to logging a click for metrics. It now only logs a click for metrics.
  - This applies to the associated APIs for content cards, in-app messages, and news feed cards.
  - It is still recommended to use the associated `Context` object to log interactions instead of these APIs.

##### Added
- Adds [`BrazeKit.overrideResourceBundle`] and [`BrazeUI.overrideResourceBundle`] to allow for custom resource bundles to be used by the SDK.
  - This feature is useful when your setup prevents you from using the default resource bundle (e.g. Tuist).

[`BrazeKit.overrideResourceBundle`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/overrideresourcebundle
[`BrazeUI.overrideResourceBundle`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/overrideresourcebundle/

## 5.11.0

##### Added
- Adds support for [Live Activities](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities) via the `liveActivities` module on the Braze instance.
  - This feature provides the following new methods for tracking and managing Live Activities with the Braze push server:
    - `launchActivity(pushTokenTag:activity:)`
    - `resumeActivities(ofType:)`
  - This feature requires iOS 16.1 and up.
  - To learn how to integrate this feature, refer to the [setup tutorial](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/b4-live-activities/).
- Adds logic to re-synchronize Content Cards on SDK version changes.
- Adds provisional support for Xcode 14.3 Beta via the [`braze-inc/braze-swift-sdk-xcode-14-3-preview`](https://github.com/braze-inc/braze-swift-sdk-xcode-14-3-preview) repository.

## 5.10.1

##### Changed
- Dynamic versions of the prebuilt xcframeworks are now available in the `braze-swift-sdk-prebuilt.zip` release artifact.

## 5.10.0

##### Fixed
- Fixes an issue where test content cards were removed before their expiration date.
- Fixes an issue in `BrazeUICompat` where the status bar appearance wasn't restored to its original state after dismissing a full in-app message.
- Fixes an issue when decoding notification payloads where some valid boolean values weren't correctly parsed.

##### Changed
- In-app modal and full-screen messages are now rendered with `UITextView`, which better supports large amounts of text and extended UTF code points.

## 5.9.1

##### Fixed
- Fixes an issue preventing local expired content cards from being removed.
- Fixes a behavior that could lead to background tasks extending beyond the expected time limit with inconsistent network connectivity.

##### Added
- Adds `logImpression(using:)` and `logClick(buttonId:using:)` to news feed cards.

## 5.9.0

##### Breaking
- Raises the minimum deployment target to iOS 11.0 and tvOS 11.0.
- Raises the Xcode version to 14.1 (14B47b).

##### Fixed
- Fixes an issue where the post-click webview would close automatically in some cases.
- Fixes a behavior where the current user messaging data would not be directly available after initializing the SDK or calling `changeUser(userId:)`.
- Fixes an issue preventing News Feed data models from being available offline.
- Fixes an issue where the release binaries could emit warnings when generating dSYMs.

##### Changed
- SwiftPM and CocoaPods now use the same release assets.

##### Added
- Adds support for the upcoming Braze Feature Flags product.
- Adds the `braze-swift-sdk-prebuilt.zip` archive to the release assets.
  - This archive contains the prebuilt xcframeworks and their associated resource bundles.
  - The content of this archive can be used to manually integrate the SDK.
- Adds the `Examples-Manual.xcodeproj` showcasing how to integrate the SDK using the prebuilt release assets.
- Adds support for Mac Catalyst for example applications, available at [Support/Examples/](./Support/Examples/README.md)
- Adds support to convert from `Data` into an in-app message, content card, or news feed card via `decoding(json:)`.

## 5.8.1

##### Fixed
- Fixes a conflict with the shared instance of [`ProcessInfo`], allowing low power mode notifications to trigger correctly.

##### Changed
- Renames the `BrazeLocation` class to `BrazeLocationProvider` to avoid shadowing the module of the same name ([SR-14195](https://bugs.swift.org/browse/SR-14195)).

[`ProcessInfo`]: https://developer.apple.com/documentation/foundation/processinfo

## 5.8.0

To help migrate your app from the Appboy-iOS-SDK to our Swift SDK, this release includes the `Appboy-iOS-SDK` [migration guide]:
- Follow step-by-step instructions to migrate each feature to the new APIs.
- Includes instructions for a minimal migration scenario via our compatibility libraries.

##### Added
- Adds compatibility libraries `BrazeKitCompat` and `BrazeUICompat`:
  - Provides all the old APIs from `Appboy-iOS-SDK` to easily start migrating to the Swift SDK.
  - See the [migration guide] for more details.
- Adds support for [News Feed](https://www.braze.com/docs/user_guide/engagement_tools/news_feed) data models and analytics.
  - News Feed UI is not supported by the Swift SDK. See the [migration guide] for instructions on using the compatibility UI.

[migration guide]: https://braze-inc.github.io/braze-swift-sdk/documentation/braze/appboy-migration-guide

## 5.7.0

##### Fixed
- Fixes an issue where modal image in-app messages would not respect the aspect ratio of the image when the height of the image is larger than its width.

##### Changed
- Changes modal, modal image, full, and full image in-app message view attributes to use the `ViewDimension` type for their `minWidth`, `maxWidth` and `maxHeight` attributes.
  - The `ViewDimension` type enables providing different values for regular and large size-classes.

##### Added
- Adds a configuration to use a randomly generated UUID instead of IDFV as the device ID: [`useUUIDAsDeviceId`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/configuration-swift.class/useuuidasdeviceid).
  - This configuration defaults to `false`. To opt in to this feature, set this value to `true`.
  - Enabling this value will only affect new devices. Existing devices will use the device identifier that was previously registered.

## 5.6.4

##### Fixed
- Fixes an issue preventing the execution of `BrazeDelegate` methods when setting the delegate using Objective-C.
- Fixes an issue where triggering an in-app message twice with the same event did not place the message on the in-app message stack under certain conditions.

##### Added
- Adds the public `id` field to `Braze.InAppMessage.Data`.
- Adds `logImpression(using:)` and `logClick(buttonId:using:)` to both in-app messages and content cards, and adds `logDismissed(using:)` to content cards.
  - It is recommended to continue using the associated `Context` to log impressions, clicks, and dismissals for the majority of use cases.
- Adds Swift concurrency to support async/await versions of the following public methods. These methods can be used as alternatives to their corresponding counterparts that use completion handlers:
  - [`Braze.User.id()`]
  - [`Braze.deviceId()`]
  - [`ContentCards.requestRefresh()`]
  - [`ContentCards.cardsStream`] as an alternative to [`ContentCards.subscribeToUpdates(_:)`]

[Appboy-iOS-SDK: Migration guide]: https://braze-inc.github.io/braze-swift-sdk/documentation/braze/appboy-migration-guide
[`Braze.User.id()`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/user-swift.class/id()
[`Braze.deviceId()`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/deviceid()
[`ContentCards.requestRefresh()`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/contentcards-swift.class/requestrefresh()
[`ContentCards.cardsStream`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/contentcards-swift.class/cardsstream
[`ContentCards.subscribeToUpdates(_:)`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/contentcards-swift.class/subscribetoupdates(_:)

## 5.6.3

##### Fixed
- Fixes the `InAppMessageRaw` to `InAppMessage` conversion to properly take into account the `extras` dictionary and the `duration`.
- Fixes an issue preventing the execution of the [`braze(_:sdkAuthenticationFailedWithError:)`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/brazedelegate/braze(_:sdkauthenticationfailedwitherror:)-505pz) delegate method in case of an authentication error.

##### Changed
- Improves error logging descriptions for HTTP requests and responses.

## 5.6.2

##### Changed
- Corrected the version number from the previous release.

## 5.6.1

##### Added
- Adds the public initializers `Braze.ContentCard.Context(card:using:)` and `Braze.InAppMessage.Context(message:using:)`.

## 5.6.0

##### Fixed
- The modal webview controller presented after a click now correctly handles non-HTTP(S) URLs (e.g. App Store URLs).
- Fixes an issue preventing some test HTML in-app messages from displaying images.

##### Added
- Learn how to easily customize `BrazeUI` in-app message and content cards UI components with the following documentation and example code:
  - [In-App Message UI Customization] article
  - [Content Cards UI Customization] article
  - `InAppMessageUI-Customization` example scheme
  - `ContentCardUI-Customization` example scheme
- Adds new attributes to `BrazeUI` in-app message UI components:
  - `cornerCurve` to change the [`cornerCurve`]
  - `buttonsAttributes` to change the font, spacing and corner radius of the buttons
  - `imageCornerRadius` to change the image corner radius for slideups
  - `imageCornerCurve` to change the image [`cornerCurve`] for slideups
  - `dismissible` to change whether slideups can be interactively dismissed
- Adds direct accessors to the in-app message view subclass on the [`BrazeInAppMessageUI.messageView`] property.
  - [`slideup`], [`modal`], [`modalImage`], [`full`], [`fullImage`], [`html`], [`control`].
- Adds direct accessors to the content card `title`, `description` and `domain` when available.
- Adds `Braze.Notifications.isInternalNotification` to check if a push notification was sent by Braze for an internal feature.
- Adds [`brazeBridge.changeUser()`] to the HTML in-app messages JavaScript bridge.

[In-App Message UI Customization]: https://braze-inc.github.io/braze-swift-sdk/documentation/braze/in-app-message-customization
[Content Cards UI Customization]: https://braze-inc.github.io/braze-swift-sdk/documentation/braze/content-cards-customization
[`cornerCurve`]: https://developer.apple.com/documentation/quartzcore/calayer/3152596-cornercurve
[`BrazeInAppMessageUI.messageView`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/brazeinappmessageui/messageview
[`brazeBridge.changeUser()`]: https://www.braze.com/docs/user_guide/message_building_by_channel/in-app_messages/customize/html_in-app_messages/#bridge
[`slideup`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/inappmessageview/slideup
[`modal`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/inappmessageview/modal
[`modalImage`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/inappmessageview/modalimage
[`full`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/inappmessageview/full
[`fullImage`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/inappmessageview/fullimage
[`html`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/inappmessageview/html
[`control`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/inappmessageview/control

##### Changed

- The `applyAttributes()` method for `BrazeContentCardUI` views now take the `attributes` explicitly as a parameter.

## 5.5.1

##### Fixed
- Fixes an issue where content cards would not be properly removed when stopping a content card campaign on the dashboard and selecting the option _Remove card after the next sync (e.g. session start)_.

## 5.5.0

##### Added
- Adds support for host apps written in Objective-C.
  - Braze Objective-C types start either with `BRZ` or `Braze`, e.g.:
    - `Braze`
    - `BrazeDelegate`
    - `BRZContentCardRaw`
  - See our Objective-C [Examples](Examples/) project.
- Adds [`BrazeDelegate.braze(_:noMatchingTriggerForEvent:)`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/brazedelegate/braze(_:nomatchingtriggerforevent:)-8rt7y) which is called if no Braze in-app message is triggered for a given event.

##### Changed
- In `Braze.Configuration.Api`:
  - Renamed `SdkMetadata` to `SDKMetadata`.
  - Renamed `addSdkMetadata(_:)` to `addSDKMetadata(_:)`.
- In `Braze.InAppMessage`:
  - Renamed `Themes.default` to `Themes.defaults`.
  - Renamed `ClickAction.uri` to `ClickAction.url`.
  - Renamed `ClickAction.uri(_:useWebView:)` to `ClickAction.url(_:useWebView:)`.

## 5.4.0

##### Fixed
- Fixes an issue where `brazeBridge.logClick(button_id)` would incorrectly accept invalid `button_id` values like `""`, `[]`, or `{}`.

##### Added
- Adds support for Braze Action Deeplink Click Actions.

## 5.3.2

##### Fixed
- Fixes an issue preventing compilation when importing `BrazeUI` via SwiftPM in specific cases.
- Lowers `BrazeUI` minimum deployment target to iOS 10.0.

## 5.3.1

##### Fixed
- Fixes an HTML in-app message issue where clicking a link in an iFrame would launch a separate webview and close the message, instead of redirecting within the iFrame.
- Fixes the rounding of In-App Message modal view top corners.
- Fixes the display of modals and full screen in-app messages on iPads in landscape mode.

##### Added
- Adds two Example schemes:
  - InAppMessage-Custom-UI:
    - Demonstrates how to implement your own custom In-App Message UI.
    - Available on iOS and tvOS.
  - ContentCards-Custom-UI:
    - Demonstrates how to implement your own custom Content Card UI.
    - Available on iOS and tvOS.
- Adds [`Braze.InAppMessage.ClickAction.uri`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/inappmessage/clickaction/uri) for direct access.
- Adds [`Braze.ContentCard.ClickAction.uri`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/contentcard/clickaction/uri/) for direct access.
- Adds [`Braze.deviceId(queue:completion:)`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/deviceid(queue:completion:)) to retrieve the device identifier used by Braze.

## 5.3.0

##### Added
- Adds support for tvOS.
  - See the schemes _Analytics-tvOS_ and _Location-tvOS_ in the [Examples](Examples/) project.

## 5.2.0

##### Added
- Adds [Content Cards](https://www.braze.com/docs/user_guide/message_building_by_channel/content_cards) support.
  - See the [_Content Cards UI_](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/c2-contentcardsui) tutorial to get started.

##### Changed
- Raises `BrazeUI` minimum deployment target to iOS 11.0 to allow providing SwiftUI compatible Views.

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
- ~~Objective-C integration~~
  - Added in [5.5.0](#550)
- ~~tvOS integration~~
  - Added in [5.3.0](#530)
- ~~News Feed~~
  - Added in [5.7.0](#570)
- ~~Content Cards~~
  - Added in [5.2.0](#520)
