#import "AppDelegate.h"
#import "FullScreenBannerViewController.h"
#import "WideBannerViewController.h"

@import BrazeKit;
@import BrazeUI;

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
  
  // Request updated banners.
  [braze.banners requestBannersRefreshForPlacementIds:@[
    @"sdk-test-1",
    @"sdk-test-2",
  ]];
  
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

- (void)displayFullScreenBanner {
  UIViewController *viewController = [[FullScreenBannerViewController alloc] init];
  UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
  if (navigationController) {
    [navigationController pushViewController:viewController 
                                    animated:YES];
  }
}

- (void)displayWideBanner {
  UIViewController *viewController = [[WideBannerViewController alloc] init];
  UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
  if (navigationController) {
    [navigationController pushViewController:viewController 
                                    animated:YES];
  }
}

@end
