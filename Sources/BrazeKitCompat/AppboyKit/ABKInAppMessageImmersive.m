#import "ABKInAppMessageImmersive.h"
#import "ABKInAppMessage+Compat.h"
#import "ABKInAppMessageButton+Compat.h"
#import "ABKInAppMessageImmersive+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKInAppMessageImmersive

- (NSString *)header {
  return self.inAppMessage.header;
}

- (void)setHeader:(NSString *)header {
  self.inAppMessage.header = header;
}

- (UIColor *)headerTextColor {
  return self.inAppMessage.headerTextColor.uiColor;
}

- (void)setHeaderTextColor:(UIColor *)headerTextColor {
  self.inAppMessage.headerTextColor =
      [[BRZInAppMessageRawColor alloc] init:headerTextColor];
}

- (UIColor *)closeButtonColor {
  return self.inAppMessage.closeButtonColor.uiColor;
}

- (void)setCloseButtonColor:(UIColor *)closeButtonColor {
  self.inAppMessage.closeButtonColor =
      [[BRZInAppMessageRawColor alloc] init:closeButtonColor];
}

- (NSArray<ABKInAppMessageButton *> *)buttons {
  NSMutableArray *buttons = [NSMutableArray array];
  for (BRZInAppMessageRawButton *button in self.inAppMessage.buttons) {
    [buttons addObject:[[ABKInAppMessageButton alloc] initWithButton:button]];
  }
  return [buttons copy];
}

- (UIColor *)frameColor {
  return self.inAppMessage.frameColor.uiColor;
}

- (void)setFrameColor:(UIColor *)frameColor {
  self.inAppMessage.frameColor =
      [[BRZInAppMessageRawColor alloc] init:frameColor];
}

- (NSTextAlignment)headerTextAlignment {
  BOOL leftToRight =
      [UIApplication sharedApplication].userInterfaceLayoutDirection ==
      UIUserInterfaceLayoutDirectionLeftToRight;
  switch (self.inAppMessage.headerTextAlignment) {
  case BRZInAppMessageRawTextAlignmentStart:
    return NSTextAlignmentNatural;
  case BRZInAppMessageRawTextAlignmentCenter:
    return NSTextAlignmentCenter;
  case BRZInAppMessageRawTextAlignmentEnd:
    return leftToRight ? NSTextAlignmentRight : NSTextAlignmentLeft;
  default:
    return NSTextAlignmentNatural;
  }
}

- (void)setHeaderTextAlignment:(NSTextAlignment)headerTextAlignment {
  BOOL leftToRight =
      [UIApplication sharedApplication].userInterfaceLayoutDirection ==
      UIUserInterfaceLayoutDirectionLeftToRight;
  BRZInAppMessageRawTextAlignment alignment;
  switch (headerTextAlignment) {
  case NSTextAlignmentNatural:
  case NSTextAlignmentJustified:
    alignment = leftToRight ? BRZInAppMessageRawTextAlignmentStart
                            : BRZInAppMessageRawTextAlignmentEnd;
    break;
  case NSTextAlignmentCenter:
    alignment = BRZInAppMessageRawTextAlignmentCenter;
    break;
  case NSTextAlignmentRight:
    alignment = BRZInAppMessageRawTextAlignmentEnd;
    break;
  case NSTextAlignmentLeft:
    alignment = BRZInAppMessageRawTextAlignmentStart;
    break;
  default:
    alignment = BRZInAppMessageRawTextAlignmentStart;
    break;
  }
  self.inAppMessage.headerTextAlignment = alignment;
}

- (ABKInAppMessageImmersiveImageStyle)imageStyle {
  return (ABKInAppMessageImmersiveImageStyle)self.inAppMessage.imageStyle;
}

- (void)setImageStyle:(ABKInAppMessageImmersiveImageStyle)imageStyle {
  self.inAppMessage.imageStyle = (BRZInAppMessageRawImageStyle)imageStyle;
}

- (void)logInAppMessageClickedWithButtonID:(NSInteger)buttonId {
  [self.inAppMessage.context logClickWithButtonId:[@(buttonId) stringValue]];
}

- (void)setInAppMessageButtons:(NSArray *)buttonArray {
  NSMutableArray *buttons = [NSMutableArray array];
  for (ABKInAppMessageButton *button in buttonArray) {
    if (![button isKindOfClass:[ABKInAppMessageButton class]]) {
      continue;
    }
    [buttons addObject:button.button];
  }
  self.inAppMessage.buttons = buttons;
}

@end

#pragma clang diagnostic pop
