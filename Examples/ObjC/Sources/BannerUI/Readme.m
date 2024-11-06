#import "AppDelegate.h"
#import "ReadmeAction.h"
#import "ReadmeViewController.h"

@import BrazeKit;

#pragma mark - Internal

void fullScreenBanner(ReadmeViewController *viewController) {
  [(AppDelegate *)UIApplication.sharedApplication
          .delegate displayFullScreenBanner];
}

void wideBanner(ReadmeViewController *viewController) {
  [(AppDelegate *)UIApplication.sharedApplication
          .delegate displayWideBanner];
}

#pragma mark - Readme

NSString *const readme =
    @"This sample presents how to use the Braze provided Banner UI:\n"
    @"\n"
    @"- AppDelegate.{h,m}\n"
    @"  - Requesting Banners refresh\n"
    @"  - Banner UI presentation\n";

NSInteger const actionsCount = 2;

ReadmeAction const actions[] = {
  { @"Display a full-screen banner", @"",
    ^(ReadmeViewController *_Nonnull viewController) {
      fullScreenBanner(viewController);
    }
  },
  { @"Display a wide banner", @"",
    ^(ReadmeViewController *_Nonnull viewController) {
      wideBanner(viewController);
    }
  },
}
;
