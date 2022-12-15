#import <Foundation/Foundation.h>
#import "BrazePreprocessor.h"

/*!
 * Do not call these methods within your code. They are meant for Braze internal use only.
 */

/*!
 * ABKLocationManagerProvider.h and ABKLocationManagerProvider.m must be added to your project
 * regardless of whether or not you enable location services. This occurs automatically if you integrate/update via the CocoaPod.
 */

/*
 * Braze Public API: ABKLocationManagerProvider
 */

@class CLLocationManager;

NS_ASSUME_NONNULL_BEGIN
BRZ_DEPRECATED("ABKLocationManagerProvider is not supported by Braze anymore.")
@interface ABKLocationManagerProvider : NSObject

+ (BOOL)locationServicesEnabled;

@end
NS_ASSUME_NONNULL_END
