#import "AppDelegate.h"
#import "ReadmeAction.h"
#import "ReadmeViewController.h"

@import BrazeKit;

#pragma mark - Internal

void displayBanner(ReadmeViewController *viewController) {
  [(AppDelegate *)UIApplication.sharedApplication.delegate displayBanner];
}

void requestBannersRefresh(ReadmeViewController *viewController) {
  [(AppDelegate *)UIApplication.sharedApplication.delegate requestBannersRefresh];
}

void getBanner(ReadmeViewController *viewController) {
  [(AppDelegate *)UIApplication.sharedApplication.delegate getBanner];
}

void subscribeToUpdates(ReadmeViewController *viewController) {
  [(AppDelegate *)UIApplication.sharedApplication.delegate subscribeToUpdates];
}

void cancelSubscription(ReadmeViewController *viewController) {
  [(AppDelegate *)UIApplication.sharedApplication.delegate cancelSubscription];
}

#pragma mark - Readme

NSString *const readme =
    @"This sample demonstrates how to implement a custom Banner UI using BrazeKit only,\n"
    @"without BrazeUI:\n"
    @"\n"
    @"- AppDelegate.{h,m}:\n"
    @"  - Requesting a Banners refresh (with and without a completion handler)\n"
    @"  - Retrieving a cached banner via getBannerFor:completion:\n"
    @"  - Subscribing to and cancelling banner updates via subscribeToUpdates:\n"
    @"- BannerViewController.{h,m}:\n"
    @"  - Rendering banner HTML in a WKWebView\n"
    @"  - Logging impressions via logImpressionUsing:\n"
    @"  - Logging clicks via logClickWithButtonId:using: and WKNavigationDelegate\n"
    @"  - Dismissing a banner via [banner.context dismiss]\n"
    @"  - Subscribing to live updates so the view re-renders on new content\n";

NSInteger const actionsCount = 5;

ReadmeAction const actions[] = {
  { @"Display banner",
    @"",
    ^(ReadmeViewController *_Nonnull viewController) { displayBanner(viewController); }
  },
  { @"Request banners refresh",
    @"",
    ^(ReadmeViewController *_Nonnull viewController) { requestBannersRefresh(viewController); }
  },
  { @"Get banner (cached)",
    @"",
    ^(ReadmeViewController *_Nonnull viewController) { getBanner(viewController); }
  },
  { @"Subscribe to banner updates",
    @"",
    ^(ReadmeViewController *_Nonnull viewController) { subscribeToUpdates(viewController); }
  },
  { @"Cancel banner subscription",
    @"",
    ^(ReadmeViewController *_Nonnull viewController) { cancelSubscription(viewController); }
  },
};
