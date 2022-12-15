#import "ABKInAppMessageUIController.h"
#import "ABKInAppMessageWindowController.h"
#import "ABKUIUtils.h"
#import "ABKInAppMessageSlideupViewController.h"
#import "ABKInAppMessageModalViewController.h"
#import "ABKInAppMessageHTMLFullViewController.h"
#import "ABKInAppMessageHTMLViewController.h"
#import "ABKInAppMessageFullViewController.h"
#import "ABKSDWebImageImageDelegate.h"
#import "SDWebImage/SDWebImage.h"

@import BrazeKitCompat;

@interface ABKInAppMessageUIController ()

@property (strong, nonatomic) NSMutableArray *inAppMessageStack;

- (void)handleExistingInAppMessagesInStack;

@end

@implementation ABKInAppMessageUIController

- (instancetype)init {
  if (self = [super init]) {
    _supportedOrientationMask = UIInterfaceOrientationMaskAll;
    _preferredOrientation = UIInterfaceOrientationUnknown;
    _inAppMessageStack = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveKeyboardWasShownNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveKeyboardDidHideNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inAppMessageWindowDismissed:)
                                                 name:ABKNotificationInAppMessageWindowDismissed
                                               object:nil];
  }
  return self;
}

#pragma mark - Show and Hide In-app Message

- (void)showInAppMessage:(ABKInAppMessage *)inAppMessage {
  if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad) {
    // Check the device orientation before displaying the in-app message
    UIInterfaceOrientation statusBarOrientation = [ABKUIUtils getInterfaceOrientation];
    NSString *errorMessage = @"The in-app message %@ with %@ orientation shouldn't be displayed in %@, disregarding this in-app message.";
    if (inAppMessage.orientation == ABKInAppMessageOrientationPortrait &&
        !UIInterfaceOrientationIsPortrait(statusBarOrientation)) {
      NSLog(errorMessage, inAppMessage, @"portrait", @"landscape");
      return;
    }
    if (inAppMessage.orientation == ABKInAppMessageOrientationLandscape &&
        !UIInterfaceOrientationIsLandscape(statusBarOrientation)) {
      NSLog(errorMessage, inAppMessage, @"landscape", @"portrait");
      return;
    }
  }
  
  if ([inAppMessage isKindOfClass:[ABKInAppMessageImmersive class]]) {
    ABKInAppMessageImmersive *immersiveInAppMessage = (ABKInAppMessageImmersive *)inAppMessage;
    if (immersiveInAppMessage.imageStyle == ABKInAppMessageGraphic &&
        ![ABKUIUtils objectIsValidAndNotEmpty:immersiveInAppMessage.imageURI]) {
      NSLog(@"The in-app message has graphic image style but no image, discard this in-app message.");
      return;
    }
    if ([immersiveInAppMessage isKindOfClass:[ABKInAppMessageFull class]] &&
        ![ABKUIUtils objectIsValidAndNotEmpty:immersiveInAppMessage.imageURI]) {
      NSLog(@"The in-app message is a full in-app message without an image, discard this in-app message.");
      return;
    }
  }
  
  if (inAppMessage.inAppMessageClickActionType == ABKInAppMessageNoneClickAction &&
      [inAppMessage isKindOfClass:[ABKInAppMessageSlideup class]]) {
    ((ABKInAppMessageSlideup *)inAppMessage).hideChevron = YES;
  }
  
  ABKInAppMessageViewController *inAppMessageViewController = nil;
  if ([self.uiDelegate respondsToSelector:@selector(inAppMessageViewControllerWithInAppMessage:)]) {
    inAppMessageViewController = [self.uiDelegate inAppMessageViewControllerWithInAppMessage:inAppMessage];
  } else {
    if ([inAppMessage isKindOfClass:[ABKInAppMessageSlideup class]]) {
      inAppMessageViewController = [[ABKInAppMessageSlideupViewController alloc]
                                    initWithInAppMessage:inAppMessage];
    } else if ([inAppMessage isKindOfClass:[ABKInAppMessageModal class]]) {
      inAppMessageViewController = [[ABKInAppMessageModalViewController alloc]
                                    initWithInAppMessage:inAppMessage];
    } else if ([inAppMessage isKindOfClass:[ABKInAppMessageFull class]]) {
      inAppMessageViewController = [[ABKInAppMessageFullViewController alloc]
                                    initWithInAppMessage:inAppMessage];
    } else if ([inAppMessage isKindOfClass:[ABKInAppMessageHTMLFull class]]) {
      inAppMessageViewController = [[ABKInAppMessageHTMLFullViewController alloc]
                                    initWithInAppMessage:inAppMessage];
    } else if ([inAppMessage isKindOfClass:[ABKInAppMessageHTML class]]) {
      inAppMessageViewController = [[ABKInAppMessageHTMLViewController alloc]
                                    initWithInAppMessage:inAppMessage];
    }
  }
  if (inAppMessageViewController) {
    ABKInAppMessageWindowController *windowController = [[ABKInAppMessageWindowController alloc]
                                                         initWithInAppMessage:inAppMessage
                                                   inAppMessageViewController:inAppMessageViewController
                                                         inAppMessageDelegate:self.uiDelegate];
    windowController.supportedOrientationMask = self.supportedOrientationMask;
    windowController.preferredOrientation = self.preferredOrientation;
    self.inAppMessageWindowController = windowController;
    if (@available(iOS 13.0, *)) {
      inAppMessageViewController.overrideUserInterfaceStyle = inAppMessage.overrideUserInterfaceStyle;
    }
    [self.inAppMessageWindowController displayInAppMessageViewWithAnimation:inAppMessage.animateIn];
  }
}

