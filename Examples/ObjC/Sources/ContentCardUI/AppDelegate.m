#import "AppDelegate.h"
#import "BRZGIFViewProvider+SDWebImage.h"

@import BrazeKit;
@import BrazeUI;

@interface AppDelegate () <BrazeContentCardUIViewControllerDelegate>
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

#pragma mark - Displaying Content Cards

- (void)pushContentCardsViewController {
  UINavigationController *navigationController =
      (UINavigationController *)self.window.rootViewController;

  // Create a content card view controller that can be pushed onto a navigation
  // stack.
  BRZContentCardUIViewController *viewController =
      [[BRZContentCardUIViewController alloc] initWithBraze:AppDelegate.braze];
  // Set the delegate
  viewController.delegate = self;
  // Push it onto the navigation stack
  [navigationController pushViewController:viewController animated:YES];
}

- (void)presentModalContentCardsViewController {
  UINavigationController *navigationController =
      (UINavigationController *)self.window.rootViewController;

  // Create a content card modal view controller that can be presented modally.
  BRZContentCardUIModalViewController *modalViewController =
      [[BRZContentCardUIModalViewController alloc]
          initWithBraze:AppDelegate.braze];
  // Set the delegate
  modalViewController.viewController.delegate = self;
  // Present modally
  [navigationController presentViewController:modalViewController
                                     animated:YES
                                   completion:nil];
}

- (void)presentModalContentCardsViewControllerCustomized {
  UIAlertController *alert = [UIAlertController
      alertControllerWithTitle:@"Not Supported"
                       message:
                           @"Customization via attributes is not supported "
                           @"using the "
                           @"Objective-C API. See our Swift Examples project "
                           @"for details about customizing the Content Cards"
                preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                            style:UIAlertActionStyleCancel
                                          handler:nil]];
  [self.window.rootViewController presentViewController:alert
                                               animated:YES
                                             completion:nil];
}

#pragma mark - Content Cards delegate

- (BOOL)contentCardController:(BRZContentCardUIViewController *)controller
                shouldProcess:(NSURL *)url
                         card:(BRZContentCardRaw *)card {
  // Intercept the content card click action here
  return YES;
}

@end
