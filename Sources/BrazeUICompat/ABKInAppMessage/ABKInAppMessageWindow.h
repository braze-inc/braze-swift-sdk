#import <UIKit/UIKit.h>

#if __has_include(<BrazeKitCompat/BrazePreprocessor.h>)
  #import <BrazeKitCompat/BrazePreprocessor.h>
#else
  #import "BrazePreprocessor.h"
#endif

/*!
 * ABKInAppMessageWindow handles a subset of all touches.
 *
 * By default, touches not handled by ABKInAppMessageWindow are automatically passed to the next
 * UIWindow in the view hierarchy by UIKit.
 */
BRZ_DEPRECATED("renamed to 'BrazeInAppMessageUI.Window'")
@interface ABKInAppMessageWindow : UIWindow

/*!
 * ABKInAppMessageWindow handles all touch events when enabled, no touch events are passed to a next
 * UIWindow.
 */
@property (nonatomic) BOOL handleAllTouchEvents;

@end
