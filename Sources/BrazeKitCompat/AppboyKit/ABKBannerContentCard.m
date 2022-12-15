#import "ABKBannerContentCard.h"
#import "ABKContentCard+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKBannerContentCard

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

@end

#pragma clang diagnostic pop
