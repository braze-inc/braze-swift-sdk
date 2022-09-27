#import "AppDelegate.h"
#import "ReadmeAction.h"
#import "ReadmeViewController.h"

#pragma mark - Internal

void printCurrentContentCards(ReadmeViewController *viewController) {
  [(AppDelegate *)
          UIApplication.sharedApplication.delegate printCurrentContentCards];
}

void refreshContentCards(ReadmeViewController *viewController) {
  [(AppDelegate *)UIApplication.sharedApplication.delegate refreshContentCards];
}

void subscribeToContentCardsUpdates(ReadmeViewController *viewController) {
  [(AppDelegate *)UIApplication.sharedApplication
          .delegate subscribeToContentCardsUpdates];
}

void cancelContentCardsUpdatesSubscription(
    ReadmeViewController *viewController) {
  [(AppDelegate *)UIApplication.sharedApplication
          .delegate cancelContentCardsUpdatesSubscription];
}

void presentContentCardsInfoViewController(
    ReadmeViewController *viewController) {
  [(AppDelegate *)UIApplication.sharedApplication
          .delegate presentContentCardsInfoViewController];
}

#pragma mark - Readme

NSString *const readme = @"This sample demonstrates how to implement your own "
                         @"custom Content Cards UI:\n"
                         @"\n"
                         @"- AppDelegate.{h,m}:\n"
                         @"  - Content cards API usage\n"
                         @"  - Content cards custom UI presentation\n"
                         @"- CardsInfoViewController.{h,m}\n"
                         @"  - UIViewController subclass presenting the "
                         @"content cards data in a table view";

NSInteger const actionsCount = 5;

ReadmeAction const actions[] = {
    {@"Print current Content Cards", @"",
     ^(ReadmeViewController *_Nonnull viewController){
         printCurrentContentCards(viewController);
}
}
, {@"Refresh Content Cards", @"",
   ^(ReadmeViewController *_Nonnull viewController){
       refreshContentCards(viewController);
}
}
, {@"Subscribe to Content Cards updates", @"",
   ^(ReadmeViewController *_Nonnull viewController){
       subscribeToContentCardsUpdates(viewController);
}
}
, {@"Cancel Content Cards updates subscription", @"",
   ^(ReadmeViewController *_Nonnull viewController){
       cancelContentCardsUpdatesSubscription(viewController);
}
}
, {
  @"Present Content Cards Info view controller", @"",
      ^(ReadmeViewController *_Nonnull viewController) {
        presentContentCardsInfoViewController(viewController);
      }
}
}
;
