#import "ABKContentCard.h"

@class BRZContentCardRaw;

@interface ABKContentCard ()

@property(strong, nonatomic) BRZContentCardRaw *card;

- (instancetype)initWithContentCard:(BRZContentCardRaw *)card;

@end
