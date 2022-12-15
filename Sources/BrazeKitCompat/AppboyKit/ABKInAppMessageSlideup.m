#import "ABKInAppMessageSlideup.h"
#import "ABKInAppMessage+Compat.h"
#import "ABKInAppMessageSlideup+Compat.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKInAppMessageSlideup

- (BOOL)hideChevron {
  return self.inAppMessage._compat_hideChevron;
}

- (void)setHideChevron:(BOOL)hideChevron {
  self.inAppMessage._compat_hideChevron = hideChevron;
}

- (ABKInAppMessageSlideupAnchor)inAppMessageSlideupAnchor {
  return (ABKInAppMessageSlideupAnchor)self.inAppMessage.slideFrom;
}

- (void)setInAppMessageSlideupAnchor:
    (ABKInAppMessageSlideupAnchor)inAppMessageSlideupAnchor {
  self.inAppMessage.slideFrom =
      (BRZInAppMessageRawSlideFrom)inAppMessageSlideupAnchor;
}

- (UIColor *)chevronColor {
  return self.inAppMessage.closeButtonColor.uiColor;
}

- (void)setChevronColor:(UIColor *)chevronColor {
  self.inAppMessage.closeButtonColor =
      [[BRZInAppMessageRawColor alloc] init:chevronColor];
}

@end

#pragma clang diagnostic pop
