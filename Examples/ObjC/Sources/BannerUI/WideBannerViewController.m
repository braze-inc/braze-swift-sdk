#import "WideBannerViewController.h"
#import "AppDelegate.h"

@implementation WideBannerViewController

+ (NSString *)bannerPlacementID {
  return @"sdk-test-2";
}

- (UILabel *)contentView {
  if (!_contentView) {
    _contentView = [[UILabel alloc] init];
    _contentView.text = @"Your Content Here";
    _contentView.textAlignment = NSTextAlignmentCenter;
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _contentView;
}

- (BRZBannerUIView *)bannerView {
  if (AppDelegate.braze && !_bannerView) {
    __weak typeof(self) weakSelf = self;
    _bannerView = [[BRZBannerUIView alloc]
                   initWithPlacementId:[WideBannerViewController bannerPlacementID]
                   braze:AppDelegate.braze
                   processContentUpdates:^(BrazeBannerUIContentUpdates * _Nullable updates,
                                           NSError * _Nullable error) {
      // Update layout properties when banner content has finished loading.
      dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        if (!error && updates.height) {
          CGFloat height = updates.height.floatValue;
          strongSelf.bannerView.hidden = NO;
          strongSelf.bannerHeightConstraint.constant = MIN(height, 80);
        }
      });
    }];
    
    _bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    _bannerView.hidden = YES;
  }
  return _bannerView;
}

- (void)loadView {
  [super loadView];
  
  self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.view addSubview:self.contentView];
  [self.view addSubview:self.bannerView];
  
  self.bannerHeightConstraint = [self.bannerView.heightAnchor constraintEqualToConstant:0];
  
  [NSLayoutConstraint activateConstraints:@[
    [self.contentView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
    [self.contentView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
    [self.contentView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
    
    [self.bannerView.topAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
    
    [self.bannerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
    [self.bannerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
    [self.bannerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    
    self.bannerHeightConstraint,
  ]];
}

@end
