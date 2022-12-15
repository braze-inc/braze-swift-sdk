#import "ABKClassicContentCard.h"
#import "ABKContentCard+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKClassicContentCard

- (NSString *)image {
  return self.card.image.absoluteString;
}

- (void)setImage:(NSString *)image {
  self.card.image = [NSURL URLWithString:image];
}

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

#pragma clang diagnostic pop
