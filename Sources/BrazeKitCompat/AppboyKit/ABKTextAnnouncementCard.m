#import "ABKTextAnnouncementCard.h"
#import "ABKCard+Compat.h"
#import "ABKTextAnnouncementCard+Compat.h"

@import BrazeKit;

@implementation ABKTextAnnouncementCard

- (NSString *)title {
  return self.card.title;
}

- (void)setTitle:(NSString *)title {
  self.card.title = title;
}

- (NSString *)cardDescription {
  return self.card.cardDescription;
}

- (void)setCardDescription:(NSString *)cardDescription {
  self.card.cardDescription = cardDescription;
}

- (NSString *)domain {
  return self.card.domain;
}

- (void)setDomain:(NSString *)domain {
  self.card.domain = domain;
}

@end
