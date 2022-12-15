#import "ABKCaptionedImageCard.h"
#import "ABKCaptionedImageCard+Compat.h"
#import "ABKCard+Compat.h"

@import BrazeKit;

@implementation ABKCaptionedImageCard

- (NSString *)image {
  return self.card.image.absoluteString;
}

- (void)setImage:(NSString *)image {
  self.card.image = [NSURL URLWithString:image];
}

- (float)imageAspectRatio {
  return self.card.imageAspectRatio;
}

- (void)setImageAspectRatio:(float)imageAspectRatio {
  self.card.imageAspectRatio = imageAspectRatio;
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
