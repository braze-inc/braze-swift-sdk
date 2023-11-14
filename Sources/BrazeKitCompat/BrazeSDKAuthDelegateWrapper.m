#import "BrazeSDKAuthDelegateWrapper.h"
#import "ABKSdkAuthenticationDelegate.h"
#import "AppboyKit/ABKSdkAuthenticationError+Compat.h"

@implementation BrazeSDKAuthDelegateWrapper

- (void)braze:(Braze *)braze sdkAuthenticationFailedWithError:(BRZSDKAuthenticationError *)error {
  if ([self.sdkAuthDelegate
          respondsToSelector:@selector(handleSdkAuthenticationError:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    ABKSdkAuthenticationError *authError = [[ABKSdkAuthenticationError alloc]
        initWithSDKAuthenticationError:error];
#pragma clang diagnostic pop
    [self.sdkAuthDelegate handleSdkAuthenticationError:authError];
  }
}

@end
