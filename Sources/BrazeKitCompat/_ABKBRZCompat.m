#import "ABKIDFADelegate.h"
#import "ABKURLDelegate.h"
#import "Appboy.h"
#import "AppboyKit/ABKContentCardsController+Compat.h"
#import "AppboyKit/ABKFeedController+Compat.h"
#import "AppboyKit/ABKInAppMessageController+Compat.h"
#import "AppboyKit/ABKLocationManager+Compat.h"
#import "AppboyKit/Appboy+Compat.h"
#import "BRZLog.h"
#import "BrazeDelegateWrapper.h"
#import <objc/runtime.h>

#import "AppboyKit.h"
#import "AppboyKit/ABKLogLevel+Compat.h"
#import "_ABKBRZCompat.h"

@import BrazeLocation;
@import BrazeKit;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

NSString *const ABKRequestProcessingPolicyOptionKey =
    @"ABKRquestProcessingPolicy";
NSString *const ABKFlushIntervalOptionKey = @"ABKFlushInterval";
NSString *const ABKEnableAutomaticLocationCollectionKey =
    @"ABKEnableLocationAutomaticChecking";
NSString *const ABKEnableGeofencesKey = @"ABKEnableGeofencesKey";
NSString *const ABKDisableAutomaticGeofenceRequestsKey =
    @"ABKDisableAutomaticGeofenceRequests";
NSString *const ABKSessionTimeoutKey = @"ABKSessionTimeout";
NSString *const ABKMinimumTriggerTimeIntervalKey =
    @"ABKMinimumTriggerTimeInterval";
NSString *const ABKSDKFlavorKey = @"ABKSDKFlavorKey";
NSString *const ABKDeviceWhitelistKey = @"ABKDeviceWhitelistKey";
NSString *const ABKDeviceAllowlistKey = @"ABKDeviceAllowlistKey";
NSString *const ABKEnableDismissModalOnOutsideTapKey =
    @"ABKEnableDismissModalOnOutsideTap";
NSString *const ABKEnableSDKAuthenticationKey =
    @"ABKEnableSDKAuthenticationKey";
NSString *const ABKIDFADelegateKey = @"ABKIDFADelegate";
NSString *const ABKEndpointKey = @"ABKEndpointKey";
NSString *const ABKInAppMessageControllerDelegateKey =
    @"ABKInAppMessageControllerDelegate";
NSString *const ABKURLDelegateKey = @"ABKURLDelegate";
NSString *const ABKImageDelegateKey = @"ABKImageDelegate";
NSString *const ABKSdkAuthenticationDelegateKey =
    @"ABKSdkAuthenticationDelegate";
NSString *const ABKEphemeralEventsKey = @"ABKEphemeralEvents";
NSString *const ABKPushStoryAppGroupKey = @"ABKPushStoryAppGroupKey";
NSString *const ABKLogLevelKey = @"ABKLogLevelKey";

static NSString *const AppboyAPIKeys = @"AppboyAPIKeys";
static NSString *const ABKPlistSessionTimeoutKey = @"SessionTimeout";
static NSString *const ABKPlistEnableAutomaticLocationCollectionKey =
    @"EnableAutomaticLocationCollection";
static NSString *const ABKPlistEnableGeofencesKey = @"EnableGeofences";
static NSString *const ABKPlistDisableAutomaticGeofenceRequestsKey =
    @"DisableAutomaticGeofenceRequests";
static NSString *const ABKPlistEphemeralEventsKey = @"EphemeralEvents";
static NSString *const ABKPlistPushStoryAppGroupKey = @"PushStoryAppGroup";
static NSString *const ABKPlistEnableDismissModalOnOutsideTap =
    @"DismissModalOnOutsideTap";
static NSString *const ABKPlistEnableSDKAuthenticationKey =
    @"EnableSDKAuthentication";
static NSString *const ABKPlistLogLevelKey = @"LogLevel";
static NSString *const ABKPersistentDataPlistEndpointKey = @"Endpoint";

