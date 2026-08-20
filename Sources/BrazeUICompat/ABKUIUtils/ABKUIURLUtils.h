#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if __has_include(<BrazeKitCompat/BrazePreprocessor.h>)
  #import <BrazeKitCompat/BrazePreprocessor.h>
#else
  #import "BrazePreprocessor.h"
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

typedef NS_ENUM(NSInteger, ABKChannel);
@protocol ABKURLDelegate;

BRZ_DEPRECATED("use 'Braze.WebViewController' and 'BrazeDelegate' instead")
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
