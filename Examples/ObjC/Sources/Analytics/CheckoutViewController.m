#import "CheckoutViewController.h"
#import "AppDelegate.h"

@interface CheckoutViewController ()

- (double)priceForProduct:(NSString *)productId;

@end

@implementation CheckoutViewController

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [AppDelegate.braze logCustomEvent:@"open_checkout_controller"
                         properties:@{
                           @"checkout_id" : self.checkoutId,
                           @"product_ids" : self.productIds,
                         }];
}

- (void)userDidPurchaseProduct:(NSString *)productId {
  double price = [self priceForProduct:productId];
  [AppDelegate.braze logPurchase:productId
                        currency:@"USD"
                           price:price
                      properties:@{@"checkout_id" : self.checkoutId}];
}

- (double)priceForProduct:(NSString *)productId {
  NSArray<NSNumber *> *prices = @[ @0.5, @8.0, @14.99, @0, @999.999 ];
  return prices[arc4random_uniform((uint32_t)prices.count)].doubleValue;
}

@end