- (ABKInAppMessageDisplayChoice)getCurrentDisplayChoiceForInAppMessage:(ABKInAppMessage *)inAppMessage {
  ABKInAppMessageDisplayChoice inAppMessageDisplayChoice = self.keyboardVisible ?
    ABKDisplayInAppMessageLater : ABKDisplayInAppMessageNow;
  if (inAppMessageDisplayChoice == ABKDisplayInAppMessageLater) {
    NSLog(@"Initially setting in-app message display choice to ABKDisplayInAppMessageLater due to visible keyboard.");
  }
  if ([self.uiDelegate respondsToSelector:@selector(beforeInAppMessageDisplayed:withKeyboardIsUp:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    // ignore deprecation warning to support client integrations using the deprecated method
    inAppMessageDisplayChoice = [self.uiDelegate beforeInAppMessageDisplayed:inAppMessage
                                                            withKeyboardIsUp:self.keyboardVisible];
#pragma clang diagnostic pop
  } else if ([[Appboy sharedInstance].inAppMessageController.delegate
              respondsToSelector:@selector(beforeInAppMessageDisplayed:)]) {
    inAppMessageDisplayChoice = [[Appboy sharedInstance].inAppMessageController.delegate
                                 beforeInAppMessageDisplayed:inAppMessage];
  }
  return inAppMessageDisplayChoice;
}

- (ABKInAppMessageDisplayChoice)getCurrentDisplayChoiceForControlInAppMessage:(ABKInAppMessage *)controlInAppMessage {
  ABKInAppMessageDisplayChoice inAppMessageDisplayChoice = self.keyboardVisible ? ABKDisplayInAppMessageLater : ABKDisplayInAppMessageNow;
  if (inAppMessageDisplayChoice == ABKDisplayInAppMessageLater) {
    NSLog(@"Initially setting in-app message display choice to ABKDisplayInAppMessageLater due to visible keyboard.");
  }
  if ([[Appboy sharedInstance].inAppMessageController.delegate
              respondsToSelector:@selector(beforeControlMessageImpressionLogged:)]) {
    inAppMessageDisplayChoice = [Appboy.sharedInstance.inAppMessageController.delegate beforeControlMessageImpressionLogged:controlInAppMessage];
  }
  return inAppMessageDisplayChoice;
}

- (BOOL)inAppMessageCurrentlyVisible {
  if (self.inAppMessageWindowController) {
    return YES;
  }
  return NO;
}

- (void)hideCurrentInAppMessage:(BOOL)animated {
  @try {
    if (self.inAppMessageWindowController) {
      [self.inAppMessageWindowController hideInAppMessageViewWithAnimation:animated];
    }
  }
  @catch (NSException *exception) {
    NSLog(@"An error occured and this in-app message couldn't be hidden.");
  }
}

- (void)inAppMessageWindowDismissed:(NSNotification *)notification {
  // We listen to this notification so that we know when the screen is clear of in-app messages
  // and a new in-app message can be shown.
  self.inAppMessageWindowController = nil;
}

#pragma mark - Keyboard

- (void)receiveKeyboardDidHideNotification:(NSNotification *)notification {
  self.keyboardVisible = NO;
}

- (void)receiveKeyboardWasShownNotification:(NSNotification *)notification {
  self.keyboardVisible = YES;
  [self.inAppMessageWindowController keyboardWasShown];
}

#pragma mark - Set UIDelegate

- (void)setInAppMessageUIDelegate:(id)uiDelegate {
  _uiDelegate = uiDelegate;
}

#pragma mark - Dealloc

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -  BrazeInAppMessagePresenter

- (void)presentMessage:(BRZInAppMessageRaw * _Nonnull)message {
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

  // Force loading assets in SDWebImage cache, the assets needs to be directly available otherwise
  // the IAM UI doesn't render properly.
  SDImageCache *cache = SDImageCache.sharedImageCache;
  if (message.imageURL) {
    NSString *key = [SDWebImageManager.sharedManager cacheKeyForURL:message.imageURL];
    NSData *imageData = [NSData dataWithContentsOfURL:message.imageURL];
    [cache storeImageDataToDisk:imageData forKey:key];
  }

  [self.inAppMessageStack addObject:abkMessage];
  [self handleExistingInAppMessagesInStack];
}

- (void)handleExistingInAppMessagesInStack {
  if (self.inAppMessageStack.count == 0) {
    NSLog(@"%@: No in-app message found in stack.", NSStringFromSelector(_cmd));
    return;
  }

  // We used to only display IAM when the state is active, but sometimes when the
  // in-app message comes in early and the state is still inactive, the message won't show.
  // As a result, we display the message when the application state is inactive or active.
  if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
    // When the application is in the background, we don't want to display an in-app message in any case
    NSLog(@"%@: Application state was neither active nor inactive.", NSStringFromSelector(_cmd));
    return;
  }

  ABKInAppMessage *inAppMessage = [self.inAppMessageStack lastObject];
  if (inAppMessage) {
    [self.inAppMessageStack removeLastObject];
  }
  //suppress in-app message if another in-app message is visible if IAM subspec is available
  if (self.inAppMessageCurrentlyVisible) {
    NSLog(@"Another in-app message is currently visible. Putting back on stack.", nil);
    [self.inAppMessageStack addObject:inAppMessage];
    return;
  }

  ABKInAppMessageDisplayChoice inAppMessageDisplayChoice;
  if (inAppMessage.isControl) {
    inAppMessageDisplayChoice = [self getCurrentDisplayChoiceForControlInAppMessage:inAppMessage];
  } else {
    inAppMessageDisplayChoice = [self getCurrentDisplayChoiceForInAppMessage:inAppMessage];
  }
  if (inAppMessageDisplayChoice == ABKDiscardInAppMessage) {
    NSLog(@"%@: ABKDiscardInAppMessage received.", NSStringFromSelector(_cmd));
  } else if (inAppMessageDisplayChoice == ABKDisplayInAppMessageNow) {
    NSLog(@"%@: ABKDisplayInAppMessageNow received: attempting to display the in-app message", NSStringFromSelector(_cmd));
    [self showInAppMessage:inAppMessage];
  } else if (inAppMessageDisplayChoice == ABKDisplayInAppMessageLater) {
    NSLog(@"%@: ABKDisplayInAppMessageLater received. Returning in-app message to the stack.", NSStringFromSelector(_cmd));
    [self.inAppMessageStack addObject:inAppMessage];
  } else {
    // Developer returned a wrong in-app message return value, print it out to inform the developer
    NSLog(@"Invalid value returned from beforeInAppMessageDisplayed:withKeyboardIsUp:. Please return ABKDisplayInAppMessageNow, ABKDisplayInAppMessageLater, or ABKDiscardInAppMessage");
  }
}

@end
