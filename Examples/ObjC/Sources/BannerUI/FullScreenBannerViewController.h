@import UIKit;
@import BrazeUI;

@interface FullScreenBannerViewController : UIViewController

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) BRZBannerUIView *bannerView;
@property (nonatomic, strong) UILabel *errorView;

@end
