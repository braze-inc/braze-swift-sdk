@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface CheckoutViewController : UIViewController

/// The internal checkout identifier
@property(copy, nonatomic) NSString *checkoutId;

/// The list of identifiers for the products to checkout
@property(strong, nonatomic) NSArray *productIds;

- (void)userDidPurchaseProduct:(NSString *)productId;

@end

NS_ASSUME_NONNULL_END
