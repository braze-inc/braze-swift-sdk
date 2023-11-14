@import BrazeKit;
@import Foundation;

@protocol ABKSdkAuthenticationDelegate;

@interface BrazeSDKAuthDelegateWrapper : NSObject <BrazeSDKAuthDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property(strong, nonatomic) id<ABKSdkAuthenticationDelegate> sdkAuthDelegate;
#pragma clang diagnostic pop

@end
