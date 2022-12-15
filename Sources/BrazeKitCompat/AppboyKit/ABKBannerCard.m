#import "ABKBannerCard.h"
#import "ABKBannerCard+Compat.h"
#import "ABKCard+Compat.h"

@import BrazeKit;

@implementation ABKBannerCard

- (NSString *)image {
  return self.card.image.absoluteString;
}

- (void)setImage:(NSString *)image {
  self.card.image = [NSURL URLWithString:image];
}

- (NSString *)domain {
  return self.card.domain;
}

- (void)setDomain:(NSString *)domain {
  self.card.domain = domain;
}

- (float)imageAspectRatio {
  return self.card.imageAspectRatio;
}

- (void)setImageAspectRatio:(float)imageAspectRatio {
  self.card.imageAspectRatio = imageAspectRatio;
}

@end
