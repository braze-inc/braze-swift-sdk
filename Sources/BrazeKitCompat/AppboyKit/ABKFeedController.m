#import "ABKFeedController.h"
#import "../BRZLog.h"
#import "ABKBannerCard.h"
#import "ABKCaptionedImageCard.h"
#import "ABKCard+Compat.h"
#import "ABKClassicCard.h"
#import "ABKFeedController+Compat.h"
#import "ABKTextAnnouncementCard.h"

@import BrazeKit;

NSString *const ABKFeedUpdatedNotification = @"feedUpdatedNotification";
NSString *const ABKFeedUpdatedIsSuccessfulKey = @"isSuccessful";

@implementation ABKFeedController

- (NSArray *)getNewsFeedCards {
  NSMutableArray *abkCards = [NSMutableArray array];
  for (BRZNewsFeedCard *card in self.newsFeedApi.cards) {
    ABKCard *abkCard;
    switch (card.type) {
    case BRZNewsFeedCardTypeClassic:
      abkCard = [[ABKClassicCard alloc] initWithNewsFeedCard:card];
      break;
    case BRZNewsFeedCardTypeBanner:
      abkCard = [[ABKBannerCard alloc] initWithNewsFeedCard:card];
      break;
    case BRZNewsFeedCardTypeCaptionedImage:
      abkCard = [[ABKCaptionedImageCard alloc] initWithNewsFeedCard:card];
      break;
    case BRZNewsFeedCardTypeTextAnnouncement:
      abkCard = [[ABKTextAnnouncementCard alloc] initWithNewsFeedCard:card];
      break;
    default:
      abkCard = [[ABKCard alloc] initWithNewsFeedCard:card];
      break;
    }
    [abkCards addObject:abkCard];
  }
  return [abkCards copy];
}

- (NSDate *)lastUpdate {
  return self.newsFeedApi.lastUpdate;
}

- (NSInteger)unreadCardCountForCategories:(ABKCardCategory)categories {
  NSArray<BRZNewsFeedCardCategory *> *brzCategories =
      [ABKFeedController brzCategoriesWith:categories];
  NSInteger unread = 0;
  for (BRZNewsFeedCard *card in self.newsFeedApi.cards) {
    if (card.viewed) {
      continue;
    }
    for (BRZNewsFeedCardCategory *category in card.categories) {
      if ([brzCategories containsObject:category]) {
        unread += 1;
        break;
      }
    }
  }
  return unread;
}

- (NSInteger)cardCountForCategories:(ABKCardCategory)categories {
  return [self getCardsInCategories:categories].count;
}

- (NSArray *)getCardsInCategories:(ABKCardCategory)categories {
  if (categories == ABKCardCategoryAll) {
    return [self getNewsFeedCards];
  }

  NSMutableArray *cards = [NSMutableArray array];
  for (ABKCard *card in [self getNewsFeedCards]) {
    if (card.categories & categories) {
      [cards addObject:card];
    }
  }
  return cards;
}

- (instancetype)initWithNewsFeedApi:(BRZNewsFeed *)newsFeedApi {
  self = [super init];
  if (self) {
    _newsFeedApi = newsFeedApi;
  }
  return self;
}

+ (NSArray<BRZNewsFeedCardCategory *> *)brzCategoriesWith:
    (ABKCardCategory)categories {
  NSMutableArray *brzCategories = [NSMutableArray array];

  if (categories & ABKCardCategoryNoCategory) {
    [brzCategories addObject:BRZNewsFeedCardCategory.none];
  }

  if (categories & ABKCardCategoryNews) {
    [brzCategories addObject:BRZNewsFeedCardCategory.news];
  }

  if (categories & ABKCardCategoryAdvertising) {
    [brzCategories addObject:BRZNewsFeedCardCategory.advertising];
  }

  if (categories & ABKCardCategoryAnnouncements) {
    [brzCategories addObject:BRZNewsFeedCardCategory.announcements];
  }

  if (categories & ABKCardCategorySocial) {
    [brzCategories addObject:BRZNewsFeedCardCategory.social];
  }

  return brzCategories;
}

+ (ABKCardCategory)abkCategoriesWith:
    (NSArray<BRZNewsFeedCardCategory *> *)categories {
  ABKCardCategory abkCategories = 0;

  if ([categories containsObject:BRZNewsFeedCardCategory.none]) {
    abkCategories |= ABKCardCategoryNoCategory;
  }

  if ([categories containsObject:BRZNewsFeedCardCategory.news]) {
    abkCategories |= ABKCardCategoryNews;
  }

  if ([categories containsObject:BRZNewsFeedCardCategory.advertising]) {
    abkCategories |= ABKCardCategoryAdvertising;
  }

  if ([categories containsObject:BRZNewsFeedCardCategory.announcements]) {
    abkCategories |= ABKCardCategoryAnnouncements;
  }

  if ([categories containsObject:BRZNewsFeedCardCategory.social]) {
    abkCategories |= ABKCardCategorySocial;
  }

  return abkCategories;
}

@end
