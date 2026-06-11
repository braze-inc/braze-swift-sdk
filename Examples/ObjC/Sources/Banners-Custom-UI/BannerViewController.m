#import "BannerViewController.h"
#import "AppDelegate.h"

@import BrazeKit;
@import WebKit;

@interface BannerViewController () <WKNavigationDelegate>

// Retained to keep the live update subscription active for this screen.
@property(strong, nonatomic) BRZCancellable *subscription;

@property(strong, nonatomic) BRZBanner *banner;
@property(assign, nonatomic) BOOL hasLoggedImpression;

@end

@implementation BannerViewController

#pragma mark - Init

- (instancetype)initWithPlacementId:(NSString *)placementId {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _placementId = [placementId copy];
  }
  return self;
}

#pragma mark - Lazy Properties

- (WKWebView *)webView {
  if (!_webView) {
    _webView = [[WKWebView alloc] init];
    _webView.navigationDelegate = self;
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    _webView.hidden = YES;
  }
  return _webView;
}

- (UIButton *)dismissButton {
  if (!_dismissButton) {
    _dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_dismissButton setTitle:@"Dismiss Banner" forState:UIControlStateNormal];
    [_dismissButton addTarget:self
                       action:@selector(dismissBanner)
             forControlEvents:UIControlEventTouchUpInside];
    _dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    _dismissButton.hidden = YES;
  }
  return _dismissButton;
}

- (UIButton *)logClickButton {
  if (!_logClickButton) {
    _logClickButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_logClickButton setTitle:@"Log Click" forState:UIControlStateNormal];
    [_logClickButton addTarget:self
                        action:@selector(logBannerClick)
              forControlEvents:UIControlEventTouchUpInside];
    _logClickButton.translatesAutoresizingMaskIntoConstraints = NO;
    _logClickButton.hidden = YES;
  }
  return _logClickButton;
}

- (UILabel *)errorLabel {
  if (!_errorLabel) {
    _errorLabel = [[UILabel alloc] init];
    _errorLabel.text = @"No banner available for this placement.";
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.numberOfLines = 0;
    _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _errorLabel.hidden = YES;
  }
  return _errorLabel;
}

- (UIActivityIndicatorView *)loadingView {
  if (!_loadingView) {
#if TARGET_OS_VISION
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
#else
    if (@available(iOS 13.0, *)) {
      _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    } else {
      _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
#endif
    _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _loadingView;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = UIColor.whiteColor;
  self.title = @"Custom Banner";
  [self setupLayout];
  [self.loadingView startAnimating];

  __weak typeof(self) weakSelf = self;

  // Subscribe to live updates so the view re-renders when new content arrives from the server.
  self.subscription = [AppDelegate.braze.banners
      subscribeToUpdates:^(NSDictionary<NSString *, BRZBanner *> *_Nonnull banners) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;

        BRZBanner *banner = banners[strongSelf.placementId];
        if (banner) {
          [strongSelf renderBanner:banner];
        } else {
          [strongSelf showError];
        }
      }];

  // Fetch the currently cached banner immediately — subscribeToUpdates handles the rest.
  [AppDelegate.braze.banners
      getBannerFor:self.placementId
      completion:^(BRZBanner *_Nullable banner) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || !banner) return;
        [strongSelf renderBanner:banner];
      }];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self logImpression];
}

#pragma mark - BrazeBannerPlacement

- (void)renderWithBanner:(BRZBanner *)banner {
  [self renderBanner:banner];
}

- (void)notifyError:(NSError *)error {
  [self showError];
}

- (void)removeBannerContentWithReason:(BRZBannerRemovalReason)reason {
  [self showError];
}

#pragma mark - Banner Rendering

