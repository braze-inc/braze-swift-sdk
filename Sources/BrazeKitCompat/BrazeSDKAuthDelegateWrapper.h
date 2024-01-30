#import <Foundation/Foundation.h>

#if __has_feature(modules)
  @import BrazeKit;
#else
  #import <BrazeKit/BrazeKit-Swift.h>
#endif

@protocol ABKSdkAuthenticationDelegate;

@interface BrazeSDKAuthDelegateWrapper : NSObject <BrazeSDKAuthDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property(strong, nonatomic) id<ABKSdkAuthenticationDelegate> sdkAuthDelegate;
#pragma clang diagnostic pop

@end
