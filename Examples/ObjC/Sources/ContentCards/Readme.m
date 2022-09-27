#import "AppDelegate.h"
#import "ReadmeAction.h"
#import "ReadmeViewController.h"

#pragma mark - Internal

void pushContentCardsViewController(ReadmeViewController *viewController) {
  [(AppDelegate *)UIApplication.sharedApplication
          .delegate pushContentCardsViewController];
}

void presentModalContentCardsViewController(
    ReadmeViewController *viewController) {
  [(AppDelegate *)UIApplication.sharedApplication
          .delegate presentModalContentCardsViewController];
}

void presentModalContentCardsViewControllerCustomized(
    ReadmeViewController *viewController) {
  [(AppDelegate *)UIApplication.sharedApplication
          .delegate presentModalContentCardsViewControllerCustomized];
}

#pragma mark - Readme

NSString *const readme =
    @"This sample presents how to use the Braze provided content cards UI:\n"
    @"\n"
    @"- AppDelegate.{h,m}:\n"
    @"  - Content cards UI presentation\n"
    @"  - Content cards UI delegate\n"
    @"- BRZGIFViewProvider+SDWebImage.{h,m}\n"
    @"  - Use SDWebImage to provide GIF support to the Braze UI components";

NSInteger const actionsCount = 3;

ReadmeAction const actions[] = {
    {@"Push content cards view controller", @"",
     ^(ReadmeViewController *_Nonnull viewController){
         pushContentCardsViewController(viewController);
}
}
, {@"Present modal content cards view controller", @"",
   ^(ReadmeViewController *_Nonnull viewController){
       presentModalContentCardsViewController(viewController);
}
}
, {
  @"Present modal content cards view controller", @"(customized)",
      ^(ReadmeViewController *_Nonnull viewController) {
        presentModalContentCardsViewControllerCustomized(viewController);
      }
}
}
;
