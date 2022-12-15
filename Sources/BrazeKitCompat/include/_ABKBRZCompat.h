#import <Foundation/Foundation.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

NS_ASSUME_NONNULL_BEGIN

@class Braze;
@class Appboy;
@class ABKFeedController;
@class ABKContentCardsController;
@class ABKInAppMessageController;
@class ABKLocationManager;
@protocol ABKIDFADelegate;
@protocol ABKSdkAuthenticationDelegate;
@protocol ABKURLDelegate;
@protocol ABKImageDelegate;

@interface _ABKBRZCompat : NSObject

@property (class, strong, nonatomic, readonly) _ABKBRZCompat *shared;
@property (class, copy, nonatomic, readonly) NSString *sdkVersion;

@property (strong, nonatomic, nullable) NSNumber *initialized;
@property (strong, nonatomic, nullable) Braze *braze;
@property (strong, nonatomic, nullable) Appboy *appboy;

@property (strong, nonatomic, readonly) ABKFeedController *feedController;
@property (strong, nonatomic, readonly) ABKContentCardsController *contentCardsController;
@property (strong, nonatomic, nullable) id<ABKIDFADelegate> idfaDelegate;
@property (strong, nonatomic, nullable) id<ABKSdkAuthenticationDelegate> sdkAuthenticationDelegate;
@property (strong, nonatomic, readonly) ABKInAppMessageController *inAppMessageController;
@property (strong, nonatomic, readonly) ABKLocationManager *locationManager;
@property (weak, nonatomic, nullable) id<ABKURLDelegate> appboyUrlDelegate;
@property (strong, nonatomic, nullable) id<ABKImageDelegate> imageDelegate;

+ (void)startWithApiKey:(NSString *)apiKey
          appboyOptions:(nullable NSDictionary *)appboyOptions;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
