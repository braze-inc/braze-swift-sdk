#import "ABKInAppMessageButton.h"

@class BRZInAppMessageRawButton;

@interface ABKInAppMessageButton ()

@property(strong, nonatomic) BRZInAppMessageRawButton *button;

- (instancetype)initWithButton:(BRZInAppMessageRawButton *)button;

@end
