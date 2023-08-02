#import "AppDelegate.h"

@import BrazeKit;

@implementation AppDelegate

#pragma mark - Lifecycle

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Setup Braze
  BRZConfiguration *configuration =
      [[BRZConfiguration alloc] initWithApiKey:brazeApiKey
                                      endpoint:brazeEndpoint];
  configuration.logger.level = BRZLoggerLevelInfo;
  configuration.push.appGroup =
      @"group.com.braze.PushNotifications.PushStories";
  Braze *braze = [[Braze alloc] initWithConfiguration:configuration];
  AppDelegate.braze = braze;

  // Push notifications support
  [application registerForRemoteNotifications];
  UNUserNotificationCenter *center =
      UNUserNotificationCenter.currentNotificationCenter;
  [center setNotificationCategories:BRZNotifications.categories];
  center.delegate = self;
  UNAuthorizationOptions options = UNAuthorizationOptionBadge |
                                   UNAuthorizationOptionSound |
                                   UNAuthorizationOptionAlert;
  [center requestAuthorizationWithOptions:options
                        completionHandler:^(BOOL granted,
                                            NSError *_Nullable error) {
                          NSLog(@"Notification authorization, granted: %d, "
                                @"error: %@)",
                                granted, error);
                        }];

  [self.window makeKeyAndVisible];
  return YES;
}

#pragma mark - AppDelegate.braze

static Braze *_braze = nil;

+ (Braze *)braze {
  return _braze;
}

+ (void)setBraze:(Braze *)braze {
  _braze = braze;
}

#pragma mark - Push Notification support

// - Register the device token with Braze

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [AppDelegate.braze.notifications registerDeviceToken:deviceToken];
}

// - Add support for silent notification

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:
              (void (^)(UIBackgroundFetchResult))completionHandler {
  BOOL processedByBraze =
      AppDelegate.braze != nil &&
      [AppDelegate.braze.notifications
          handleBackgroundNotificationWithUserInfo:userInfo
                            fetchCompletionHandler:completionHandler];
  if (processedByBraze) {
    return;
  }

  completionHandler(UIBackgroundFetchResultNoData);
}

// - Add support for push notifications

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(UNNotificationResponse *)response
             withCompletionHandler:(void (^)(void))completionHandler {
  BOOL processedByBraze =
      AppDelegate.braze != nil &&
      [AppDelegate.braze.notifications
          handleUserNotificationWithResponse:response
                       withCompletionHandler:completionHandler];
  if (processedByBraze) {
    return;
  }

  completionHandler();
}

// - Add support for displaying push notification when the app is currently
// running in the
//   foreground

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:
             (void (^)(UNNotificationPresentationOptions))completionHandler {
  if (@available(iOS 14, *)) {
    completionHandler(UNNotificationPresentationOptionList |
                      UNNotificationPresentationOptionBanner);
  } else {
    completionHandler(UNNotificationPresentationOptionAlert);
  }
}

@end
