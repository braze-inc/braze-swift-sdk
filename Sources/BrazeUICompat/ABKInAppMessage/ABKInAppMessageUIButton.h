#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@class ABKInAppMessageButton;

NS_ASSUME_NONNULL_BEGIN
@interface ABKInAppMessageUIButton : UIButton

/*!
 * The model object for the UIButton.
 */
@property ABKInAppMessageButton *inAppButtonModel;

@end
NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
