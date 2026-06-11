@import UIKit;
@import BrazeKit;
@import WebKit;

@interface BannerViewController : UIViewController <BrazeBannerPlacement>

@property(strong, nonatomic) WKWebView *webView;
@property(strong, nonatomic) UIButton *dismissButton;
@property(strong, nonatomic) UIButton *logClickButton;
@property(strong, nonatomic) UILabel *errorLabel;
@property(strong, nonatomic) UIActivityIndicatorView *loadingView;

// BrazeBannerPlacement conformance
@property(copy, nonatomic) NSString *placementId;
@property(copy, nonatomic) void (^onDismiss)(BRZBannerDismissalEvent *event);

- (instancetype)initWithPlacementId:(NSString *)placementId;

// BrazeBannerPlacement required methods
- (void)renderWithBanner:(BRZBanner *)banner;
- (void)notifyError:(NSError *)error;
- (void)removeBannerContentWithReason:(BRZBannerRemovalReason)reason;

@end
