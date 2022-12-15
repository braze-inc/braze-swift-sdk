#import "ABKContentCard.h"
#import "ABKContentCard+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKContentCard

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
  return self.card.createdAt;
}

- (BOOL)dismissible {
  return self.card.dismissible;
}

- (void)setDismissible:(BOOL)dismissible {
  self.card.dismissible = dismissible;
}

- (BOOL)pinned {
  return self.card.pinned;
}

- (void)setPinned:(BOOL)pinned {
  self.card.pinned = pinned;
}

- (BOOL)dismissed {
  // TODO: Rename removed to dismissed
  return self.card.removed;
}

- (void)setDismissed:(BOOL)dismissed {
  self.card.removed = dismissed;
}

- (BOOL)clicked {
  return self.card.clicked;
}

- (void)setClicked:(BOOL)clicked {
  self.card.clicked = clicked;
}

- (NSDictionary *)extras {
  return self.card.extras;
}

- (void)setExtras:(NSDictionary *)extras {
  if (extras == nil) {
    extras = @{};
  }
  self.card.extras = extras;
}

- (BOOL)isTest {
  return self.card.test;
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

+ (ABKContentCard *)deserializeCardFromDictionary:
    (NSDictionary *)cardDictionary {
  // TODO
  return nil;
}

- (NSData *)serializeToData {
  return [self.card json];
}

- (void)logContentCardImpression {
  self.card.viewed = YES;
  [self.card.context logImpression];
}

- (void)logContentCardClicked {
  [self.card.context logClick];
}

- (void)logContentCardDismissed {
  [self.card.context logDismissed];
}

- (BOOL)isControlCard {
  return self.card.type == BRZContentCardRawTypeControl;
}

- (BOOL)hasSameId:(ABKContentCard *)card {
  return self.idString == card.idString;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
  NSData *json = [self.card json];
  BRZContentCardRaw *card = [BRZContentCardRaw fromJson:json];
  return [[ABKContentCard allocWithZone:zone] initWithContentCard:card];
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
  [coder encodeDataObject:[self.card json]];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
  NSData *json = [coder decodeDataObject];
  BRZContentCardRaw *card = [BRZContentCardRaw fromJson:json];
  return [[ABKContentCard alloc] initWithContentCard:card];
}

- (BOOL)isEqual:(id)other {
  if (![other isKindOfClass:[ABKContentCard class]]) {
    return NO;
  }

  ABKContentCard *cardObject = (ABKContentCard *)other;
  return [self hasSameId:cardObject];
}

- (NSUInteger)hash {
  return [self.idString hash];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _card = [[BRZContentCardRaw alloc] init];
  }
  return self;
}

- (instancetype)initWithContentCard:(BRZContentCardRaw *)card {
  self = [super init];
  if (self) {
    _card = card;
  }
  return self;
}

@end

#pragma clang diagnostic pop
