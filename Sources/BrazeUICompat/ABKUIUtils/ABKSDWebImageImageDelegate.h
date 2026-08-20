#import "ABKImageDelegate.h"

#if __has_include(<BrazeKitCompat/BrazePreprocessor.h>)
  #import <BrazeKitCompat/BrazePreprocessor.h>
#else
  #import "BrazePreprocessor.h"
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


NS_ASSUME_NONNULL_BEGIN

BRZ_DEPRECATED("ABKSDWebImageImageDelegate is not needed anymore")
@interface ABKSDWebImageImageDelegate : NSObject<ABKImageDelegate>

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