@interface _ABKBRZCompat ()

@property(assign, nonatomic) BOOL enableDismissModalOnOutsideTap;
@property(strong, nonatomic, readonly) BrazeDelegateWrapper *delegateWrapper;
@property(strong, nonatomic) BRZCancellable *contentCardsSubscription;
@property(strong, nonatomic) BRZCancellable *newsFeedCardsSubscription;

@property(strong, nonatomic, readwrite)
    ABKInAppMessageController *inAppMessageController;

@end

@implementation _ABKBRZCompat
@synthesize feedController = _feedController;
@synthesize contentCardsController = _contentCardsController;
@synthesize delegateWrapper = _delegateWrapper;
@synthesize locationManager = _locationManager;

+ (_ABKBRZCompat *)shared {
  static id shared;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    shared = [[_ABKBRZCompat alloc] init];
  });
  return shared;
}

+ (NSString *)sdkVersion {
  return Braze.sdkVersion;
}

#pragma mark - Singleton

#pragma mark - Start

+ (void)startWithApiKey:(NSString *)apiKey
          appboyOptions:(nullable NSDictionary *)appboyOptions {
  _ABKBRZCompat *shared = _ABKBRZCompat.shared;

  BRZConfiguration *configuration =
      [_ABKBRZCompat configurationWithApiKey:apiKey
                               appboyOptions:appboyOptions];
  Braze *braze = [[Braze alloc] initWithConfiguration:configuration];

  shared.braze = braze;
  shared.appboy = [[Appboy alloc] initWithBraze:braze];

  // Update initialized flag
  shared.initialized = @(YES);

  // Delegates
  // - delegateWrapper is a proxy for old delegates
  braze.delegate = shared.delegateWrapper;

  // - IDFA
  id<ABKIDFADelegate> idfaDelegate = appboyOptions[ABKIDFADelegateKey];
  braze.idfaDelegate = idfaDelegate;

  // - URL Delegate
  id<ABKURLDelegate> urlDelegate = appboyOptions[ABKURLDelegateKey];
  braze.appboyUrlDelegate = urlDelegate;

  // - Image Delegate
  id<ABKImageDelegate> imageDelegate = appboyOptions[ABKImageDelegateKey];
  braze.imageDelegate = imageDelegate;

  if (braze.imageDelegate == nil) {
    Class ABKSDWebImageImageDelegateClass =
        NSClassFromString(@"ABKSDWebImageImageDelegate");
    if (ABKSDWebImageImageDelegateClass != nil) {
      braze.imageDelegate = [[ABKSDWebImageImageDelegateClass alloc] init];
    }
  }

  // - SDKAuthentication Delegate
  id<ABKSdkAuthenticationDelegate> sdkAuthenticationDelegate =
      appboyOptions[ABKSdkAuthenticationDelegateKey];
  braze.sdkAuthenticationDelegate = sdkAuthenticationDelegate;

  // Notifications
  __weak Braze *weakBraze = braze;
  // - Content Cards
  shared.contentCardsSubscription = [braze.contentCards
      subscribeToUpdates:^(
          __unused NSArray<BRZContentCardRaw *> *_Nonnull cards) {
        [NSNotificationCenter.defaultCenter
            postNotificationName:ABKContentCardsProcessedNotification
                          object:weakBraze
                        userInfo:@{
                          ABKContentCardsProcessedIsSuccessfulKey : @(YES)
                        }];
      }];
  // - NewsFeed
  shared.newsFeedCardsSubscription =
      [braze.newsFeed subscribeToUpdates:^(
                          __unused NSArray<BRZNewsFeedCard *> *_Nonnull cards) {
        [NSNotificationCenter.defaultCenter
            postNotificationName:ABKFeedUpdatedNotification
                          object:weakBraze
                        userInfo:@{
                          ABKFeedUpdatedIsSuccessfulKey : @(YES)
                        }];
      }];

  // In-App Messages
  shared.inAppMessageController = [[ABKInAppMessageController alloc]
      initWithInAppMessagePresenter:nil
                    delegateWrapper:shared.delegateWrapper];
  shared.inAppMessageController.enableDismissModalOnOutsideTap =
      shared.enableDismissModalOnOutsideTap;

  // - Dynamically load ABKInAppMessageUIController if available
  BOOL isUISetup = NO;
  Class ABKInAppMessageUIController =
      NSClassFromString(@"ABKInAppMessageUIController");
  if (!isUISetup && ABKInAppMessageUIController) {
    id<BrazeInAppMessagePresenter, ABKInAppMessageUIControlling> uiController =
        [[ABKInAppMessageUIController alloc] init];
    shared.inAppMessageController.inAppMessageUIController = uiController;
    shared.inAppMessageController.presenter = uiController;
    shared.inAppMessageController.isCompatibility = YES;
    braze.inAppMessagePresenter = uiController;
    isUISetup = YES;
  }

  // - Dynamically load BrazeInAppMessageUI if available
  //   ⚠️ This does not includes GIF support. GIF support must be provided
  //   via setting `BRZGIFViewProvider.shared`.
  Class BrazeInAppMessageUI = NSClassFromString(@"BrazeInAppMessageUI");
  if (!isUISetup && BrazeInAppMessageUI) {
    NSObject<BrazeInAppMessagePresenter> *uiPresenter =
        [[BrazeInAppMessageUI alloc] init];
    shared.inAppMessageController.presenter = uiPresenter;
    braze.inAppMessagePresenter = uiPresenter;
    isUISetup = YES;
  }

  // - InAppMessageController Delegate
  id<ABKInAppMessageControllerDelegate> inAppMessageControllerDelegate =
      appboyOptions[ABKInAppMessageControllerDelegateKey];
  shared.inAppMessageController.delegate = inAppMessageControllerDelegate;
}

