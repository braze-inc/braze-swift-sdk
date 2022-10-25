<p align="center">
  <img width="480" alt="Braze Logo" src=".github/assets/logo-light.png#gh-light-mode-only" />
  <img width="480" alt="Braze Logo" src=".github/assets/logo-dark.png#gh-dark-mode-only" />
</p>

<p align="center">
  <a href="https://github.com/braze-inc/braze-swift-sdk/releases">
    <img src="https://badgen.net/badge/version/5.5.1/blue" alt="Version: 5.5.1">
  </a>
  <a href="#">
    <img src="https://badgen.net/badge/platforms/iOS%20%7C%20tvOS%20%7C%20Mac%20Catalyst/orange"
      alt="Platforms: iOS – tvOS – Mac Catalyst">
  </a>
  <a href="#">
    <img src="https://badgen.net/badge/package%20managers/SwiftPM%20%7C%20CocoaPods/green" alt="Package Managers: SwiftPM - CocoaPods">
  </a>
  <a href="https://github.com/braze-inc/braze-swift-sdk/blob/main/LICENSE">
    <img src="https://badgen.net/badge/license/Commercial/black" alt="License: Commercial">
  </a>
</p>

# Braze Swift SDK (Early Access)

- [Braze User Guide](https://www.braze.com/docs/user_guide/introduction/ "Braze User Guide")
- [Braze Swift SDK Documentation](https://braze-inc.github.io/braze-swift-sdk)

## Version Information
- The Braze Swift SDK supports
  - iOS 10.0+
  - Mac Catalyst 13.0+
  - tvOS 10.0+
- Xcode 13.2.1 (13C100) or newer

## Package Managers
- Swift Package Manager
- CocoaPods

## Upcoming Feature Roadmap

The following features are planned for development. To request new Swift SDK features, please open a [Feature Request](https://github.com/braze-inc/braze-swift-sdk/issues).

| Feature | Estimated Release |
|---|---|
| Objective-C Migration Library | November, 2022 |

## Libraries

<!-- Table generated with https://www.tablesgenerator.com/markdown_tables -->

|                                                                                                                             |  iOS  |     tvOS      | macCatatyst |
| --------------------------------------------------------------------------------------------------------------------------- | :---: | :-----------: | :---------: |
| **BrazeKit**</br> _Main SDK library providing support for [analytics] and [push notifications]._                            |   ✅   | ✅<sup>1</sup> |      ✅      |
| **BrazeUI**</br> _Braze-provided user interface library for [In-App Messages] and [Content Cards]._                         |   ✅   |      n/a      |      ✅      |
| **BrazeLocation**</br> _Location library providing support for [location analytics and geofence monitoring]._               |   ✅   | ✅<sup>2</sup> |      ✅      |
| **BrazeNotificationService**</br> _Notification service extension library providing support for [rich push notifications]._ |   ✅   |      n/a      |      ✅      |
| **BrazePushStory**</br> _Notification content extension library providing support for [Push Stories]._                      |   ✅   |      n/a      |      ✅      |

<sup>1</sup> _Push notifications not supported on tvOS_</br>
<sup>2</sup> _Geofence monitoring not supported on tvOS_

[analytics]: https://www.braze.com/docs/user_guide/data_and_analytics/user_data_collection/sdk_data_collection/
[push notifications]: https://www.braze.com/docs/user_guide/message_building_by_channel/push
[In-App Messages]: https://www.braze.com/docs/user_guide/message_building_by_channel/in-app_messages
[Content Cards]: https://www.braze.com/docs/user_guide/message_building_by_channel/content_cards
[location analytics and geofence monitoring]: https://www.braze.com/docs/user_guide/engagement_tools/locations_and_geofences
[rich push notifications]: https://www.braze.com/docs/user_guide/message_building_by_channel/push/ios/rich_notifications/
[Push Stories]: https://www.braze.com/docs/user_guide/message_building_by_channel/push/advanced_push_options/push_stories/

## Examples

Explore our [examples project](/Examples) which showcases multiple features' integrations.

## `appboy-ios-sdk`

The `appboy-ios-sdk` (Objective-C) SDK is now in maintenance mode, which means only critical bug fixes, and security updates will be made. No new features or minor bug fixes will be added to that library. 

Later in 2022 we will announce our official deprecation and support policy for `appboy-ios-sdk`. For this reason, we encourage you to migrate to our new `braze-swift-sdk` as soon as possible.


## Questions?

If you have questions, please contact [support@braze.com](mailto:support@braze.com) or open a [Github Issue](https://github.com/braze-inc/braze-swift-sdk/issues).
