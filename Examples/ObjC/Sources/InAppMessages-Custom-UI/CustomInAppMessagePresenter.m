#import "CustomInAppMessagePresenter.h"
#import "AppDelegate.h"
#import "InAppMessageInfoViewController.h"

@implementation CustomInAppMessagePresenter

- (void)presentMessage:(BRZInAppMessageRaw *)message {

  // BRZInAppMessageRaw is a compatibility representation of the In-App Message
  // type.

  // You can access the `extras` dictionary / `url`:

  NSLog(@"extras: %@", message.extras);
  NSLog(@"url: %@", message.url);

  // You can access message specific values.
  // - The value of `slideFrom` is irrelevant for non-slideup in-app messages.
  // - The value of `header` is irrelevant for non-modal/non-full in-app
  // messages.

  NSLog(@"slideFrom: %@", @(message.slideFrom));
  NSLog(@"header: %@", message.header);

  // A wrapper / compatibility representation of the in-app message is
  // accessible via `-json`
  NSData *jsonData = [message json];
  NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                               encoding:NSUTF8StringEncoding];
  if (jsonString != nil) {
    NSLog(@"%@", jsonString);
  }

  // Here, we present a custom view controller for the message

  InAppMessageInfoViewController *viewController =
      [[InAppMessageInfoViewController alloc] initWithMessage:message];
  UINavigationController *navigationController = [[UINavigationController alloc]
      initWithRootViewController:viewController];
  [UIApplication.sharedApplication.delegate.window.rootViewController
      presentViewController:navigationController
                   animated:YES
                 completion:nil];
}

@end
