#import "ABKContentCardsController.h"
#import "ABKBannerContentCard.h"
#import "ABKCaptionedImageContentCard.h"
#import "ABKClassicContentCard.h"
#import "ABKContentCard+Compat.h"
#import "ABKContentCardsController+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

NSString *const ABKContentCardsProcessedNotification =
    @"contentCardsProcessedNotification";
NSString *const ABKContentCardsProcessedIsSuccessfulKey = @"isSuccessful";

@implementation ABKContentCardsController

- (NSArray *)getContentCards {
  NSMutableArray *abkCards = [NSMutableArray array];
  for (BRZContentCardRaw *card in self.contentCardsApi.cards) {
    ABKContentCard *abkCard;
    switch (card.type) {
    case BRZContentCardRawTypeClassic:
      abkCard = [[ABKClassicContentCard alloc] initWithContentCard:card];
      break;
    case BRZContentCardRawTypeBanner:
      abkCard = [[ABKBannerContentCard alloc] initWithContentCard:card];
      break;
    case BRZContentCardRawTypeCaptionedImage:
      abkCard = [[ABKCaptionedImageContentCard alloc] initWithContentCard:card];
      break;
    case BRZContentCardRawTypeControl:
      abkCard = [[ABKContentCard alloc] initWithContentCard:card];
      break;
    default:
      abkCard = [[ABKContentCard alloc] initWithContentCard:card];
      break;
    }
    [abkCards addObject:abkCard];
  }
  return [abkCards copy];
}

- (NSDate *)lastUpdate {
  return self.contentCardsApi.lastUpdate;
}

- (NSInteger)unviewedContentCardCount {
  NSInteger unviewed = 0;
  for (BRZContentCardRaw *card in self.contentCardsApi.cards) {
    if (!card.viewed && card.type != BRZContentCardRawTypeControl) {
      unviewed += 1;
    }
  }
  return unviewed;
}

- (NSInteger)contentCardCount {
  return self.contentCardsApi.cards.count;
}

- (instancetype)initWithContentCardsApi:(BRZContentCards *)contentCardsApi {
  self = [super init];
  if (self) {
    _contentCardsApi = contentCardsApi;
  }
  return self;
}

@end

#pragma clang diagnostic pop
