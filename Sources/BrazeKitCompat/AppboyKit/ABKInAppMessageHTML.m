#import "ABKInAppMessageHTML.h"
#import "../BRZLog.h"
#import "ABKInAppMessage+Compat.h"
#import "ABKInAppMessageHTML+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKInAppMessageHTML

- (BOOL)trusted {
  LogUnimplemented();
  return NO;
}

- (void)setTrusted:(BOOL)trusted {
  LogUnimplemented();
}

- (NSArray *)assetUrls {
  NSMutableArray *assetUrls = [NSMutableArray array];
  for (NSURL *assetUrl in self.inAppMessage.assetURLs) {
    [assetUrls addObject:assetUrl.absoluteString];
  }
  return [assetUrls copy];
}

- (void)setAssetUrls:(NSArray *)assetUrls {
  NSMutableArray *urls = [NSMutableArray array];
  for (NSString *assetUrl in assetUrls) {
    NSURL *url = [NSURL URLWithString:assetUrl];
    if (url) {
      [urls addObject:url];
    }
  }
  self.inAppMessage.assetURLs = [urls copy];
}

- (NSDictionary *)messageFields {
  LogUnimplemented();
  return nil;
}

- (void)setMessageFields:(NSDictionary *)messageFields {
  LogUnimplemented();
}

@end

#pragma clang diagnostic pop
