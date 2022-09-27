#import "AppDelegate.h"
#import "ReadmeAction.h"
#import "ReadmeViewController.h"

@import BrazeKit;

#pragma mark - Internal

void localSlideup(ReadmeViewController *viewController) {
  BRZInAppMessageRaw *slideup = [[BRZInAppMessageRaw alloc] init];
  slideup.type = BRZInAppMessageRawTypeSlideup;
  slideup.icon = @"";
  slideup.message = @"Local slideup in-app message";
  [AppDelegate.braze.inAppMessagePresenter presentMessage:slideup];
}

void localModal(ReadmeViewController *viewController) {
  BRZInAppMessageRaw *modal = [[BRZInAppMessageRaw alloc] init];
  modal.type = BRZInAppMessageRawTypeModal;
  modal.icon = @"";
  modal.header = @"Header text";
  modal.message = @"Local modal in-app message";
  [AppDelegate.braze.inAppMessagePresenter presentMessage:modal];
}

#pragma mark - Readme

NSString *const readme =
    @"This sample presents how to use the Braze provided in-app message UI:\n"
    @"\n"
    @"- AppDelegate.{h,m}\n"
    @"  - In-app message UI configuration\n"
    @"  - In-app message UI delegate\n"
    @"- BRZGIFViewProvider+SDWebImage.{h,m}\n"
    @"  - Use SDWebImage to provide GIF support to the Braze UI components";

NSInteger const actionsCount = 2;

ReadmeAction const actions[] = {
    {@"Present local slideup in-app message", @"",
     ^(ReadmeViewController *_Nonnull viewController){
         localSlideup(viewController);
}
}
, {@"Present local modal in-app message", @"",
   ^(ReadmeViewController *_Nonnull viewController){
       localModal(viewController);
}
}
,
}
;
