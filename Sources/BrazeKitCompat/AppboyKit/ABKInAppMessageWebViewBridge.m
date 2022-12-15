#import "ABKInAppMessageWebViewBridge.h"
#import "ABKInAppMessageWebViewBridge+Compat.h"
#import "Appboy+Compat.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

#if !TARGET_OS_TV

@import BrazeKit;
@import WebKit;

@interface ABKInAppMessageWebViewBridge ()

@property(nonatomic, weak) WKWebView *webView;

@end

@implementation ABKInAppMessageWebViewBridge

- (instancetype)initWithWebView:(WKWebView *)webView
                   inAppMessage:(ABKInAppMessageHTML *)inAppMessage
                 appboyInstance:(Appboy *)appboy {
  self = [super init];
  if (self) {
    self.webView = webView;
    __weak typeof(self) weakSelf = self;
    __weak typeof(inAppMessage) weakMessage = inAppMessage;
    // Create handler
    BRZWebViewBridgeScriptMessageHandler *handler =
        [[BRZWebViewBridgeScriptMessageHandler alloc]
            initWithLogClick:^(NSString *_Nullable buttonId) {
              if (buttonId && buttonId.length > 0) {
                [weakMessage logInAppMessageHTMLClickWithButtonID:buttonId];
              } else {
                [weakMessage logInAppMessageClicked];
              }
            }
            logError:^(NSError *_Nonnull error) {
              NSLog(@"[BrazeKitCompat] ABKInAppMessageWebViewBridge Error: %@",
                    error.localizedDescription);
            }
            showNewsFeed:^{
              if ([weakSelf.delegate respondsToSelector:@selector
                                     (webViewBridge:receivedClickAction:)]) {
                [weakSelf.delegate
                          webViewBridge:weakSelf
                    receivedClickAction:ABKInAppMessageDisplayNewsFeed];
              }
            }
            closeMessage:^{
              if ([weakSelf.delegate respondsToSelector:@selector
                                     (closeMessageWithWebViewBridge:)]) {
                [weakSelf.delegate closeMessageWithWebViewBridge:weakSelf];
              }
            }
            braze:appboy.braze];
    self.handler = handler;

    // Attach to the web view
    WKUserContentController *userContentController =
        webView.configuration.userContentController;
    [userContentController
        addUserScript:BRZWebViewBridgeScriptMessageHandler.script];
    [userContentController
        addScriptMessageHandler:handler
                           name:BRZWebViewBridgeScriptMessageHandler.name];
  }
  return self;
}

- (void)dealloc {
  WKUserContentController *userContentController =
      self.webView.configuration.userContentController;
  [userContentController removeAllUserScripts];
  [userContentController
      removeScriptMessageHandlerForName:BRZWebViewBridgeScriptMessageHandler
                                            .name];
}

- (void)userContentController:
            (nonnull WKUserContentController *)userContentController
      didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
  // Nothing to do here, `ABKInAppMessageWebViewBridge` is a
  // `WKScriptMessageHandler` for historical reasons.
}

@end

#endif

#pragma clang diagnostic pop
