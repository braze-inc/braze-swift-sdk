#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

typedef NS_ENUM(NSInteger, ABKChannel);
@protocol ABKURLDelegate;

@interface ABKUIURLUtils : NSObject

+ (BOOL)URLDelegate:(id<ABKURLDelegate>)urlDelegate
         handlesURL:(NSURL *)url
        fromChannel:(ABKChannel)channel
         withExtras:(NSDictionary *)extras;
+ (BOOL)URL:(NSURL *)url shouldOpenInWebView:(BOOL)openUrlInWebView;
+ (BOOL)URLHasSystemScheme:(NSURL *)url;
+ (void)openURLWithSystem:(NSURL *)url;
+ (UIViewController *)topmostViewControllerWithRootViewController:(UIViewController *)viewController;
+ (void)displayModalWebViewWithURL:(NSURL *)url
             topmostViewController:(UIViewController *)topmostViewController;
+ (NSURL *)getEncodedURIFromString:(NSString *)uriString;
@end

#pragma clang diagnostic pop
