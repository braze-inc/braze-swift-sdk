#import <UIKit/UIKit.h>
#import "ABKNFBaseCardCell.h"
#if __has_include(<BrazeKitCompat/ABKFeedController.h>)
  #import <BrazeKitCompat/ABKFeedController.h>
#else
  #import "ABKFeedController.h"
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@class ABKCard;

@interface ABKNewsFeedTableViewController : UITableViewController <ABKBaseNewsFeedCellDelegate>

/*!
 * @discussion Initialization that is done for all ABKNewsFeedTableViewControllers with or without storyboard/XIB.
 */
- (void)setUp;

/*!
 * @discussion Initialization that is done for ABKNewsFeedTableViewControllers with programmatic layout only.
 */
- (void)setUpUI;

/*!
 * @discussion Registers Cell classes with the tableview, override this method when implementing custom
 * cell classes to register the new subclasses.
 */
- (void)registerTableViewCellClasses;

/*!
 * @param tableView The table view which need the cell to diplay the card UI.
 * @param indexPath The index path of the card UI in the table view.
 * @param card The card model for the cell.
 *
 * @discussion This method dequeues and returns the corresponding card cell based on card type from
 * the given table view.
 */
- (ABKNFBaseCardCell *)dequeueCellFromTableView:(UITableView *)tableView
                                   forIndexPath:(NSIndexPath *)indexPath
                                        forCard:(ABKCard *)card;

/*!
 * UI elements which are used in the News Feed table view. You can find them in the News Feed Card Storyboard.
 */
@property (nonatomic) IBOutlet UIView *emptyFeedView;
@property (nonatomic) IBOutlet UILabel *emptyFeedLabel;

/*!
 *  This property allows you to enable or disable the unread indicator on the news feed. The default
 *  value is NO, which will enable the displaying of the unread indicator on cards.
 */
@property (nonatomic) BOOL disableUnreadIndicator;

/*!
 * This property indicates which categories of cards the news feed is displaying.
 * Setting this property will automatically update the news feed page and only display cards in the given categories.
 * This method won't request refresh of cards from the Braze server, but only look into cards that are cached in the SDK.
 */
@property (nonatomic) ABKCardCategory categories;

/*!
 * This property shows the cards displayed in the News Feed. Please note that the News Feed view
 * controller listens to the ABKFeedUpdatedNotification notification from the Braze SDK, which will
 * update the value of this property.
 */
@property (nonatomic) NSArray<ABKCard *> *cards;

/*!
 * This set stores the card IDs for which the impressions have been logged.
 */
@property (nonatomic) NSMutableSet<NSString *> *cardImpressions;

/*!
 * This property defines the timeout for stored News Feed cards in the Braze SDK. If the cards in the
 * Braze SDK are older than this value, the News Feed view controller will request a News Feed update.
 *
 * The default value is 60 seconds.
 */
@property NSTimeInterval cacheTimeout;

@property id constraintWarningValue;

/*!
 * @discussion This method returns an instance of ABKNewsFeedTableViewController. You can call it
 * to get a News Feed view controller for your navigation controller.
 * @warning To use a custom News Feed view controller, instantiate your own subclass instead
 * (e.g. via alloc / init).
 */
+ (instancetype)getNavigationFeedViewController;

 /*!
  * @discussion Given a content card return the type identifier for the above
  * registration.
  */
 - (NSString *)findCellIdentifierWithCard:(ABKCard *)card;

/*!
 * @discussion This method returns the localized string from AppboyFeedLocalizable.strings file.
 * You can easily override the localized string by adding the keys and the translations to your own
 * Localizable.strings file.
 *
 * To do custom handling with the Appboy localized string, you can override this method in a
 * subclass.
 */
- (NSString *)localizedAppboyFeedString:(NSString *)key;

/*!
 * @discussion This method handles the user's click on the card.
 *
 * To do custom handling with the card clicks, you can override this method in a
 * subclass. You also need to call [card logCardClicked] manually inside of your new method
 * to send the click event to the Braze server.
 */
- (void)handleCardClick:(ABKCard *)card;

@end

#pragma clang diagnostic pop
