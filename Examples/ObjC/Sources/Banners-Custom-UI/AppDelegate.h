@import UIKit;
@import BrazeKit;

extern NSString *const brazeApiKey;
extern NSString *const brazeEndpoint;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(class, strong, nonatomic) Braze *braze;

- (void)displayBanner;
- (void)requestBannersRefresh;
- (void)getBanner;
- (void)subscribeToUpdates;
- (void)cancelSubscription;

@end
