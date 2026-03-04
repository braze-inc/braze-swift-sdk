#import "FullScreenBannerViewController.h"
#import "AppDelegate.h"

@implementation FullScreenBannerViewController

+ (NSString *)bannerPlacementID {
  return @"sdk-test-1";
}

- (UIActivityIndicatorView *)loadingView {
  if (!_loadingView) {
    _loadingView = [[UIActivityIndicatorView alloc] init];
    _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _loadingView;
}

- (BRZBannerUIView *)bannerView {
  if (AppDelegate.braze && !_bannerView) {
    __weak typeof(self) weakSelf = self;
    _bannerView = [[BRZBannerUIView alloc]
                   initWithPlacementId:[FullScreenBannerViewController bannerPlacementID]
                   braze:AppDelegate.braze
                   processContentUpdates:^(BrazeBannerUIContentUpdates * _Nullable updates,
                                           NSError * _Nullable error) {
      // Update layout properties when banner content has finished loading.
      dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        strongSelf.loadingView.hidden = YES;
        if (error) {
          strongSelf.errorView.hidden = NO;
        } else {
          strongSelf.bannerView.hidden = NO;
        }
      });
    }];
    
    _bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    _bannerView.hidden = YES;
  }
  return _bannerView;
}

- (UILabel *)errorView {
  if (!_errorView) {
    _errorView = [[UILabel alloc] init];
    _errorView.text = @"An error occurred while loading the banner.";
    _errorView.textAlignment = NSTextAlignmentCenter;
    _errorView.translatesAutoresizingMaskIntoConstraints = NO;
    _errorView.hidden = YES;
  }
  return _errorView;
}

- (void)loadView {
  [super loadView];
  
  self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.view addSubview:self.loadingView];
  [self.view addSubview:self.bannerView];
  [self.view addSubview:self.errorView];
  
  [NSLayoutConstraint activateConstraints:@[
    [self.loadingView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
    [self.loadingView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
    [self.loadingView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
    [self.loadingView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    
    [self.bannerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
    [self.bannerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
    [self.bannerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
    [self.bannerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    
    [self.errorView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
    [self.errorView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
    [self.errorView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
    [self.errorView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
  ]];
  
  [self.loadingView startAnimating];
}

@end
