#import "ABKModalWebViewController.h"

#if !TARGET_OS_TV

@class BRZWebViewController;

@interface ABKModalWebViewController ()

@property(strong, nonnull) BRZWebViewController *webViewController;

@end

#endif
