#import "ReadmeAction.h"
#import "ReadmeViewController.h"
#import "AppDelegate.h"

#pragma mark - Readme

void initializeBraze(ReadmeViewController *viewController) {
  [AppDelegate initializeBraze];
  
  // Disable cell
  for (UITableViewCell *cell in viewController.tableView.visibleCells) {
    cell.userInteractionEnabled = NO;
    cell.textLabel.textColor = UIColor.systemGrayColor;
    cell.detailTextLabel.textColor = UIColor.systemGrayColor;
  }
  
}

#pragma mark - Readme

NSString *const readme =
    @"This sample presents a complete push notification integration allowing the SDK to be"
    @" initialized asynchronously. This is an extension of the PushNotifications-Automatic sample"
    @" application.\n"
    @"\n"
    @"- PushNotifications/AppDelegate.{h,m}:\n"
    @"  - Delayed SDK initialization support\n"
    @"  - Automatic push support via SDK configuration\n"
    @"\n"
    @"- PushNotificationsServiceExtension:\n"
    @"  - Rich push notification support (image, GIF, audio, video)\n"
    @"\n"
    @"- PushNotificationsContentExtension:\n"
    @"  - Braze Push Story implementation";

NSInteger const actionsCount = 1;

ReadmeAction const actions[] = {
  {
    @"Initialize Braze",
    @"",
    ^(ReadmeViewController *_Nonnull viewController) { initializeBraze(viewController); }
  }
};