- (void)renderBanner:(BRZBanner *)banner {
  self.banner = banner;

  // Control banners should be tracked but have no HTML to display.
  if (banner.isControl) {
    [self logImpression];
    [self showError];
    return;
  }

  [self.loadingView stopAnimating];
  self.webView.hidden = NO;
  self.dismissButton.hidden = NO;
  self.logClickButton.hidden = NO;
  self.errorLabel.hidden = YES;

  [self.webView loadHTMLString:banner.html baseURL:nil];

  // Log impression once the banner content has been set and the view is visible.
  if (self.isViewLoaded && self.view.window) {
    [self logImpression];
  }
}

- (void)showError {
  [self.loadingView stopAnimating];
  self.webView.hidden = YES;
  self.dismissButton.hidden = YES;
  self.logClickButton.hidden = YES;
  self.errorLabel.hidden = NO;
}

#pragma mark - Analytics

- (void)logImpression {
  // The SDK deduplicates impressions per session, but we guard locally to avoid the warning.
  if (self.hasLoggedImpression || !self.banner || !AppDelegate.braze) return;
  self.hasLoggedImpression = YES;
  [self.banner logImpressionUsing:AppDelegate.braze];
}

/// Dismiss the banner via its context when available — handles idempotency and fires the
/// SDK's onDismiss callback. Falls back to the top-level dismissUsing: otherwise.
/// The onDismiss closure (from BrazeBannerPlacement conformance) is automatically invoked
/// by the SDK with dismissal event details when the banner is dismissed.
- (void)dismissBanner {
  if (self.banner.context) {
    [self.banner.context dismiss];
  } else if (self.banner && AppDelegate.braze) {
    [self.banner dismissUsing:AppDelegate.braze];
  }
  [self removeBannerContentWithReason:BRZBannerRemovalReasonDismissal];
  [self.navigationController popViewControllerAnimated:YES];
}

/// Logs a manual click event on the banner (e.g. from a custom tap target in your UI).
/// Pass a buttonId to associate the click with a specific button defined in the dashboard.
- (void)logBannerClick {
  if (!self.banner || !AppDelegate.braze) return;
  [self.banner logClickWithButtonId:nil using:AppDelegate.braze];
  NSLog(@"Logged click for banner: %@", self.banner.placementId);
}

#pragma mark - Layout

- (void)setupLayout {
  [self.view addSubview:self.webView];
  [self.view addSubview:self.dismissButton];
  [self.view addSubview:self.logClickButton];
  [self.view addSubview:self.errorLabel];
  [self.view addSubview:self.loadingView];

  [NSLayoutConstraint activateConstraints:@[
    [self.webView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
    [self.webView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
    [self.webView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
    [self.webView.bottomAnchor constraintEqualToAnchor:self.dismissButton.topAnchor constant:-12],

    [self.dismissButton.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:16],
    [self.dismissButton.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-16],
    [self.dismissButton.bottomAnchor constraintEqualToAnchor:self.logClickButton.topAnchor constant:-8],

    [self.logClickButton.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:16],
    [self.logClickButton.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-16],
    [self.logClickButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-16],

    [self.errorLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    [self.errorLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    [self.errorLabel.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:16],
    [self.errorLabel.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-16],

    [self.loadingView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    [self.loadingView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
  ]];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView
    didFinishNavigation:(WKNavigation *)navigation {
  // No-op: impression is logged in renderBanner: / viewDidAppear:.
}

- (void)webView:(WKWebView *)webView
    decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                    decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  // Intercept link taps to log a click event, then let the SDK handle URL navigation.
  if (navigationAction.navigationType == WKNavigationTypeLinkActivated
      && navigationAction.request.URL
      && self.banner
      && AppDelegate.braze) {
    [self.banner logClickWithButtonId:nil using:AppDelegate.braze];
    // Open the URL via UIApplication — BRZBannerContext.processClickAction is Swift-only.
    [[UIApplication sharedApplication] openURL:navigationAction.request.URL
                                       options:@{}
                             completionHandler:nil];
    decisionHandler(WKNavigationActionPolicyCancel);
    return;
  }
  decisionHandler(WKNavigationActionPolicyAllow);
}

@end
