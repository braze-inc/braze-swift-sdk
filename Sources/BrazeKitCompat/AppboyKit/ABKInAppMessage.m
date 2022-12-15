#import "ABKInAppMessage.h"
#import "../BRZLog.h"
#import "ABKInAppMessage+Compat.h"
#import "ABKInAppMessageDarkTheme+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;
@import UIKit;

@implementation ABKInAppMessage

- (NSString *)message {
  return self.inAppMessage.message;
}

- (void)setMessage:(NSString *)message {
  self.inAppMessage.message = message;
}

- (NSDictionary *)extras {
  return self.inAppMessage.extras;
}

- (void)setExtras:(NSDictionary *)extras {
  self.inAppMessage.extras = extras;
}

- (NSTimeInterval)duration {
  return self.inAppMessage.duration;
}

- (void)setDuration:(NSTimeInterval)duration {
  self.inAppMessage.duration = duration;
}

- (ABKInAppMessageClickActionType)inAppMessageClickActionType {
  switch (self.inAppMessage.clickAction) {
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

- (NSURL *)uri {
  return self.inAppMessage.url;
}

- (BOOL)openUrlInWebView {
  return self.inAppMessage.useWebView;
}

- (void)setOpenUrlInWebView:(BOOL)openUrlInWebView {
  self.inAppMessage.useWebView = openUrlInWebView;
}

- (ABKInAppMessageDismissType)inAppMessageDismissType {
  return (ABKInAppMessageDismissType)self.inAppMessage.messageClose;
}

- (void)setInAppMessageDismissType:
    (ABKInAppMessageDismissType)inAppMessageDismissType {
  self.inAppMessage.messageClose =
      (BRZInAppMessageRawClose)inAppMessageDismissType;
}

- (UIColor *)backgroundColor {
  return self.inAppMessage.backgroundColor.uiColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  self.inAppMessage.backgroundColor =
      [[BRZInAppMessageRawColor alloc] init:backgroundColor];
}

- (UIColor *)textColor {
  return self.inAppMessage.textColor.uiColor;
}

- (void)setTextColor:(UIColor *)textColor {
  self.inAppMessage.textColor =
      [[BRZInAppMessageRawColor alloc] init:textColor];
}

- (NSString *)icon {
  return self.inAppMessage.icon;
}

- (void)setIcon:(NSString *)icon {
  self.inAppMessage.icon = icon;
}

- (UIColor *)iconColor {
  return self.inAppMessage.iconColor.uiColor;
}

- (void)setIconColor:(UIColor *)iconColor {
  self.inAppMessage.iconColor =
      [[BRZInAppMessageRawColor alloc] init:iconColor];
}

- (UIColor *)iconBackgroundColor {
  return self.inAppMessage.iconBackgroundColor.uiColor;
}

- (void)setIconBackgroundColor:(UIColor *)iconBackgroundColor {
  self.inAppMessage.iconBackgroundColor =
      [[BRZInAppMessageRawColor alloc] init:iconBackgroundColor];
}

- (BOOL)enableDarkTheme {
  return self.inAppMessage.themes[@"dark"] != nil;
}

- (void)setEnableDarkTheme:(BOOL)enableDarkTheme {
  NSMutableDictionary *themes = [self.inAppMessage.themes mutableCopy];
  if (enableDarkTheme) {
    themes[@"dark"] = themes[@"_dark"] ?: themes[@"dark"];
    themes[@"_dark"] = nil;
  } else {
    themes[@"_dark"] = themes[@"dark"] ?: themes[@"_dark"];
    themes[@"dark"] = nil;
  }
  self.inAppMessage.themes = [themes copy];
}

- (ABKInAppMessageDarkTheme *)darkTheme {
  BRZInAppMessageRawTheme *theme = self.inAppMessage.themes[@"dark"];
  if (!theme) {
    return nil;
  }
  return [[ABKInAppMessageDarkTheme alloc] initWithTheme:theme];
}

- (void)setDarkTheme:(ABKInAppMessageDarkTheme *)darkTheme {
  NSMutableDictionary *themes = [self.inAppMessage.themes mutableCopy];
  themes[@"dark"] = darkTheme.theme;
  self.inAppMessage.themes = [themes copy];
}

- (NSInteger)overrideUserInterfaceStyle {
  return self.inAppMessage._compat_overrideUserInterfaceStyle;
}

- (void)setOverrideUserInterfaceStyle:(NSInteger)overrideUserInterfaceStyle {
  self.inAppMessage._compat_overrideUserInterfaceStyle =
      overrideUserInterfaceStyle;
}

- (NSURL *)imageURI {
  return self.inAppMessage.imageURL;
}

- (void)setImageURI:(NSURL *)imageURI {
  self.inAppMessage.imageURL = imageURI;
}

- (ABKInAppMessageOrientation)orientation {
  return (ABKInAppMessageOrientation)self.inAppMessage.orientation;
}

- (void)setOrientation:(ABKInAppMessageOrientation)orientation {
  self.inAppMessage.orientation = (BRZInAppMessageRawOrientation)orientation;
}

- (NSTextAlignment)messageTextAlignment {
  BOOL leftToRight =
      [UIApplication sharedApplication].userInterfaceLayoutDirection ==
      UIUserInterfaceLayoutDirectionLeftToRight;
  switch (self.inAppMessage.messageTextAlignment) {
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

- (void)setMessageTextAlignment:(NSTextAlignment)messageTextAlignment {
  BOOL leftToRight =
      [UIApplication sharedApplication].userInterfaceLayoutDirection ==
      UIUserInterfaceLayoutDirectionLeftToRight;
  BRZInAppMessageRawTextAlignment alignment;
  switch (messageTextAlignment) {
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
  self.inAppMessage.messageTextAlignment = alignment;
}

- (BOOL)animateIn {
  return self.inAppMessage.animateIn;
}

- (void)setAnimateIn:(BOOL)animateIn {
  self.inAppMessage.animateIn = animateIn;
}

- (BOOL)animateOut {
  return self.inAppMessage.animateOut;
}

- (void)setAnimateOut:(BOOL)animateOut {
  self.inAppMessage.animateOut = animateOut;
}

- (BOOL)isControl {
  return self.inAppMessage.isControl;
}

- (void)setIsControl:(BOOL)isControl {
  self.inAppMessage.isControl = isControl;
}

- (void)logInAppMessageImpression {
  [self.inAppMessage.context logImpression];
}

- (void)logInAppMessageClicked {
  [self.inAppMessage.context logClick];
}

- (void)setInAppMessageClickAction:
            (ABKInAppMessageClickActionType)clickActionType
                           withURI:(NSURL *)uri {
  switch (clickActionType) {
  case ABKInAppMessageDisplayNewsFeed:
    self.inAppMessage.clickAction = BRZInAppMessageRawClickActionNewsFeed;
    self.inAppMessage.url = nil;
    break;
  case ABKInAppMessageRedirectToURI:
    self.inAppMessage.clickAction = BRZInAppMessageRawClickActionURL;
    self.inAppMessage.url = uri;
    break;
  case ABKInAppMessageNoneClickAction:
    self.inAppMessage.clickAction = BRZInAppMessageRawClickActionNone;
    self.inAppMessage.url = nil;
    break;
  default:
    self.inAppMessage.clickAction = BRZInAppMessageRawClickActionNone;
    self.inAppMessage.url = nil;
    break;
  }
}

- (NSData *)serializeToData {
  return [self.inAppMessage json];
}

- (instancetype)init {
  return [self initWithInAppMessage:[[BRZInAppMessageRaw alloc] init]];
}

- (instancetype)initWithInAppMessage:(BRZInAppMessageRaw *)inAppMessage {
  self = [super init];
  if (self) {
    _inAppMessage = inAppMessage;
    _imageContentMode = inAppMessage.type == BRZInAppMessageRawTypeFull
                            ? UIViewContentModeScaleAspectFill
                            : UIViewContentModeScaleAspectFit;
  }
  return self;
}

@end

#pragma clang diagnostic pop
