#import "ABKInAppMessageDarkButtonTheme.h"
#import "../BRZLog.h"
#import "ABKInAppMessageDarkButtonTheme+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKInAppMessageDarkButtonTheme

- (UIColor *)buttonBackgroundColor {
  return self.theme.backgroundColor.uiColor;
}

- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor {
  self.theme.backgroundColor =
      [[BRZInAppMessageRawColor alloc] init:buttonBackgroundColor];
}

- (UIColor *)buttonBorderColor {
  return self.theme.borderColor.uiColor;
}

- (void)setButtonBorderColor:(UIColor *)buttonBorderColor {
  self.theme.borderColor =
      [[BRZInAppMessageRawColor alloc] init:buttonBorderColor];
}

- (UIColor *)buttonTextColor {
  return self.theme.textColor.uiColor;
}

- (void)setButtonTextColor:(UIColor *)buttonTextColor {
  self.theme.textColor = [[BRZInAppMessageRawColor alloc] init:buttonTextColor];
}

- (instancetype)initWithFields:(NSDictionary *)darkButtonFields {
  LogUnimplemented();
  return nil;
}

- (instancetype)initWithTheme:(BRZInAppMessageRawButtonTheme *)theme {
  self = [super init];
  if (self) {
    _theme = theme;
  }
  return self;
}

@end

#pragma clang diagnostic pop