- (ABKFeedController *)feedController {
  if (_feedController == nil) {
    _feedController =
        [[ABKFeedController alloc] initWithNewsFeedApi:self.braze.newsFeed];
  }
  return _feedController;
}

- (ABKContentCardsController *)contentCardsController {
  if (_contentCardsController == nil) {
    _contentCardsController = [[ABKContentCardsController alloc]
        initWithContentCardsApi:self.braze.contentCards];
  }
  return _contentCardsController;
}

- (id<ABKIDFADelegate>)idfaDelegate {
  return nil;
}

- (void)setIdfaDelegate:(id<ABKIDFADelegate>)idfaDelegate {
  if ([idfaDelegate conformsToProtocol:@protocol(ABKIDFADelegate)]) {
    NSString *idfa = [idfaDelegate advertisingIdentifierString];
    BOOL trackingAuthorized =
        [idfaDelegate isAdvertisingTrackingEnabledOrATTAuthorized];
    [self.braze setIdentifierForAdvertiser:idfa];
    [self.braze setAdTrackingEnabled:trackingAuthorized];
  }
}

- (id<ABKSdkAuthenticationDelegate>)sdkAuthenticationDelegate {
  return self.delegateWrapper.sdkAuthDelegate;
}

- (void)setSdkAuthenticationDelegate:
    (id<ABKSdkAuthenticationDelegate>)sdkAuthenticationDelegate {
  self.delegateWrapper.sdkAuthDelegate = sdkAuthenticationDelegate;
}

- (ABKLocationManager *)locationManager {
  if (_locationManager == nil) {
    _locationManager = [[ABKLocationManager alloc] initWithBraze:self.braze];
  }
  return _locationManager;
}

- (id<ABKURLDelegate>)appboyUrlDelegate {
  return self.delegateWrapper.urlDelegate;
}

- (void)setAppboyUrlDelegate:(id<ABKURLDelegate>)appboyUrlDelegate {
  self.delegateWrapper.urlDelegate = appboyUrlDelegate;
}

#pragma mark - Misc.

- (BrazeDelegateWrapper *)delegateWrapper {
  if (_delegateWrapper == nil) {
    _delegateWrapper = [[BrazeDelegateWrapper alloc] init];
  }
  return _delegateWrapper;
}

