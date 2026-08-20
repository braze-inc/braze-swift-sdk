#import <UIKit/UIKit.h>
#import "ABKContentCardsTableViewController.h"

#if __has_include(<BrazeKitCompat/BrazePreprocessor.h>)
  #import <BrazeKitCompat/BrazePreprocessor.h>
#else
  #import "BrazePreprocessor.h"
#endif

BRZ_DEPRECATED("renamed to 'BrazeContentCardUI.ModalViewController'")
@interface ABKContentCardsViewController : UINavigationController

/*!
 * This property is the table view controller which displays all the content cards. It's also the root view
 * controller.
 */
@property (strong, nonatomic) ABKContentCardsTableViewController *contentCardsViewController;

@end
