#import "ABKInAppMessageHTMLFull.h"
#import "../BRZLog.h"
#import "ABKInAppMessageHTMLFull+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
@implementation ABKInAppMessageHTMLFull

- (NSURL *)assetsZipRemoteUrl {
  LogUnimplemented();
  return nil;
}

- (void)setAssetsZipRemoteUrl:(NSURL *)assetsZipRemoteUrl {
  LogUnimplemented();
}

@end

#pragma clang diagnostic pop
