#import "AppDelegate.h"
#import "BRZGIFViewProvider+SDWebImage.h"

@import BrazeKit;
@import BrazeUI;

@interface AppDelegate () <BrazeDelegate, BrazeInAppMessageUIDelegate>

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
  Braze *braze = [[Braze alloc] initWithConfiguration:configuration];
  AppDelegate.braze = braze;

  // - GIF support
  BRZGIFViewProvider.shared = [BRZGIFViewProvider sdWebImage];

  // - InAppMessageUI
  BrazeInAppMessageUI *inAppMessageUI = [[BrazeInAppMessageUI alloc] init];
  inAppMessageUI.delegate = self;
  braze.inAppMessagePresenter = inAppMessageUI;

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

#pragma mark - BrazeInAppMessageUIDelegate

- (BOOL)inAppMessage:(BrazeInAppMessageUI *)ui
       shouldProcess:(enum BRZInAppMessageRawClickAction)clickAction
                 url:(NSURL *)uri
            buttonId:(NSString *)buttonId
             message:(BRZInAppMessageRaw *)message
                view:(UIView *)view {
  // Intercept the in-app message click action here
  return YES;
}

- (void)inAppMessage:(BrazeInAppMessageUI *)ui
          didPresent:(BRZInAppMessageRaw *)message
                view:(UIView *)view {
  // Executed when `message` is presented to the user
}

@end
