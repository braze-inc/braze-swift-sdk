#import <Foundation/Foundation.h>

#if !TARGET_OS_TV

#import <WebKit/WebKit.h>
#import "ABKInAppMessageHTML.h"
#import "BrazePreprocessor.h"

NS_ASSUME_NONNULL_BEGIN

@class Appboy;
@class ABKInAppMessageHTML;
@protocol ABKInAppMessageWebViewBridgeDelegate;

#pragma mark - ABKInAppMessageWebViewBridge

/*!
 * The webview bridge
 * @discussion The bridge is automatically setup on initialization and destroyed on dealloc. The bridge
 * needs to be retained to stay enabled. Keep a strong instance of the bridge in a property to do so
 */
BRZ_DEPRECATED("renamed to 'Braze.WebViewBridge.ScriptMessageHandler'")
@interface ABKInAppMessageWebViewBridge : NSObject <WKScriptMessageHandler>

/*!
 * The delegate instance
 */
@property (nonatomic, weak) id<ABKInAppMessageWebViewBridgeDelegate> delegate;

/*!
 * Initialize an instance of ABKInAppMessageWebViewBridge
 * @param webView The WKWebView in which the bridge needs to be setup
 * @param inAppMessage The InAppMessage being displayed
 * @param appboy The Appboy instance
 */
- (instancetype)initWithWebView:(WKWebView *)webView
                   inAppMessage:(ABKInAppMessageHTML *)inAppMessage
                 appboyInstance:(Appboy *)appboy;

@end

#pragma mark - ABKInAppMessageWebViewBridgeDelegate

/*!
 * Methods for managing bridge related actions
 */
BRZ_DEPRECATED("ABKInAppMessageWebViewBridgeDelegate is not supported by Braze anymore")
@protocol ABKInAppMessageWebViewBridgeDelegate <NSObject>

/*!
 * Tells the delegate that the bridge has received a click action to execute
 * @param webViewBridge The bridge informing the delegate
 * @param clickAction The clickAction performed
 */
- (void)webViewBridge:(ABKInAppMessageWebViewBridge *)webViewBridge
  receivedClickAction:(ABKInAppMessageClickActionType)clickAction;

/*!
 * Tells the delegate that a close message action was received
 * @param webViewBridge The bridge informing the delegate
 */
- (void)closeMessageWithWebViewBridge:(ABKInAppMessageWebViewBridge *)webViewBridge;

@end

NS_ASSUME_NONNULL_END

#endif
