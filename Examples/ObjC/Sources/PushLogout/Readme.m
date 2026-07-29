#import "AppDelegate.h"
#import "ReadmeAction.h"
#import "ReadmeViewController.h"

@import BrazeKit;

#pragma mark - Internal

void enableSDK(void) {
  // Logout disables the SDK; re-enable it (e.g. on a new login) before re-registering.
  AppDelegate.braze.enabled = YES;
  NSLog(@"enableSDK: SDK enabled");
}

void registerPush(void) {
  // Logout disables the SDK; re-enable it before re-registering (e.g. on a new login).
  AppDelegate.braze.enabled = YES;
  [UIApplication.sharedApplication registerForRemoteNotifications];
  NSLog(@"registerPush: requested remote notification registration");
}

void unregisterPush(void) {
  [AppDelegate.braze.notifications
      unregisterPushWithCompletion:^(NSError *_Nullable error) {
        if (error) {
          NSLog(@"unregisterPush: failure - %@ (userInfo: %@)",
                error.localizedDescription, error.userInfo);
        } else {
          NSLog(@"unregisterPush: success");
        }
      }];
}

void logoutBraze(void) {
  [AppDelegate.braze logoutWithCompletion:^(NSError *_Nullable error) {
    if (error) {
      NSLog(@"logout: failure - %@ (userInfo: %@)", error.localizedDescription,
            error.userInfo);
    } else {
      // All local data is wiped and the SDK is disabled. Re-enable it via
      // `braze.enabled = YES` (e.g. when a new user logs in).
      NSLog(@"logout: success");
    }
  }];
}

void changeUser(NSString *userId) {
  NSString *trimmed = [userId
      stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
  if (trimmed.length == 0) {
    NSLog(@"changeUser: skipped - empty user ID");
    return;
  }
  [AppDelegate.braze changeUser:trimmed];
  NSLog(@"changeUser: %@", trimmed);
}

void showDeviceId(ReadmeViewController *viewController) {
  NSString *deviceId = AppDelegate.braze.deviceId;
  NSLog(@"deviceId: %@", deviceId);
  UIPasteboard.generalPasteboard.string = deviceId;
  UIAlertController *alert = [UIAlertController
      alertControllerWithTitle:@"Device ID"
                       message:[NSString stringWithFormat:@"%@\n\nCopied to clipboard.", deviceId]
                preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"Close"
                                            style:UIAlertActionStyleDefault
                                          handler:nil]];
  [viewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Readme

NSString *const readme =
    @"This sample demonstrates the Push Logout APIs, which unregister the device's push token"
    @" from the current user profile.\n"
    @"\n"
    @"Enter a user ID and tap \"Change user\" to switch the current user. Results are printed to"
    @" the console. On failure, the error's `isRetriable` userInfo entry indicates whether calling"
    @" the originating method again may succeed - the SDK never retries a failed unregistration on"
    @" its own.\n"
    @"\n"
    @"Live Activities push-to-start unregistration is available in Swift only, see the Swift"
    @" PushLogout example.\n"
    @"\n"
    @"See files:\n"
    @"- AppDelegate.{h,m}\n"
    @"  - Configure Braze, register for push\n"
    @"  - Add the \"Change user\" text field row\n"
    @"- Readme.m\n"
    @"  - Register / unregister push token\n"
    @"  - Logout\n"
    @"  - Change the current user\n"
    @"  - Show the SDK device ID";

NSInteger const actionsCount = 3;

ReadmeAction const actions[] = {
    {@"Unregister push", @"Remove the push token from the current user",
     ^(ReadmeViewController *_Nonnull _) { unregisterPush(); }},
    {@"Logout",
     @"Unregister the push token, then wipe local data and disable the SDK",
     ^(ReadmeViewController *_Nonnull viewController) {
       logoutBraze();
       [viewController clearTextFields];
     }},
    {@"Show device ID", @"Display and copy the SDK device identifier",
     ^(ReadmeViewController *_Nonnull viewController) { showDeviceId(viewController); }},
};
