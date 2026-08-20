#import "ABKInAppMessageImmersiveViewController.h"

#if __has_include(<BrazeKitCompat/BrazePreprocessor.h>)
  #import <BrazeKitCompat/BrazePreprocessor.h>
#else
  #import "BrazePreprocessor.h"
#endif

NS_ASSUME_NONNULL_BEGIN
BRZ_DEPRECATED("renamed to 'BrazeInAppMessageUI.FullView'")
@interface ABKInAppMessageFullViewController : ABKInAppMessageImmersiveViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeXButtonTopConstraint;

@end
NS_ASSUME_NONNULL_END
