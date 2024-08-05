#import "AppDelegate.h"

@import BrazeKit;

@interface AppDelegate ()

// The subscription needs to be retained to be active.
@property(strong, nonatomic) BRZCancellable *notificationSubscription;

@end

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

  // Enable all push notification automation features (default: disabled)
  configuration.push.automation.automaticSetup = YES;
  configuration.push.automation.requestAuthorizationAtLaunch = YES;
  configuration.push.automation.registerDeviceToken = YES;
  configuration.push.automation.handleBackgroundNotification = YES;
  configuration.push.automation.handleNotificationResponse = YES;
  configuration.push.automation.willPresentNotification = YES;

  Braze *braze = [[Braze alloc] initWithConfiguration:configuration];
  AppDelegate.braze = braze;

  [self.window makeKeyAndVisible];

  // Subscribe to Push notification events
  self.notificationSubscription = [AppDelegate.braze.notifications
    subscribeToUpdates:^(BRZNotificationsPayload *_Nonnull payload) {
      NSLog(@"Push notification subscription triggered:\n"
            "- type: %ld\n"
            "- title: %@\n"
            "- isSilent: %d",
            (long)payload.type, payload.title, payload.isSilent);
  }];

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

@end
