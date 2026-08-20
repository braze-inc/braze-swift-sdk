#import <UIKit/UIKit.h>

#if __has_include(<BrazeKitCompat/BrazePreprocessor.h>)
  #import <BrazeKitCompat/BrazePreprocessor.h>
#else
  #import "BrazePreprocessor.h"
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@class ABKInAppMessageButton;

NS_ASSUME_NONNULL_BEGIN
BRZ_DEPRECATED("renamed to 'BrazeInAppMessageUI.ButtonView'")
@interface ABKInAppMessageUIButton : UIButton

/*!
 * The model object for the UIButton.
 */
@property ABKInAppMessageButton *inAppButtonModel;

@end
NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
