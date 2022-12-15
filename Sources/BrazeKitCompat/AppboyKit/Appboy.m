#import "Appboy.h"
#import "ABKContentCardsController+Compat.h"
#import "ABKLocationManager+Compat.h"
#import "ABKUser+Compat.h"
#import "Appboy+Compat.h"
#import "_ABKBRZCompat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation Appboy

+ (Appboy *)sharedInstance {
  return _ABKBRZCompat.shared.appboy;
}

+ (Appboy *)unsafeInstance {
  if (_ABKBRZCompat.shared.appboy == nil) {
    NSString *exceptionReason =
        @"[Appboy unsafeInstance] called before Braze initialized. Please call "
         "[Appboy startWithApiKey:inApplication:withLaunchOptions:] before "
         "using the unsafeInstance. If you "
         "cannot guarantee Braze will be initialized before accessing the "
         "unsafeInstance, please use "
         "[Appboy sharedInstance] instead.";
    NSException *appboyException = [NSException
        exceptionWithName:@"InstanceAccessedBeforeInitializedException"
                   reason:exceptionReason
                 userInfo:nil];
    @throw appboyException;
  }
  return _ABKBRZCompat.shared.appboy;
}

+ (void)startWithApiKey:(NSString *)apiKey
          inApplication:(UIApplication *)application
      withLaunchOptions:(NSDictionary *)launchOptions {
  [Braze startWithApiKey:apiKey
           inApplication:application
       withLaunchOptions:launchOptions
       withAppboyOptions:nil];
}

+ (void)startWithApiKey:(NSString *)apiKey
          inApplication:(UIApplication *)application
      withLaunchOptions:(NSDictionary *)launchOptions
      withAppboyOptions:(NSDictionary *)appboyOptions {
  [Braze startWithApiKey:apiKey
           inApplication:application
       withLaunchOptions:launchOptions
       withAppboyOptions:appboyOptions];
}

- (ABKFeedController *)feedController {
  return self.braze.feedController;
}

- (ABKContentCardsController *)contentCardsController {
  return self.braze.contentCardsController;
}

- (ABKRequestProcessingPolicy)requestProcessingPolicy {
  return (ABKRequestProcessingPolicy)self.braze.requestProcessingPolicy;
}

- (void)setRequestProcessingPolicy:
    (ABKRequestProcessingPolicy)requestProcessingPolicy {
  self.braze.requestProcessingPolicy =
      (_COMPAT_ABKRequestProcessingPolicy)requestProcessingPolicy;
}

- (id<ABKIDFADelegate>)idfaDelegate {
  return self.braze.idfaDelegate;
}

- (void)setIdfaDelegate:(id<ABKIDFADelegate>)idfaDelegate {
  self.braze.idfaDelegate = idfaDelegate;
}

- (id<ABKSdkAuthenticationDelegate>)sdkAuthenticationDelegate {
  return self.braze.sdkAuthenticationDelegate;
}

- (void)setSdkAuthenticationDelegate:
    (id<ABKSdkAuthenticationDelegate>)sdkAuthenticationDelegate {
  self.braze.sdkAuthenticationDelegate = sdkAuthenticationDelegate;
}

#if !TARGET_OS_TV

- (ABKInAppMessageController *)inAppMessageController {
  return self.braze.inAppMessageController;
}

- (ABKLocationManager *)locationManager {
  return self.braze.locationManager;
}

- (id<ABKURLDelegate>)appboyUrlDelegate {
  return self.braze.appboyUrlDelegate;
}

- (void)setAppboyUrlDelegate:(id<ABKURLDelegate>)appboyUrlDelegate {
  self.braze.appboyUrlDelegate = appboyUrlDelegate;
}

- (id<ABKImageDelegate>)imageDelegate {
  return self.braze.imageDelegate;
}

- (void)setImageDelegate:(id<ABKImageDelegate>)imageDelegate {
  self.braze.imageDelegate = imageDelegate;
}

- (ABKSDKFlavor)sdkFlavor {
  return (ABKSDKFlavor)self.braze.sdkFlavor;
}

- (void)setSdkFlavor:(ABKSDKFlavor)sdkFlavor {
  self.braze.sdkFlavor = (_COMPAT_ABKSDKFlavor)sdkFlavor;
}

#endif

- (void)requestImmediateDataFlush {
  [self.braze requestImmediateDataFlush];
}

- (void)flushDataAndProcessRequestQueue {
  [self.braze flushDataAndProcessRequestQueue];
}

- (void)shutdownServerCommunication {
  // - not available
  // [self.braze shutdownServerCommunication];
}

- (void)changeUser:(NSString *)userId {
  [self.braze changeUser:userId];
}

