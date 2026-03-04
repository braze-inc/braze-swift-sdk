import UIKit

class CheckoutViewController: UIViewController {

  /// The internal checkout identifier
  var checkoutId: String = ""

  /// The list of identifiers for the products to checkout
  var productIds: [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done, target: self, action: #selector(doneButtonSelected)
    )
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    AppDelegate.braze?.logCustomEvent(
      name: "open_checkout_controller",
      properties: [
        "checkout_id": checkoutId,
        "product_ids": productIds,
      ]
    )
  }

  @objc func doneButtonSelected() {
    self.dismiss(animated: true)
  }

  func userDidPurchase(productId: String) {
    let price = self.price(productId: productId)
    AppDelegate.braze?.logPurchase(
      productId: productId,
      currency: "USD",
      price: price,
      properties: ["checkout_id": checkoutId]
    )
  }

  private func price(productId: String) -> Double {
    [0.5, 8.0, 14.99, 0, 999.999].randomElement()!
  }

}
