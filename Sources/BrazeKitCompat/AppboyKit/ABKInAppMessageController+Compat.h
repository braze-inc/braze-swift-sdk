#import "ABKInAppMessageController.h"

@import BrazeKit;

@class BrazeDelegateWrapper;

@interface ABKInAppMessageController ()

@property(strong, nonatomic) NSObject<BrazeInAppMessagePresenter> *presenter;
@property(strong, nonatomic) BrazeDelegateWrapper *delegateWrapper;
@property(assign, nonatomic) BOOL isCompatibility;

- (instancetype)initWithInAppMessagePresenter:
    (NSObject<BrazeInAppMessagePresenter> *)presenter delegateWrapper:(BrazeDelegateWrapper *)delegateWrapper;

@end