#pragma mark - Configuration

+ (BRZConfiguration *)configurationWithApiKey:(NSString *)apiKey
                                appboyOptions:(NSDictionary *)appboyOptions {
  NSDictionary *plist = [_ABKBRZCompat plistDictionary];
  BRZConfiguration *configuration =
      [[BRZConfiguration alloc] initWithApiKey:apiKey
                                      endpoint:@"sdk.iad-01.braze.com"];

  // Request Policy
  ABKRequestProcessingPolicy policy =
      [_ABKBRZCompat integerForKey:ABKRequestProcessingPolicyOptionKey
                      defaultValue:ABKAutomaticRequestProcessing
                         inOptions:appboyOptions
                             plist:plist];
  switch (policy) {
  case ABKManualRequestProcessing:
    configuration.api.requestPolicy = BRZRequestPolicyManual;
    break;
  case ABKAutomaticRequestProcessing:
    configuration.api.requestPolicy = BRZRequestPolicyAutomatic;
    break;
  default:
    break;
  }

  // Flush interval
  NSNumber *flushInterval =
      [_ABKBRZCompat numberForKey:ABKFlushIntervalOptionKey
                     defaultValue:@(configuration.api.flushInterval)
                        inOptions:appboyOptions
                            plist:plist];
  configuration.api.flushInterval = [flushInterval doubleValue];

  // Automatic Location Collection
  BOOL automaticLocationCollection = [_ABKBRZCompat
      booleanForKey:ABKEnableAutomaticLocationCollectionKey
       defaultValue:configuration.location.automaticLocationCollection
          inOptions:appboyOptions
              plist:plist];
  configuration.location.automaticLocationCollection =
      automaticLocationCollection;

  // Enable Geofences
  BOOL enableGeofences =
      [_ABKBRZCompat booleanForKey:ABKEnableGeofencesKey
                      defaultValue:configuration.location.geofencesEnabled
                         inOptions:appboyOptions
                             plist:plist];
  configuration.location.geofencesEnabled = enableGeofences;

  // Disable Automatic Geofences Requests
  BOOL disableAutomaticGeofencesRequest = [_ABKBRZCompat
      booleanForKey:ABKDisableAutomaticGeofenceRequestsKey
       defaultValue:!configuration.location.automaticGeofenceRequests
          inOptions:appboyOptions
              plist:plist];
  configuration.location.automaticGeofenceRequests =
      !disableAutomaticGeofencesRequest;

  // Automatically add BrazeLocationProvider when needed
  if (automaticLocationCollection || enableGeofences) {
    configuration.location.brazeLocationProvider = [[BrazeLocationProvider alloc] init];
  }

  // Endpoint
  NSString *endpoint = [_ABKBRZCompat stringForKey:ABKEndpointKey
                                      defaultValue:configuration.api.endpoint
                                         inOptions:appboyOptions
                                             plist:plist];
  configuration.api.endpoint = endpoint;

  // EnableDismissModalOnOutsideTap
  BOOL enableDismissModalOnOutsideTap =
      [_ABKBRZCompat booleanForKey:ABKEnableDismissModalOnOutsideTapKey
                      defaultValue:NO
                         inOptions:appboyOptions
                             plist:plist];
  _ABKBRZCompat.shared.enableDismissModalOnOutsideTap =
      enableDismissModalOnOutsideTap;

  // SDK Authentication
  BOOL enableSDKAuthentication =
      [_ABKBRZCompat booleanForKey:ABKEnableSDKAuthenticationKey
                      defaultValue:configuration.api.sdkAuthentication
                         inOptions:appboyOptions
                             plist:plist];
  configuration.api.sdkAuthentication = enableSDKAuthentication;

  // Session Timeout
  NSInteger sessionTimeout =
      [_ABKBRZCompat integerForKey:ABKSessionTimeoutKey
                      defaultValue:configuration.sessionTimeout
                         inOptions:appboyOptions
                             plist:plist];
  configuration.sessionTimeout = sessionTimeout;

  // Minimum Trigger TimerInterval
  NSNumber *triggerMinimumTimeInterval =
      [_ABKBRZCompat numberForKey:ABKMinimumTriggerTimeIntervalKey
                     defaultValue:@(configuration.triggerMinimumTimeInterval)
                        inOptions:appboyOptions
                            plist:plist];
  configuration.triggerMinimumTimeInterval =
      [triggerMinimumTimeInterval doubleValue];

  // SDK Flavor
  ABKSDKFlavor sdkFlavor = [_ABKBRZCompat integerForKey:ABKSDKFlavorKey
                                           defaultValue:0
                                              inOptions:appboyOptions
                                                  plist:plist];
  // - BRZSDKFlavor matches ABKSDKFlavor, we can directly assign here.
  configuration.api.sdkFlavor = (BRZSDKFlavor)sdkFlavor;

  // Device Allow List
  configuration.devicePropertyAllowList = [_ABKBRZCompat
      devicePropertiesInOptions:appboyOptions
                   defaultValue:configuration.devicePropertyAllowList];

  // Ephemeral Events
  NSArray *ephemeralEvents = [_ABKBRZCompat arrayForKey:ABKEphemeralEventsKey
                                              inOptions:appboyOptions
                                                  plist:plist];
  configuration.ephemeralEvents = ephemeralEvents;

  // Push Story App Group
  NSString *pushStoryAppGroup =
      [_ABKBRZCompat stringForKey:ABKPushStoryAppGroupKey
                     defaultValue:nil
                        inOptions:appboyOptions
                            plist:plist];
  configuration.push.appGroup = pushStoryAppGroup;

  // Log Level
  ABKLogLevel logLevel =
      (ABKLogLevel)[_ABKBRZCompat integerForKey:ABKLogLevelKey
                                   defaultValue:ABKLogError
                                      inOptions:appboyOptions
                                          plist:plist];
  if (logLevel <= 0) {
    logLevel = ABKLogDebug;
  }
  switch (logLevel) {
  case ABKLogDebug:
    configuration.logger.level = BRZLoggerLevelDebug;
    break;
  case ABKLogWarn:
    configuration.logger.level = BRZLoggerLevelInfo;
    break;
  case ABKLogError:
    configuration.logger.level = BRZLoggerLevelError;
    break;
  case ABKDoNotLog:
    configuration.logger.level = BRZLoggerLevelDisabled;
    break;
  default:
    break;
  }

  return configuration;
}

