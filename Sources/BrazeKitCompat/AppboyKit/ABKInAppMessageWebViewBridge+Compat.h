#import "ABKInAppMessageWebViewBridge.h"

#if !TARGET_OS_TV

@class BRZWebViewBridgeScriptMessageHandler;

@interface ABKInAppMessageWebViewBridge ()

@property(strong, nonatomic) BRZWebViewBridgeScriptMessageHandler *handler;

@end

#endif
