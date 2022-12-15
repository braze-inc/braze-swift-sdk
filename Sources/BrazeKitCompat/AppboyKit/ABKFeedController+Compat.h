#import "ABKFeedController.h"

@class BRZNewsFeed;
@class BRZNewsFeedCardCategory;

@interface ABKFeedController ()

@property (strong, nonatomic) BRZNewsFeed *newsFeedApi;

- (instancetype)initWithNewsFeedApi:(BRZNewsFeed *)newsFeedApi;
+ (NSArray<BRZNewsFeedCardCategory *> *)brzCategoriesWith:(ABKCardCategory)categories;
+ (ABKCardCategory)abkCategoriesWith:(NSArray<BRZNewsFeedCardCategory *> *)categories;

@end