#pragma mark - Configuration Helpers

+ (NSDictionary *)plistDictionary {
  NSDictionary *infoPlist = [NSBundle mainBundle].infoDictionary;
  NSDictionary *brazeDict = infoPlist[@"Braze"];
  NSDictionary *appboyDict = infoPlist[@"Appboy"];
  if (!brazeDict && !appboyDict) {
    return nil;
  }
  return [_ABKBRZCompat merge:appboyDict with:brazeDict];
}

+ (NSString *)stringForKey:(NSString *)key
              defaultValue:(NSString *)defaultValue
                 inOptions:(NSDictionary *)options
                     plist:(NSDictionary *)plist {
  id value = options[key];
  if (value && [value isKindOfClass:[NSString class]]) {
    return value;
  }
  value = plist[[_ABKBRZCompat plistKeyForKey:key]];
  if (value && [value isKindOfClass:[NSString class]]) {
    return value;
  }
  return defaultValue;
}

+ (NSInteger)integerForKey:(NSString *)key
              defaultValue:(NSInteger)defaultValue
                 inOptions:(NSDictionary *)options
                     plist:(NSDictionary *)plist {
  id value = options[key];
  if (value && [value respondsToSelector:@selector(integerValue)]) {
    return [value integerValue];
  }
  value = plist[[_ABKBRZCompat plistKeyForKey:key]];
  if (value && [value respondsToSelector:@selector(integerValue)]) {
    return [value integerValue];
  }
  return defaultValue;
}

