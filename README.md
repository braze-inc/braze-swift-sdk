<p align="center">
  <img width="480" alt="Braze Logo" src=".github/assets/logo-light.png#gh-light-mode-only" />
  <img width="480" alt="Braze Logo" src=".github/assets/logo-dark.png#gh-dark-mode-only" />
</p>

# Braze Swift SDK (Early Access)

- [Braze User Guide](https://www.braze.com/docs/user_guide/introduction/ "Braze User Guide")
- [Braze Swift SDK Documentation](https://braze-inc.github.io/braze-swift-sdk)

## Version Information
- The Braze Swift SDK supports
  - iOS 10.0+
  - Mac Catalyst 13.0+
- Xcode 13.2.1 (13C100) or newer

## Package Managers
- Swift Package Manager
- CocoaPods

## Upcoming Feature Roadmap

The following features are planned for development. To request new Swift SDK features, please open a [Feature Request](https://github.com/braze-inc/braze-swift-sdk/issues).

| Feature | Estimated Release |
|---|---|
| tvOS | September, 2022 |
| No-code Push Primers, Events, and Attributes | September, 2022 |
| Objective-C Migration Library | October, 2022 |

## Libraries

<!-- Table generated with https://www.tablesgenerator.com/markdown_tables -->

|                                                                                                                                                                                                                                 |  iOS  | macCatatyst |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---: | :---------: |
| **BrazeKit**</br> _Main SDK library providing support for [analytics](https://www.braze.com/docs/user_guide/data_and_analytics/user_data_collection/sdk_data_collection/) and [push notifications](https://www.braze.com/docs/user_guide/message_building_by_channel/push)._                                                                                                                                    |   ✅   |      ✅      |
| **BrazeUI**</br> _Braze-provided user interface library for [In-App Messages](https://www.braze.com/docs/user_guide/message_building_by_channel/in-app_messages)._                                                                                                                                                   |   ✅   |      ✅      |
| **BrazeLocation**</br> _Location library providing support for [location analytics and geofence monitoring](https://www.braze.com/docs/user_guide/engagement_tools/locations_and_geofences)._                                                                                                                     |   ✅   |      ✅      |
| **BrazeNotificationService**</br> _Notification service extension library providing support for [ Rich Push notifications ]( https://www.braze.com/docs/user_guide/message_building_by_channel/push/ios/rich_notifications/ )._ |   ✅   |      ✅      |
| **BrazePushStory**</br> _Notification content extension library providing support for [ Push Stories ]( https://www.braze.com/docs/user_guide/message_building_by_channel/push/advanced_push_options/push_stories/ )._          |   ✅   |      ✅      |

## Examples

Explore our [examples project](/Examples) which showcases multiple features' integrations.

## `appboy-ios-sdk`

The `appboy-ios-sdk` (Objective-C) SDK is now in maintenance mode, which means only critical bug fixes, and security updates will be made. No new features or minor bug fixes will be added to that library. 

Later in 2022 we will announce our official deprecation and support policy for `appboy-ios-sdk`. For this reason, we encourage you to migrate to our new `braze-swift-sdk` as soon as possible.


## Questions?

If you have questions, please contact [support@braze.com](mailto:support@braze.com) or open a [Github Issue](https://github.com/braze-inc/braze-swift-sdk/issues).
