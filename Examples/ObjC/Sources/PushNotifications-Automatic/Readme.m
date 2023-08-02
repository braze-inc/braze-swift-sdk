#import "ReadmeAction.h"

#pragma mark - Readme

NSString *const readme =
    @"This sample presents a complete push notification integration using the automation features"
    @" provided by the SDK.\n"
    @"\n"
    @"All the system setup required for proper push notification handling is automatically managed"
    @" by the Braze SDK when the push automation configuration is enabled. Rich notifications and"
    @" Push Stories are implemented via app extensions.\n"
    @"\n"
    @"- PushNotifications/AppDelegate.{h,m}:\n"
    @"  - Automatic push support via SDK configuration\n"
    @"\n"
    @"- PushNotificationsServiceExtension:\n"
    @"  - Rich push notification support (image, GIF, audio, video)\n"
    @"\n"
    @"- PushNotificationsContentExtension:\n"
    @"  - Braze Push Story implementation";

NSInteger const actionsCount = 0;

ReadmeAction const actions[] = {};
