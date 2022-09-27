#import "AppDelegate.h"

@import UIKit;

int main(int argc, char *argv[]) {
  NSString *appDelegateClassName;
  @autoreleasepool {
    appDelegateClassName = NSStringFromClass([AppDelegate class]);
  }
  return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