+ (NSNumber *)numberForKey:(NSString *)key
              defaultValue:(NSNumber *)defaultValue
                 inOptions:(NSDictionary *)options
                     plist:(NSDictionary *)plist {
  id value = options[key];
  if (value && [value respondsToSelector:@selector(doubleValue)]) {
    return @([value doubleValue]);
  }
  value = plist[[_ABKBRZCompat plistKeyForKey:key]];
  if (value && [value respondsToSelector:@selector(doubleValue)]) {
    return @([value doubleValue]);
  }
  return defaultValue;
}

+ (BOOL)booleanForKey:(NSString *)key
         defaultValue:(BOOL)defaultValue
            inOptions:(NSDictionary *)options
                plist:(NSDictionary *)plist {
  id value = options[key];
  if (value && [value respondsToSelector:@selector(boolValue)]) {
    return [value boolValue];
  }
  value = plist[[_ABKBRZCompat plistKeyForKey:key]];
  if (value && [value respondsToSelector:@selector(boolValue)]) {
    return [value boolValue];
  }
  return defaultValue;
}

+ (nullable NSArray *)arrayForKey:(NSString *)key
                        inOptions:(NSDictionary *)options
                            plist:(NSDictionary *)plist {
  id value = options[key];
  if ([value isKindOfClass:[NSArray class]] &&
      [_ABKBRZCompat objectIsValidAndNotEmpty:value]) {
    return value;
  }
  value = plist[[_ABKBRZCompat plistKeyForKey:key]];
  if ([value isKindOfClass:[NSArray class]] &&
      [_ABKBRZCompat objectIsValidAndNotEmpty:value]) {
    return value;
  }
  return nil;
}

+ (id)idForKey:(NSString *)key
     inOptions:(NSDictionary *)options
         plist:(NSDictionary *)plist {
  if (options[key]) {
    return options[key];
  }
  return plist[[_ABKBRZCompat plistKeyForKey:key]];
}

+ (NSString *)plistKeyForKey:(NSString *)key {
  static dispatch_once_t once;
  static NSDictionary *optionsToPlistKeysMap;
  dispatch_once(&once, ^{
    optionsToPlistKeysMap = @{
      ABKEndpointKey : ABKPersistentDataPlistEndpointKey,
      ABKSessionTimeoutKey : ABKPlistSessionTimeoutKey,
      ABKEnableDismissModalOnOutsideTapKey :
          ABKPlistEnableDismissModalOnOutsideTap,
      ABKEnableAutomaticLocationCollectionKey :
          ABKPlistEnableAutomaticLocationCollectionKey,
      ABKEnableGeofencesKey : ABKPlistEnableGeofencesKey,
      ABKDisableAutomaticGeofenceRequestsKey :
          ABKPlistDisableAutomaticGeofenceRequestsKey,
      ABKPushStoryAppGroupKey : ABKPlistPushStoryAppGroupKey,
      ABKEnableSDKAuthenticationKey : ABKPlistEnableSDKAuthenticationKey,
      ABKLogLevelKey : ABKPlistLogLevelKey,
      ABKEphemeralEventsKey : ABKPlistEphemeralEventsKey
    };
  });

  NSString *plistKey = optionsToPlistKeysMap[key];
  if (plistKey) {
    return plistKey;
  }
  return key;
}

