#import "ABKCard.h"

@class BRZNewsFeedCard;

@interface ABKCard ()

@property (strong, nonatomic) BRZNewsFeedCard *card;

- (instancetype)initWithNewsFeedCard:(BRZNewsFeedCard *)card;

@end
