#import "BrazeDelegateWrapper.h"
#import "ABKInAppMessageControllerDelegate.h"
#import "ABKSdkAuthenticationDelegate.h"
#import "ABKURLDelegate.h"
#import "AppboyKit/ABKSdkAuthenticationError+Compat.h"

@implementation BrazeDelegateWrapper

- (BOOL)braze:(Braze *)braze shouldOpenURL:(BRZURLContext *)context {
  if ([self.urlDelegate respondsToSelector:@selector
                        (handleAppboyURL:fromChannel:withExtras:)]) {
    return ![self.urlDelegate handleAppboyURL:context.url
                                  fromChannel:(ABKChannel)context.channel
                                   withExtras:context.extras];
  }
  return YES;
}

- (void)braze:(Braze *)braze
    sdkAuthenticationFailedWithError:(BRZSDKAuthenticationError *)error {
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

- (void)braze:(Braze *)braze
    noMatchingTriggerForEvent:(enum BRZTriggerEvent)event
                         name:(NSString *)name
                   properties:(NSDictionary<NSString *, id> *)properties {
  if (![self.inAppMessageControllerDelegate
          respondsToSelector:@selector(noMatchingTriggerForEvent:name:)]) {
    return;
  }

  ABKTriggerEventType abkEvent;
  switch (event) {
  case BRZTriggerEventSessionStart:
    abkEvent = ABKTriggerEventTypeSessionStart;
    break;
  case BRZTriggerEventCustomEvent:
    abkEvent = ABKTriggerEventTypeCustomEvent;
    break;
  case BRZTriggerEventPurchase:
    abkEvent = ABKTriggerEventTypePurchase;
    break;
  case BRZTriggerEventOther:
    abkEvent = ABKTriggerEventTypeOther;
    break;
  default:
    abkEvent = ABKTriggerEventTypeOther;
    break;
  }

  [self.inAppMessageControllerDelegate noMatchingTriggerForEvent:abkEvent
                                                            name:name];
}

@end
