#import "ABKInAppMessageDarkTheme.h"

@class BRZInAppMessageRawTheme;

@interface ABKInAppMessageDarkTheme ()

@property(strong, nonatomic) BRZInAppMessageRawTheme *theme;

- (instancetype)initWithTheme:(BRZInAppMessageRawTheme *)theme;

@end
