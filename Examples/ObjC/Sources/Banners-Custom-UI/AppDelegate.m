#import "AppDelegate.h"
#import "BannerViewController.h"

@import BrazeKit;

static NSString *const bannerPlacementID = @"all";

@interface AppDelegate ()

// The subscription needs to be retained to remain active.
@property(strong, nonatomic) BRZCancellable *bannersSubscription;

@end

@implementation AppDelegate

#pragma mark - Lifecycle

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Setup Braze
  BRZConfiguration *configuration =
      [[BRZConfiguration alloc] initWithApiKey:brazeApiKey endpoint:brazeEndpoint];
  configuration.logger.level = BRZLoggerLevelInfo;
  Braze *braze = [[Braze alloc] initWithConfiguration:configuration];
  AppDelegate.braze = braze;

  // Request updated banners.
  [braze.banners requestBannersRefreshForPlacementIds:@[bannerPlacementID]];

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

#pragma mark - Displaying Banners

- (void)displayBanner {
  BannerViewController *viewController =
      [[BannerViewController alloc] initWithPlacementId:bannerPlacementID];
  UINavigationController *navigationController =
      (UINavigationController *)self.window.rootViewController;
  if (navigationController) {
    [navigationController pushViewController:viewController animated:YES];
  }
}

#pragma mark - Banners API

/// Requests an immediate refresh of banners and logs the result.
- (void)requestBannersRefresh {
  [AppDelegate.braze.banners
      requestBannersRefreshForPlacementIds:@[bannerPlacementID]
      completion:^(NSDictionary<NSString *, BRZBanner *> *_Nullable banners,
                   NSError *_Nullable error) {
        if (error) {
          NSLog(@"Banner refresh failed: %@", error);
        } else {
          NSLog(@"Banners refreshed: %@", banners.allKeys);
        }
      }];
}

/// Retrieves a banner from local cache and logs its properties.
- (void)getBanner {
  [AppDelegate.braze.banners
      getBannerFor:bannerPlacementID
      completion:^(BRZBanner *_Nullable banner) {
        if (!banner) {
          NSLog(@"No banner available for placement: %@", bannerPlacementID);
          return;
        }

        NSLog(@"Banner retrieved:");
        NSLog(@"  placementId: %@", banner.placementId);
        NSLog(@"  isControl: %d", banner.isControl);
        NSLog(@"  isTestSend: %d", banner.isTestSend);
        NSLog(@"  expiresAt: %ld", (long)banner.expiresAt);

        // Access typed properties set via the Braze dashboard.
        NSString *title = [banner stringPropertyForKey:@"title"];
        if (title) NSLog(@"  title: %@", title);

        NSString *imageURL = [banner imagePropertyForKey:@"image"];
        if (imageURL) NSLog(@"  image: %@", imageURL);
      }];
}

/// Subscribes to banner updates. Fires immediately if banners have already been synced this
/// session, and again on every subsequent server sync.
- (void)subscribeToUpdates {
  self.bannersSubscription = [AppDelegate.braze.banners
      subscribeToUpdates:^(NSDictionary<NSString *, BRZBanner *> *_Nonnull banners) {
        NSLog(@"Banner update — placements: %@", [banners.allKeys sortedArrayUsingSelector:@selector(compare:)]);

        BRZBanner *banner = banners[bannerPlacementID];
        if (banner) {
          NSLog(@"  %@: isControl=%d", banner.placementId, banner.isControl);
        }
      }];
}

/// Cancels the active banner subscription.
- (void)cancelSubscription {
  [self.bannersSubscription cancel];
  self.bannersSubscription = nil;
  NSLog(@"Banner subscription cancelled.");
}

@end
