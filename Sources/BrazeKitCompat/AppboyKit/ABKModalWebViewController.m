#import "ABKModalWebViewController.h"
#import "../BRZLog.h"
#import "ABKModalWebViewController+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

#if !TARGET_OS_TV

@import BrazeKit;

@implementation ABKModalWebViewController

- (NSURL *)url {
  return self.webViewController.url;
}

- (void)setUrl:(NSURL *)url {
  self.webViewController.url = url;
}

- (WKWebView *)webView {
  LogUnimplemented();
  return nil;
}

- (void)setWebView:(WKWebView *)webView {
  LogUnimplemented();
}

- (UIProgressView *)progressBar {
  LogUnimplemented();
  return nil;
}

- (void)setProgressBar:(UIProgressView *)progressBar {
  LogUnimplemented();
}

- (instancetype)init {
  BRZWebViewController *webViewController = [[BRZWebViewController alloc] init];
  self = [super initWithRootViewController:webViewController];
  if (self) {
    _webViewController = webViewController;
  }
  return self;
}

@end

#endif

#pragma clang diagnostic pop
