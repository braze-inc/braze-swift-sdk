#import "ABKInAppMessageController.h"
#import "../BrazeDelegateWrapper.h"
#import "ABKInAppMessage+Compat.h"
#import "ABKInAppMessageController+Compat.h"
#import "ABKInAppMessageFull+Compat.h"
#import "ABKInAppMessageHTML+Compat.h"
#import "ABKInAppMessageHTMLFull+Compat.h"
#import "ABKInAppMessageModal+Compat.h"
#import "ABKInAppMessageSlideup+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@interface ABKInAppMessageController ()

@property(strong, nonatomic, readonly) NSArray<BRZInAppMessageRaw *> *stack;

- (void)tryPushOnStack:(BRZInAppMessageRaw *)message;
- (ABKInAppMessage *)convertToABKInAppMessage:(BRZInAppMessageRaw *)message;

@end

@implementation ABKInAppMessageController

- (id<ABKInAppMessageControllerDelegate>)delegate {
  return self.delegateWrapper.inAppMessageControllerDelegate;
}

- (void)setDelegate:(id<ABKInAppMessageControllerDelegate>)delegate {
  self.delegateWrapper.inAppMessageControllerDelegate = delegate;
}

- (void)displayNextInAppMessageWithDelegate:
    (id<ABKInAppMessageControllerDelegate>)delegate {
  [self displayNextInAppMessage];
}

- (void)displayNextInAppMessage {
  if (self.isCompatibility) {
    SEL selector = NSSelectorFromString(@"handleExistingInAppMessagesInStack");
    if (![self.inAppMessageUIController respondsToSelector:selector]) {
      NSLog(@"[BrazeKitCompat] Error: invalid 'inAppMessageUIController', cannot execute `displayNextInAppMessage`.");
      return;
    }
    IMP imp =
        [(NSObject *)self.inAppMessageUIController methodForSelector:selector];
    void (*handleExistingInAppMessagesInStack)(id, SEL) = (void *)imp;
    handleExistingInAppMessagesInStack(self.inAppMessageUIController, selector);
    return;
  }

  if (!self.presenter) {
    NSLog(@"[BrazeKitCompat] Error: invalid 'presenter', cannot execute `displayNextInAppMessage`.");
    return;
  }

  SEL selector = NSSelectorFromString(@"presentNext");
  if (![self.presenter respondsToSelector:selector]) {
    NSLog(@"[BrazeKitCompat] Error: invalid 'presenter' ('presentNext'), cannot execute `displayNextInAppMessage`.");
    return;
  }
  IMP imp = [self.presenter methodForSelector:selector];
  void (*presentNext)(id, SEL) = (void *)imp;
  presentNext(self.presenter, selector);
}

- (NSInteger)inAppMessagesRemainingOnStack {
  return self.stack.count;
}

- (void)addInAppMessage:(ABKInAppMessage *)newInAppMessage {
  [self.presenter presentMessage:newInAppMessage.inAppMessage];
}

- (NSArray<BRZInAppMessageRaw *> *)stack {
  id stack;
  if (self.isCompatibility) {
    stack = [self.presenter valueForKey:@"inAppMessageStack"];
    if ([stack isKindOfClass:[NSArray<ABKInAppMessage *> class]]) {
      NSMutableArray *unwrapped = [NSMutableArray array];
      for (ABKInAppMessage *message in stack) {
        [unwrapped addObject:message.inAppMessage];
      }
      stack = unwrapped;
    } else {
      NSLog(@"[BrazeKitCompat] Error: invalid 'inAppMessageStack'.");
    }
  } else {
    stack = [self.presenter valueForKey:@"stack"];
  }
  if ([stack isKindOfClass:[NSArray<BRZInAppMessageRaw *> class]]) {
    return stack;
  }
  return @[];
}

- (void)tryPushOnStack:(BRZInAppMessageRaw *)message {
  // AppboyUI
  if (self.isCompatibility) {
    NSMutableArray<ABKInAppMessage *> *stack =
        [self.presenter valueForKey:@"inAppMessageStack"];
    if (![stack isKindOfClass:[NSMutableArray<ABKInAppMessage *> class]]) {
      NSLog(@"[BrazeKitCompat] Error: invalid 'inAppMessageStack', cannot push in-app message to stack.");
      return;
    }
    [stack addObject:[self convertToABKInAppMessage:message]];
    return;
  }

  // BrazeUI
  SEL selector = NSSelectorFromString(@"_compat_tryPushOnStack:");
  if (![self.presenter respondsToSelector:selector]) {
    NSLog(@"[BrazeKitCompat] Error: invalid 'presenter', cannot push in-app message on the stack.");
    return;
  }
  IMP imp = [self.presenter methodForSelector:selector];
  void (*_compat_tryPushOnStack)(id, SEL, BRZInAppMessageRaw *) = (void *)imp;
  _compat_tryPushOnStack(self.presenter, selector, message);
}

- (ABKInAppMessage *)convertToABKInAppMessage:(BRZInAppMessageRaw *)message {
  ABKInAppMessage *abkMessage;
  switch (message.type) {
  case BRZInAppMessageRawTypeSlideup:
    abkMessage = [[ABKInAppMessageSlideup alloc] initWithInAppMessage:message];
    break;
  case BRZInAppMessageRawTypeModal:
    abkMessage = [[ABKInAppMessageModal alloc] initWithInAppMessage:message];
    break;
  case BRZInAppMessageRawTypeFull:
    abkMessage = [[ABKInAppMessageFull alloc] initWithInAppMessage:message];
    break;
  case BRZInAppMessageRawTypeHtmlFull:
    abkMessage = [[ABKInAppMessageHTMLFull alloc] initWithInAppMessage:message];
    break;
  case BRZInAppMessageRawTypeHtml:
    abkMessage = [[ABKInAppMessageHTML alloc] initWithInAppMessage:message];
    break;
  default:
    abkMessage = [[ABKInAppMessage alloc] initWithInAppMessage:message];
    break;
  }
  return abkMessage;
}

- (instancetype)initWithInAppMessagePresenter:
                    (NSObject<BrazeInAppMessagePresenter> *)presenter
                              delegateWrapper:
                                  (BrazeDelegateWrapper *)delegateWrapper {
  self = [super init];
  if (self) {
    _presenter = presenter;
    _delegateWrapper = delegateWrapper;
  }
  return self;
}

// ***** COMPAT *****

// Dynamically executed by the Swift SDK when available for compatibility
// purposes.
- (NSNumber *)_compat_beforeInAppMessageDisplayed:
    (BRZInAppMessageRaw *)message {
  ABKInAppMessage *abkMessage = [self convertToABKInAppMessage:message];

  ABKInAppMessageDisplayChoice displayChoice = ABKDisplayInAppMessageNow;
  if (abkMessage.isControl) {
    if ([self.delegate respondsToSelector:@selector
                       (beforeControlMessageImpressionLogged:)]) {
      displayChoice =
          [self.delegate beforeControlMessageImpressionLogged:abkMessage];
    }
  } else {
    if ([self.delegate
            respondsToSelector:@selector(beforeInAppMessageDisplayed:)]) {
      displayChoice = [self.delegate beforeInAppMessageDisplayed:abkMessage];
    }
  }

  switch (displayChoice) {
  case ABKDisplayInAppMessageNow:
    return @YES;
  case ABKDisplayInAppMessageLater:
    [self tryPushOnStack:message];
    return @NO;
  case ABKDiscardInAppMessage:
    return @NO;
  default:
    return @YES;
  }
}

// ******************

@end

#pragma clang diagnostic pop
