#import "ABKClassicCard.h"
#import "ABKCard+Compat.h"
#import "ABKClassicCard+Compat.h"

@import BrazeKit;

@implementation ABKClassicCard

- (NSString *)image {
  return self.card.image.absoluteString;
}

- (void)setImage:(NSString *)image {
  self.card.image = [NSURL URLWithString:image];
}

- (NSString *)cardDescription {
  return self.card.cardDescription;
}

- (void)setCardDescription:(NSString *)cardDescription {
  self.card.cardDescription = cardDescription;
}

- (NSString *)title {
  return self.card.title;
}

- (void)setTitle:(NSString *)title {
  self.card.title = title;
}

- (NSString *)domain {
  return self.card.domain;
}

- (void)setDomain:(NSString *)domain {
  self.card.domain = domain;
}

@end
