#import <Foundation/Foundation.h>

#if __has_feature(modules)
  @import BrazeKit;
#else
  #import <BrazeKit/BrazeKit-Swift.h>
#endif

@protocol ABKURLDelegate;
@protocol ABKInAppMessageControllerDelegate;

@interface BrazeDelegateWrapper : NSObject <BrazeDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property(strong, nonatomic) id<ABKURLDelegate> urlDelegate;
@property(weak, nonatomic) id<ABKInAppMessageControllerDelegate> inAppMessageControllerDelegate;
#pragma clang diagnostic pop

@end
