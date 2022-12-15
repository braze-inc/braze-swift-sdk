#import "ABKSdkAuthenticationError.h"

@class BRZSDKAuthenticationError;

@interface ABKSdkAuthenticationError ()

@property(strong, nonatomic) BRZSDKAuthenticationError *error;

- (instancetype)initWithSDKAuthenticationError:
    (BRZSDKAuthenticationError *)error;

@end
