#import "ABKInAppMessageDarkTheme.h"
#import "../BRZLog.h"
#import "ABKInAppMessageDarkButtonTheme+Compat.h"
#import "ABKInAppMessageDarkTheme+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKInAppMessageDarkTheme

- (UIColor *)backgroundColor {
  return self.theme.backgroundColor.uiColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  self.theme.backgroundColor =
      [[BRZInAppMessageRawColor alloc] init:backgroundColor];
}

- (UIColor *)textColor {
  return self.theme.textColor.uiColor;
}

- (void)setTextColor:(UIColor *)textColor {
  self.theme.textColor = [[BRZInAppMessageRawColor alloc] init:textColor];
}

- (UIColor *)iconColor {
  return self.theme.iconColor.uiColor;
}

- (void)setIconColor:(UIColor *)iconColor {
  self.theme.iconColor = [[BRZInAppMessageRawColor alloc] init:iconColor];
}

- (UIColor *)headerTextColor {
  return self.theme.headerTextColor.uiColor;
}

- (void)setHeaderTextColor:(UIColor *)headerTextColor {
  self.theme.headerTextColor =
      [[BRZInAppMessageRawColor alloc] init:headerTextColor];
}

- (UIColor *)closeButtonColor {
  return self.theme.closeButtonColor.uiColor;
}

- (void)setCloseButtonColor:(UIColor *)closeButtonColor {
  self.theme.closeButtonColor =
      [[BRZInAppMessageRawColor alloc] init:closeButtonColor];
}

- (UIColor *)frameColor {
  return self.theme.frameColor.uiColor;
}

- (void)setFrameColor:(UIColor *)frameColor {
  self.theme.frameColor = [[BRZInAppMessageRawColor alloc] init:frameColor];
}

- (NSArray<ABKInAppMessageDarkButtonTheme *> *)buttons {
  NSMutableArray *buttons = [NSMutableArray array];
  for (BRZInAppMessageRawButtonTheme *theme in self.theme.buttons) {
    [buttons
        addObject:[[ABKInAppMessageDarkButtonTheme alloc] initWithTheme:theme]];
  }
  return [buttons copy];
}

- (void)setButtons:(NSArray<ABKInAppMessageDarkButtonTheme *> *)buttons {
  NSMutableArray *buttonThemes = [NSMutableArray array];
  for (ABKInAppMessageDarkButtonTheme *theme in buttons) {
    [buttonThemes addObject:theme.theme];
  }
  self.theme.buttons = [buttonThemes copy];
}

- (instancetype)initWithFields:
    (NSDictionary<NSString *, NSString *> *)darkThemeFields {
  LogUnimplemented();
  return nil;
}

- (UIColor *)getColorForKey:(NSString *)key {
  LogUnimplemented();
  return nil;
}

- (instancetype)initWithTheme:(BRZInAppMessageRawTheme *)theme {
  self = [super init];
  if (self) {
    _theme = theme;
  }
  return self;
}

@end

#pragma clang diagnostic pop
