#import "AppDelegate.h"
#import "ReadmeAction.h"
#import "ReadmeViewController.h"

#pragma mark - Internal

void localSlideup(ReadmeViewController *viewController) {
  BRZInAppMessageRaw *slideup = [[BRZInAppMessageRaw alloc] init];
  slideup.type = BRZInAppMessageRawTypeSlideup;
  slideup.clickAction = BRZInAppMessageRawClickActionURL;
  slideup.url = [NSURL URLWithString:@"https://example.com"];
  slideup.useWebView = YES;
  slideup.extras = @{@"key1" : @"value1", @"key2" : @"value2"};
  slideup.icon = @"";
  slideup.message = @"Local slideup in-app message";

  [AppDelegate.braze.inAppMessagePresenter presentMessage:slideup];
}

void localModal(ReadmeViewController *viewController) {
  BRZInAppMessageRaw *modal = [[BRZInAppMessageRaw alloc] init];
  modal.type = BRZInAppMessageRawTypeModal;
  modal.clickAction = BRZInAppMessageRawClickActionURL;
  modal.url = [NSURL URLWithString:@"https://example.com"];
  modal.useWebView = YES;
  modal.extras = @{@"key1" : @"value1", @"key2" : @"value2"};
  modal.icon = @"";
  modal.header = @"Header text";
  modal.message = @"Local modal in-app message";

  [AppDelegate.braze.inAppMessagePresenter presentMessage:modal];
}

#pragma mark - Readme

NSString *const readme =
    @"This sample presents how to implement your own custom In-App Message "
    @"UI:\n"
    @"\n"
    @"- AppDelegate.{h,m}:\n"
    @"  - Sets the custom in-app message presenter\n"
    @"- CustomInAppMessagePresenter.{h,m}\n"
    @"  - Explains how to use the `BRZInAppMessageRaw` data model and present "
    @"the message in a custom view controller.";

NSInteger const actionsCount = 2;

ReadmeAction const actions[] = {
    {@"Present local slideup in-app message", @"",
     ^(ReadmeViewController *_Nonnull viewController){
         localSlideup(viewController);
}
}
, {
  @"Present local modal in-app message", @"",
      ^(ReadmeViewController *_Nonnull viewController) {
        localModal(viewController);
      }
}
}
;
