<p align="center">
  <img width="480" alt="Braze Logo" src=".github/assets/logo-light.png#gh-light-mode-only" />
  <img width="480" alt="Braze Logo" src=".github/assets/logo-dark.png#gh-dark-mode-only" />
</p>

# Braze Swift SDK [![latest release](https://img.shields.io/github/v/tag/braze-inc/braze-swift-sdk?label=latest%20release&color=300266)](https://github.com/braze-inc/braze-swift-sdk/releases) [![Static Badge](https://img.shields.io/badge/DocC-801ed7)](https://braze-inc.github.io/braze-swift-sdk)

- [Braze User Guide](https://www.braze.com/docs/user_guide/introduction/ "Braze User Guide")
- [Braze Developer Guide](https://www.braze.com/docs/developer_guide/sdk_integration/?sdktab=swift "Braze Developer Guide")

## Quickstart

``` swift
// AppDelegate.swift
import BrazeKit

class AppDelegate: UIResponder, UIApplicationDelegate {
  // ...
  static var braze: Braze? = nil

  // ...
   func application(
      _ application: UIApplication, 
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // ...
        let configuration = Braze.Configuration(
            apiKey: "YOUR-APP-IDENTIFIER-API-KEY",
            endpoint: "YOUR-BRAZE-ENDPOINT"
        )
        let braze = Braze(configuration: configuration)

        AppDelegate.braze = braze
        // ...
    }
}
```

``` swift
AppDelegate.braze?.changeUser(userId: "Jane Doe")
```

See [the Braze Developer Guide](https://www.braze.com/docs/developer_guide/sdk_integration/?sdktab=swift) for advanced integration options.

## Version Support

Tool | Minimum Supported Version
:----|:----
iOS|12.0+
Mac Catalyst|13.0+
tvOS|12.0+
visionOS|1.0+
Xcode|16.0+ (16A242d)

## Package Managers
- Swift Package Manager
- CocoaPods

## Libraries

<!-- Table generated with https://www.tablesgenerator.com/markdown_tables -->

|                                                                                                                             | iOS |     tvOS      | macCatatyst |   visionOS    |
|-----------------------------------------------------------------------------------------------------------------------------|:---:|:-------------:|:-----------:|:-------------:|
| **BrazeKit**</br> _Main SDK library providing support for [analytics] and [push notifications]._                            |  ✅  | ✅<sup>1</sup> |      ✅      |       ✅       |
| **BrazeUI**</br> _Braze-provided user interface library for [In-App Messages] and [Content Cards]._                         |  ✅  |      n/a      |      ✅      |       ✅       |
| **BrazeLocation**</br> _Location library providing support for [location analytics and geofence monitoring]._               |  ✅  | ✅<sup>2</sup> |      ✅      | ✅<sup>2</sup> |
| **BrazeNotificationService**</br> _Notification service extension library providing support for [rich push notifications]._ |  ✅  |      n/a      |      ✅      |       ✅       |
| **BrazePushStory**</br> _Notification content extension library providing support for [Push Stories]._                      |  ✅  |      n/a      |      ✅      |       ✅       |

<sup>1</sup> _Push notifications not supported on tvOS_</br>
<sup>2</sup> _Geofence monitoring not supported on tvOS and visionOS_

[analytics]: https://www.braze.com/docs/user_guide/data_and_analytics/user_data_collection/sdk_data_collection/
[push notifications]: https://www.braze.com/docs/user_guide/message_building_by_channel/push
[In-App Messages]: https://www.braze.com/docs/user_guide/message_building_by_channel/in-app_messages
[Content Cards]: https://www.braze.com/docs/user_guide/message_building_by_channel/content_cards
[location analytics and geofence monitoring]: https://www.braze.com/docs/user_guide/engagement_tools/locations_and_geofences
[rich push notifications]: https://www.braze.com/docs/user_guide/message_building_by_channel/push/ios/rich_notifications/
[Push Stories]: https://www.braze.com/docs/user_guide/message_building_by_channel/push/advanced_push_options/push_stories/

## Examples

Explore our [examples project](/Examples) which showcases multiple features' integrations.

## Alternative Repositories

| Variant                               |                                     Repository | GH Issues, SDK info |
|---------------------------------------|-----------------------------------------------:|--------------------:|
| → **Sources and Static XCFrameworks** |                    [braze-inc/braze-swift-sdk] |                   ✓ |
| Static XCFrameworks                   |    [braze-inc/braze-swift-sdk-prebuilt-static] |                   ✗ |
| Dynamic XCFrameworks                  |   [braze-inc/braze-swift-sdk-prebuilt-dynamic] |                   ✗ |
| Mergeable XCFrameworks (early access) | [braze-inc/braze-swift-sdk-prebuilt-mergeable] |                   ✗ |

## Contact

If you have questions, please contact [support@braze.com](mailto:support@braze.com).

[braze-inc/braze-swift-sdk]: https://github.com/braze-inc/braze-swift-sdk
[braze-inc/braze-swift-sdk-prebuilt-static]: https://github.com/braze-inc/braze-swift-sdk-prebuilt-static
[braze-inc/braze-swift-sdk-prebuilt-dynamic]: https://github.com/braze-inc/braze-swift-sdk-prebuilt-dynamic
[braze-inc/braze-swift-sdk-prebuilt-mergeable]: https://github.com/braze-inc/braze-swift-sdk-prebuilt-mergeable