+ (NSArray<BRZDeviceProperty *> *)
    devicePropertiesInOptions:(NSDictionary *)options
                 defaultValue:(NSArray<BRZDeviceProperty *> *)defaultValue {
  // Use a non-representable ABKDeviceOptions to mark an invalid default value.
  NSUInteger invalid = 0x8BADF00D;
  ABKDeviceOptions allowList =
      [_ABKBRZCompat integerForKey:ABKDeviceAllowlistKey
                      defaultValue:invalid
                         inOptions:options
                             plist:nil];
  if (allowList == invalid) {
    allowList = [_ABKBRZCompat integerForKey:ABKDeviceWhitelistKey
                                defaultValue:invalid
                                   inOptions:options
                                       plist:nil];
  }

  if (allowList == invalid) {
    return defaultValue;
  }

  NSMutableArray<BRZDeviceProperty *> *deviceProperties =
      [NSMutableArray array];
  if (allowList & ABKDeviceOptionResolution) {
    [deviceProperties addObject:BRZDeviceProperty.resolution];
  }
  if (allowList & ABKDeviceOptionCarrier) {
    [deviceProperties addObject:BRZDeviceProperty.carrier];
  }
  if (allowList & ABKDeviceOptionLocale) {
    [deviceProperties addObject:BRZDeviceProperty.locale];
  }
  if (allowList & ABKDeviceOptionModel) {
    [deviceProperties addObject:BRZDeviceProperty.model];
  }
  if (allowList & ABKDeviceOptionOSVersion) {
    [deviceProperties addObject:BRZDeviceProperty.osVersion];
  }
  if (allowList & ABKDeviceOptionIDFV) {
    NSLog(@"[BrazeKitCompat] Warning: use `braze.set(identifierForVendor:)` to set the identifier for vendor.");
  }
  if (allowList & ABKDeviceOptionIDFA) {
    NSLog(@"[BrazeKitCompat] Warning: use `braze.set(identifierForAdvertiser:)` to set the identifier for advertiser.");
  }
  if (allowList & ABKDeviceOptionPushEnabled) {
    [deviceProperties addObject:BRZDeviceProperty.pushEnabled];
  }
  if (allowList & ABKDeviceOptionTimezone) {
    [deviceProperties addObject:BRZDeviceProperty.timeZone];
  }
  if (allowList & ABKDeviceOptionPushAuthStatus) {
    [deviceProperties addObject:BRZDeviceProperty.pushAuthStatus];
  }
  if (allowList & ABKDeviceOptionAdTrackingEnabled) {
    NSLog(@"[BrazeKitCompat] Warning: use `braze.set(adTrackingEnabled:)` to set the ad tracking enabled flag.");
  }
  if (allowList & ABKDeviceOptionPushDisplayOptions) {
    [deviceProperties addObject:BRZDeviceProperty.pushDisplayOptions];
  }

  return deviceProperties;
}

+ (BOOL)objectIsValidAndNotEmpty:(id)object {
  if (object == nil || object == [NSNull null]) {
    return NO;
  }
  if ([object isKindOfClass:[NSArray class]] ||
      [object isKindOfClass:[NSDictionary class]]) {
    return [object count] > 0;
  }
  if ([object isKindOfClass:[NSString class]]) {
    return [object length] > 0;
  }
  if ([object isKindOfClass:[NSURL class]]) {
    return [[object absoluteString] length] > 0;
  }
  return YES;
}

+ (NSDictionary *)merge:(NSDictionary *)dict1 with:(NSDictionary *)dict2 {
  NSMutableDictionary *result =
      [NSMutableDictionary dictionaryWithDictionary:dict1];
  [dict2 enumerateKeysAndObjectsUsingBlock:^(id key, id obj,
                                             __unused BOOL *stop) {
    id dict1ObjectForKey = dict1[key];
    if (dict1ObjectForKey) {
      if ([obj isKindOfClass:[NSDictionary class]]) {
        if ([dict1ObjectForKey isKindOfClass:[NSDictionary class]]) {
          NSDictionary *newVal = [_ABKBRZCompat merge:dict1ObjectForKey
                                                 with:(NSDictionary *)obj];
          result[key] = newVal;
        } else {
          result[key] = obj;
        }
      } else {
        if (![dict1ObjectForKey isKindOfClass:[NSDictionary class]] && obj) {
          result[key] = obj;
        } else {
          result[key] = dict1ObjectForKey;
        }
      }
    } else {
      result[key] = obj;
    }
  }];

  return (NSDictionary *)[result mutableCopy];
}

@end

#pragma clang diagnostic pop
