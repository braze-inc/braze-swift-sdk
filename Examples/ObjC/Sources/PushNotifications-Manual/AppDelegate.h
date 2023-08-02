@import UIKit;
@import UserNotifications;
@import BrazeKit;

extern NSString *const brazeApiKey;
extern NSString *const brazeEndpoint;

@interface AppDelegate
    : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property(class, strong, nonatomic) Braze *braze;

@end
