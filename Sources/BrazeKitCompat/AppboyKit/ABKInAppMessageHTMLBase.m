#import "ABKInAppMessageHTMLBase.h"
#import "ABKInAppMessage+Compat.h"
#import "ABKInAppMessageHTMLBase+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@import BrazeKit;

@implementation ABKInAppMessageHTMLBase

- (NSURL *)assetsLocalDirectoryPath {
  if (self.inAppMessage && self.inAppMessage.baseURL) {
    return self.inAppMessage.baseURL;
  } else {
    NSLog(@"[BrazeKitCompat] Error: invalid in-app message baseURL, returning 'localhost' as assetsLocalDirectoryPath.");
    return [NSURL URLWithString:@"localhost"];
  }
}

- (void)setAssetsLocalDirectoryPath:(NSURL *)assetsLocalDirectoryPath {
  self.inAppMessage.baseURL = assetsLocalDirectoryPath;
}

- (void)logInAppMessageHTMLClickWithButtonID:(NSString *)buttonId {
  [self.inAppMessage.context logClickWithButtonId:buttonId];
}

@end

#pragma clang diagnostic pop
