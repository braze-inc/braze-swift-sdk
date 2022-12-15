#import "ABKSdkAuthenticationError.h"
#import "ABKSdkAuthenticationError+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKSdkAuthenticationError

- (NSInteger)code {
  return self.error.code;
}

- (NSString *)reason {
  return self.error.reason;
}

- (NSString *)userId {
  return self.error.userId;
}

- (NSString *)signature {
  return self.error.signature;
}

- (instancetype)initWithSDKAuthenticationError:
    (BRZSDKAuthenticationError *)error {
  self = [super init];
  if (self) {
    _error = error;
  }
  return self;
}

@end

#pragma clang diagnostic pop
