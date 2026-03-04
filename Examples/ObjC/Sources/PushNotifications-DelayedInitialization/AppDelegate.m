#import "AppDelegate.h"

@import BrazeKit;

@implementation AppDelegate

#pragma mark - Lifecycle

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Prepare Braze for delayed initialization
  // - This ensures that push notifications received before the SDK is initialized are processed
  //   during initialization.
  [Braze prepareForDelayedInitialization];
  
  [self.window makeKeyAndVisible];
  return YES;
}

+ (void)initializeBraze {
  // Setup Braze
  BRZConfiguration *configuration =
      [[BRZConfiguration alloc] initWithApiKey:brazeApiKey
                                      endpoint:brazeEndpoint];
  configuration.logger.level = BRZLoggerLevelInfo;
  configuration.push.appGroup = @"group.com.braze.PushNotifications.PushStories";

  // Enable all push notification automation features (default: disabled)
  // - Using `Braze.prepareForDelayedInitialization()` implicitly enables push automation.
  // - Specific properties of the automation configuration can be customized for initialization.
  configuration.push.automation.automaticSetup = YES;
  configuration.push.automation.requestAuthorizationAtLaunch = YES;
  configuration.push.automation.registerDeviceToken = YES;
  configuration.push.automation.handleBackgroundNotification = YES;
  configuration.push.automation.handleNotificationResponse = YES;
  configuration.push.automation.willPresentNotification = YES;

  Braze *braze = [[Braze alloc] initWithConfiguration:configuration];
  AppDelegate.braze = braze;
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
