#import "ABKCard.h"
#import "../BRZLog.h"
#import "ABKCard+Compat.h"
#import "ABKFeedController+Compat.h"

@import BrazeKit;

@implementation ABKCard

- (NSString *)idString {
  return self.card.identifier;
}

- (BOOL)viewed {
  return self.card.viewed;
}

- (void)setViewed:(BOOL)viewed {
  self.card.viewed = viewed;
}

- (double)created {
  return self.card.created;
}

- (double)updated {
  return self.card.updated;
}

- (ABKCardCategory)categories {
  return [ABKFeedController abkCategoriesWith:self.card.categories];
}

- (void)setCategories:(ABKCardCategory)categories {
  self.card.categories = [ABKFeedController brzCategoriesWith:categories];
}

- (double)expiresAt {
  return self.card.expires;
}

- (NSDictionary *)extras {
  return self.card.extras;
}

- (void)setExtras:(NSDictionary *)extras {
  self.card.extras = extras;
}

- (NSString *)urlString {
  return self.card.url.absoluteString;
}

- (void)setUrlString:(NSString *)urlString {
  self.card.url = [NSURL URLWithString:urlString];
}

- (BOOL)openUrlInWebView {
  return self.card.useWebView;
}

- (void)setOpenUrlInWebView:(BOOL)openUrlInWebView {
  self.card.useWebView = openUrlInWebView;
}

+ (ABKCard *)deserializeCardFromDictionary:(NSDictionary *)cardDictionary {
  LogUnimplemented();
  return nil;
}

- (NSData *)serializeToData {
  LogUnimplemented();
  return nil;
}

- (void)logCardImpression {
  [self.card.context logImpression];
}

- (void)logCardClicked {
  [self.card.context logClick];
}

- (BOOL)hasSameId:(ABKCard *)card {
  return [self.idString isEqualToString:card.idString];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
  LogUnimplemented();
  return [[ABKCard allocWithZone:zone] init];
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
  LogUnimplemented();
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
  LogUnimplemented();
  return nil;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _card = [[BRZNewsFeedCard alloc] init];
  }
  return self;
}

- (instancetype)initWithNewsFeedCard:(BRZNewsFeedCard *)card {
  self = [super init];
  if (self) {
    _card = card;
  }
  return self;
}

@end
