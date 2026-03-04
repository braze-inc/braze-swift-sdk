#import "AuthenticationManager.h"
#import "CheckoutViewController.h"
#import "ReadmeAction.h"
#import "ReadmeViewController.h"

#pragma mark - Internal

static AuthenticationManager *_authenticationManager;

AuthenticationManager *authenticationManager(void) {
  if (!_authenticationManager) {
    _authenticationManager = [[AuthenticationManager alloc] init];
  }
  return _authenticationManager;
}

UINavigationController *createCheckoutNavigationController(void) {
  NSArray<NSString *> *productIds = @[
    [NSUUID UUID].UUIDString,
    [NSUUID UUID].UUIDString,
    [NSUUID UUID].UUIDString,
  ];

  CheckoutViewController *checkoutViewController =
      [[CheckoutViewController alloc] init];
  checkoutViewController.checkoutId = [NSUUID UUID].UUIDString;
  checkoutViewController.productIds = productIds;
  checkoutViewController.title = @"CheckoutViewController";
  checkoutViewController.view.backgroundColor = UIColor.whiteColor;

  UINavigationController *navigationController = [[UINavigationController alloc]
      initWithRootViewController:checkoutViewController];

  return navigationController;
}

void authenticateUser(void) {
  User *user = [[User alloc] init];
  user.identifier = [NSUUID UUID].UUIDString;
  user.email = @"user@example.com";
  user.birthday = [NSDate dateWithTimeIntervalSince1970:0];
  [authenticationManager() userDidLogin:user];
}

void presentCheckout(ReadmeViewController *viewController) {
  UINavigationController *navigationController =
      createCheckoutNavigationController();
  [viewController presentViewController:navigationController
                               animated:YES
                             completion:nil];
}

void presentCheckoutAndPurchase(ReadmeViewController *viewController) {
  UINavigationController *navigationController =
      createCheckoutNavigationController();
  CheckoutViewController *checkoutViewController =
      navigationController.viewControllers.firstObject;
  [viewController
      presentViewController:navigationController
                   animated:YES
                 completion:^{
                   [checkoutViewController
                       userDidPurchaseProduct:[NSUUID UUID].UUIDString];
                 }];
}

#pragma mark - Readme

NSString *const readme =
    @"This sample presents how to use the analytics features of the SDK.\n"
    @"\n"
    @"See files:\n"
    @"- AppDelegate.{h,m}\n"
    @"  - Configure Braze\n"
    @"- AuthenticationManager.m\n"
    @"  - Identify the user\n"
    @"- CheckoutViewController.m\n"
    @"  - Log custom events\n"
    @"  - Log purchases";

NSInteger const actionsCount = 3;

ReadmeAction const actions[] = {{@"Authenticate user",
                                 @"Identify the user on Braze",
                                 ^(ReadmeViewController *_Nonnull _){
                                     authenticateUser();
}
}
, {@"Present checkout", @"Log \"open_checkout_controller\" custom event",
   ^(ReadmeViewController *_Nonnull viewController){
       presentCheckout(viewController);
}
}
, {@"Present checkout and purchase a product",
   @"Log \"open_checkout_controller\" custom event and a purchase",
   ^(ReadmeViewController *_Nonnull viewController){
       presentCheckoutAndPurchase(viewController);
}
}
,
}
;
