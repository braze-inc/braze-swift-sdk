#import <UIKit/UIKit.h>
#import "BrazePreprocessor.h"

#if !TARGET_OS_TV

#import <WebKit/WebKit.h>

BRZ_DEPRECATED("renamed to 'Braze.WebViewController'")
@interface ABKModalWebViewController : UINavigationController <WKNavigationDelegate>

/*!
 * The url the modal web view controller should open. Please note that this is the initial url and
 * won't be updated if the initial url re-directs to another url.
 */
@property NSURL *url;

/*!
 * The WKWebView which displays the web view.
 */
@property (nonatomic) IBOutlet WKWebView *webView;

/*!
 * The UIProgressView which shows the web view loading process. It will be on top of the web view and
 * will disappear as soon as the page is loaded.
 */
@property (nonatomic) IBOutlet UIProgressView *progressBar;

@end

#endif
