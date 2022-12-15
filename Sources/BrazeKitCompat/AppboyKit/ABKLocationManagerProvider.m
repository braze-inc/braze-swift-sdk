#import "ABKLocationManagerProvider.h"
#import "ABKLocationManagerProvider+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@implementation ABKLocationManagerProvider

+ (BOOL)locationServicesEnabled {
#if !TARGET_OS_TV
  return YES;
#endif
  return NO;
}

@end

#pragma clang diagnostic pop
