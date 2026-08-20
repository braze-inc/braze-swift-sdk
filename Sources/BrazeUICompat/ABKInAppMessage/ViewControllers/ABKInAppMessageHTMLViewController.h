#import <UIKit/UIKit.h>
#import "ABKInAppMessageHTMLBaseViewController.h"

#if __has_include(<BrazeKitCompat/BrazePreprocessor.h>)
  #import <BrazeKitCompat/BrazePreprocessor.h>
#else
  #import "BrazePreprocessor.h"
#endif

NS_ASSUME_NONNULL_BEGIN

BRZ_DEPRECATED("renamed to 'BrazeInAppMessageUI.HtmlView'")
@interface ABKInAppMessageHTMLViewController : ABKInAppMessageHTMLBaseViewController


@end
NS_ASSUME_NONNULL_END
