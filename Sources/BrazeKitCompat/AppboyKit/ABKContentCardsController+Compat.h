#import "ABKContentCardsController.h"

@class BRZContentCards;

@interface ABKContentCardsController ()

@property(strong, nonatomic) BRZContentCards *contentCardsApi;

- (instancetype)initWithContentCardsApi:(BRZContentCards *)contentCardsApi;

@end
