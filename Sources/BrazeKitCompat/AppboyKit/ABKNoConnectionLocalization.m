#import "ABKNoConnectionLocalization.h"
#import "ABKNoConnectionLocalization+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKNoConnectionLocalization

+ (NSString *)getNoConnectionLocalizedString {
  return [Braze _localize:@"braze.webview.no-connection"];
}

@end

#pragma clang diagnostic pop