- (void)changeUser:(NSString *)userId sdkAuthSignature:(NSString *)signature {
  [self.braze changeUser:userId sdkAuthSignature:signature];
}

- (void)setSdkAuthenticationSignature:(NSString *)signature {
  [self.braze setSDKAuthenticationSignature:signature];
}

- (void)unsubscribeFromSdkAuthenticationErrors {
  [self.braze unsubscribeFromSdkAuthenticationErrors];
}

- (void)logCustomEvent:(NSString *)eventName {
  [self.braze logCustomEvent:eventName];
}

- (void)logCustomEvent:(NSString *)eventName
        withProperties:(NSDictionary *)properties {
  [self.braze logCustomEvent:eventName withProperties:properties];
}

- (void)logPurchase:(NSString *)productIdentifier
         inCurrency:(NSString *)currencyCode
            atPrice:(NSDecimalNumber *)price {
  [self.braze logPurchase:productIdentifier
               inCurrency:currencyCode
                  atPrice:price];
}

- (void)logPurchase:(NSString *)productIdentifier
         inCurrency:(NSString *)currencyCode
            atPrice:(NSDecimalNumber *)price
     withProperties:(NSDictionary *)properties {
  [self.braze logPurchase:productIdentifier
               inCurrency:currencyCode
                  atPrice:price
           withProperties:properties];
}

- (void)logPurchase:(NSString *)productIdentifier
         inCurrency:(NSString *)currencyCode
            atPrice:(NSDecimalNumber *)price
       withQuantity:(NSUInteger)quantity {
  [self.braze logPurchase:productIdentifier
               inCurrency:currencyCode
                  atPrice:price
             withQuantity:quantity];
}

- (void)logPurchase:(NSString *)productIdentifier
         inCurrency:(NSString *)currencyCode
            atPrice:(NSDecimalNumber *)price
       withQuantity:(NSUInteger)quantity
      andProperties:(NSDictionary *)properties {
  [self.braze logPurchase:productIdentifier
               inCurrency:currencyCode
                  atPrice:price
             withQuantity:quantity
            andProperties:properties];
}

- (void)logFeedDisplayed {
  [self.braze logFeedDisplayed];
}

- (void)logContentCardsDisplayed {
  [self.braze logContentCardsDisplayed];
}

- (void)requestFeedRefresh {
  [self.braze requestFeedRefresh];
}

- (void)requestContentCardsRefresh {
  [self.braze requestContentCardsRefresh];
}

- (void)requestGeofencesWithLongitude:(double)longitude
                             latitude:(double)latitude {
  [self.braze requestGeofencesWithLongitude:longitude latitude:latitude];
}

- (NSString *)getDeviceId {
  return [self.braze getDeviceId];
}

#if !TARGET_OS_TV

- (void)registerDeviceToken:(NSData *)deviceToken {
  [self.braze registerDeviceToken:deviceToken];
}

- (void)registerApplication:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)notification {
  [self.braze registerApplication:application
      didReceiveRemoteNotification:notification];
}

- (void)registerApplication:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)notification
          fetchCompletionHandler:
              (void (^)(UIBackgroundFetchResult))completionHandler {
  [self.braze registerApplication:application
      didReceiveRemoteNotification:notification
            fetchCompletionHandler:completionHandler];
}

- (void)getActionWithIdentifier:(NSString *)identifier
          forRemoteNotification:(NSDictionary *)userInfo
              completionHandler:(void (^)(void))completionHandler {
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(UNNotificationResponse *)response
             withCompletionHandler:(void (^)(void))completionHandler {
  [self.braze userNotificationCenter:center
      didReceiveNotificationResponse:response
               withCompletionHandler:completionHandler];
}

- (void)pushAuthorizationFromUserNotificationCenter:(BOOL)pushAuthGranted {
  [self.braze pushAuthorizationFromUserNotificationCenter:pushAuthGranted];
}

#endif

- (void)addSdkMetadata:(NSArray<ABKSdkMetadata> *)metadata {
  [self.braze addSdkMetadata:metadata];
}

+ (void)wipeDataAndDisableForAppRun {
  [Braze wipeDataAndDisableForAppRun];
}

+ (void)disableSDK {
  [Braze disableSDK];
}

+ (void)requestEnableSDKOnNextAppRun {
  [Braze requestEnableSDKOnNextAppRun];
}

- (instancetype)initWithBraze:(Braze *)braze {
  self = [super init];
  if (self) {
    _braze = braze;
    _user = [[ABKUser alloc] initWithUser:braze.user];
  }
  return self;
}

@end

#pragma clang diagnostic pop
