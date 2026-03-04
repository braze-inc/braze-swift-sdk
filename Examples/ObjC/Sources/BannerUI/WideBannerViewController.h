@import UIKit;
@import BrazeUI;

@interface WideBannerViewController : UIViewController

@property (nonatomic, strong) UILabel *contentView;
@property (nonatomic, strong) BRZBannerUIView *bannerView;
@property (nonatomic, strong) NSLayoutConstraint *bannerHeightConstraint;

@end
