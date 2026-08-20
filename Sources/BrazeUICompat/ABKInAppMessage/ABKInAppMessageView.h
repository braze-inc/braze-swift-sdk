#import <UIKit/UIKit.h>

#if __has_include(<BrazeKitCompat/BrazePreprocessor.h>)
  #import <BrazeKitCompat/BrazePreprocessor.h>
#else
  #import "BrazePreprocessor.h"
#endif

NS_ASSUME_NONNULL_BEGIN
BRZ_DEPRECATED("renamed to 'InAppMessageView'")
@interface ABKInAppMessageView : UIView
@end
NS_ASSUME_NONNULL_END
