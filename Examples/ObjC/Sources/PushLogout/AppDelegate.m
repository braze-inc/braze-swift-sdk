#import "AppDelegate.h"
#import "ReadmeActionSection.h"
#import "ReadmeTextField.h"

@import BrazeKit;

// Defined in Readme.m
extern void enableSDK(void);
extern void registerPush(void);
extern void changeUser(NSString *userId);

@implementation AppDelegate

#pragma mark - Lifecycle

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Setup Braze
  BRZConfiguration *configuration =
      [[BRZConfiguration alloc] initWithApiKey:brazeApiKey
                                      endpoint:brazeEndpoint];
  configuration.logger.level = BRZLoggerLevelInfo;

  // Enable all push notification automation features so that a push token is
  // registered at launch (default: disabled).
  configuration.push.automation.automaticSetup = YES;
  configuration.push.automation.requestAuthorizationAtLaunch = YES;
  configuration.push.automation.registerDeviceToken = YES;
  configuration.push.automation.handleBackgroundNotification = YES;
  configuration.push.automation.handleNotificationResponse = YES;
  configuration.push.automation.willPresentNotification = YES;

  Braze *braze = [[Braze alloc] initWithConfiguration:configuration];
  AppDelegate.braze = braze;

  // Add a row to change the current user's ID. Populated before the window is created.
  [readmeTextFields() addObject:[[ReadmeTextField alloc]
      initWithPlaceholder:@"User ID"
              buttonTitle:@"Change user"
                   action:^(NSString *userId, ReadmeViewController *_) {
                     changeUser(userId);
                   }]];

  // Re-registration actions, shown in their own section. Populated before the window is created.
  // Live Activities push-to-start registration is available in Swift only.
  [readmeActionSections() addObject:[[ReadmeActionSection alloc]
      initWithTitle:@"Re-register after logout"
              items:@[
                [[ReadmeActionItem alloc]
                    initWithTitle:@"Enable Braze SDK"
                         subtitle:@"Re-enable the SDK after logout disabled it"
                           action:^(ReadmeViewController *_) { enableSDK(); }],
                [[ReadmeActionItem alloc]
                    initWithTitle:@"Register push"
                         subtitle:@"Re-enable the SDK and register for remote notifications"
                           action:^(ReadmeViewController *_) { registerPush(); }],
              ]]];

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

@end
