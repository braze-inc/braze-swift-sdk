#import "ReadmeAction.h"
@import UIKit;

#warning In-App Message UI customization is not supported in Objective-C, see our Swift example instead.

NSString *const readme = @"In-App Message UI customization is not supported in Objective-C, see our Swift example instead.";
NSInteger const actionsCount = 0;
ReadmeAction const actions[] = {};

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
  [self.window makeKeyAndVisible];
  return YES;
}
@end
