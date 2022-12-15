#import "ABKInAppMessage.h"

@class BRZInAppMessageRaw;

@interface ABKInAppMessage ()

@property(strong, nonatomic) BRZInAppMessageRaw *inAppMessage;

- (instancetype)initWithInAppMessage:(BRZInAppMessageRaw *)inAppMessage;

@end
