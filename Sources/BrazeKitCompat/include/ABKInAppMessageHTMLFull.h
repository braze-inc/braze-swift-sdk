#import <Foundation/Foundation.h>
#import "ABKInAppMessageHTMLBase.h"
#import "BrazePreprocessor.h"

/*
 * Braze Public API: ABKInAppMessageHTMLFull
 */
NS_ASSUME_NONNULL_BEGIN
BRZ_DEPRECATED("renamed to 'Braze.InAppMessage.Html'")
@interface ABKInAppMessageHTMLFull : ABKInAppMessageHTMLBase

/*!
 * This property is the remote URL of the assets zip file.
 */
@property (strong, nonatomic, nullable) NSURL *assetsZipRemoteUrl;

@end
NS_ASSUME_NONNULL_END
