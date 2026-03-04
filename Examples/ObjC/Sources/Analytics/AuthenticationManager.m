#import "AuthenticationManager.h"
#import "AppDelegate.h"

#pragma mark - User

@implementation User
@end

#pragma mark - AuthenticationManager

@implementation AuthenticationManager

- (void)userDidLogin:(User *)user {
  [AppDelegate.braze changeUser:user.identifier];
  BRZUser *brazeUser = AppDelegate.braze.user;
  [brazeUser setEmail:user.email];
  [brazeUser setDateOfBirth:user.birthday];
  [brazeUser setCustomAttributeWithKey:@"last_login_date"
                             dateValue:[NSDate date]];
}

@end
