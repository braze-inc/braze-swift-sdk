#import "ABKInAppMessageButton.h"
#import "ABKInAppMessageButton+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKInAppMessageButton

- (NSString *)buttonText {
  return self.button.text;
}

- (void)setButtonText:(NSString *)buttonText {
  self.button.text = buttonText;
}

- (UIColor *)buttonBackgroundColor {
  return self.button.backgroundColor.uiColor;
}

- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor {
  self.button.backgroundColor =
      [[BRZInAppMessageRawColor alloc] init:buttonBackgroundColor];
}

- (UIColor *)buttonBorderColor {
  return self.button.borderColor.uiColor;
}

- (void)setButtonBorderColor:(UIColor *)buttonBorderColor {
  self.button.borderColor =
      [[BRZInAppMessageRawColor alloc] init:buttonBorderColor];
}

- (UIColor *)buttonTextColor {
  return self.button.textColor.uiColor;
}

- (void)setButtonTextColor:(UIColor *)buttonTextColor {
  self.button.textColor =
      [[BRZInAppMessageRawColor alloc] init:buttonTextColor];
}

- (ABKInAppMessageClickActionType)buttonClickActionType {
  switch (self.button.clickAction) {
  case BRZInAppMessageRawClickActionNewsFeed:
    return ABKInAppMessageDisplayNewsFeed;
  case BRZInAppMessageRawClickActionURL:
    return ABKInAppMessageRedirectToURI;
  case BRZInAppMessageRawClickActionNone:
    return ABKInAppMessageNoneClickAction;
  default:
    return ABKInAppMessageNoneClickAction;
  }
}

- (NSURL *)buttonClickedURI {
  return self.button.url;
}

- (BOOL)buttonOpenUrlInWebView {
  return self.button.useWebView;
}

- (void)setButtonOpenUrlInWebView:(BOOL)buttonOpenUrlInWebView {
  self.button.useWebView = buttonOpenUrlInWebView;
}

- (NSInteger)buttonID {
  return self.button.identifier;
}

- (void)setButtonClickAction:(ABKInAppMessageClickActionType)clickActionType
                     withURI:(NSURL *)uri {
  switch (clickActionType) {
  case ABKInAppMessageDisplayNewsFeed:
    self.button.clickAction = BRZInAppMessageRawClickActionNewsFeed;
    self.button.url = nil;
    break;
  case ABKInAppMessageRedirectToURI:
    self.button.clickAction = BRZInAppMessageRawClickActionURL;
    self.button.url = uri;
    break;
  case ABKInAppMessageNoneClickAction:
    self.button.clickAction = BRZInAppMessageRawClickActionNone;
    self.button.url = nil;
    break;
  default:
    self.button.clickAction = BRZInAppMessageRawClickActionNone;
    self.button.url = nil;
    break;
  }
}

- (instancetype)initWithButton:(BRZInAppMessageRawButton *)button {
  self = [super init];
  if (self) {
    _button = button;
  }
  return self;
}

@end

#pragma clang diagnostic pop
