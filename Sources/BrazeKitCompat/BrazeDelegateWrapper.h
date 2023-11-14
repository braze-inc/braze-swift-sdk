@import BrazeKit;
@import Foundation;

@protocol ABKURLDelegate;
@protocol ABKInAppMessageControllerDelegate;

@interface BrazeDelegateWrapper : NSObject <BrazeDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property(strong, nonatomic) id<ABKURLDelegate> urlDelegate;
@property(weak, nonatomic) id<ABKInAppMessageControllerDelegate> inAppMessageControllerDelegate;
#pragma clang diagnostic pop

@end
