import UIKit

let readme =
  """
  This sample demonstrates how to use the analytics features of the SDK.

  See files:
  - AppDelegate.swift
    - Configure Braze
  - AuthenticationManager.swift
    - Identify the user
  - CheckoutViewController.swift
    - Log custom events
    - Log purchases
  """

let actions: [(String, String, (ReadmeViewController) -> Void)] = [
  ("Authenticate user", "Identify the user on Braze", { _ in authenticateUser() }),
  ("Present checkout", #"Log "open_checkout_controller" custom event"#, presentCheckout),
  (
    "Present checkout and purchase a product",
    #"Log "open_checkout_controller" custom event and a purchase"#,
    presentCheckoutAndPurchase
  ),
]

// MARK: - Internal

let authenticationManager = AuthenticationManager()

func authenticateUser() {
  let user = AuthenticationManager.User(
    id: UUID().uuidString,
    email: "user@example.com",
    birthday: Date(timeIntervalSince1970: 0)
  )
  authenticationManager.userDidLogin(user)
}

func presentCheckout(_ viewController: ReadmeViewController) {
  let (navigationController, _) = createCheckoutViewController()
  viewController.present(navigationController, animated: true, completion: nil)
}

func presentCheckoutAndPurchase(_ viewController: ReadmeViewController) {
  let (navigationController, checkoutViewController) = createCheckoutViewController()
  viewController.present(navigationController, animated: true) {
    checkoutViewController.userDidPurchase(productId: UUID().uuidString)
  }
}

func createCheckoutViewController() -> (UINavigationController, CheckoutViewController) {
  let productsIds = [
    UUID().uuidString,
    UUID().uuidString,
    UUID().uuidString,
  ]

  let checkoutViewController = CheckoutViewController()
  checkoutViewController.checkoutId = UUID().uuidString
  checkoutViewController.productIds = productsIds
  checkoutViewController.title = "CheckoutViewController"
  checkoutViewController.view.backgroundColor = .white

  let navigationController = UINavigationController(rootViewController: checkoutViewController)

  return (navigationController, checkoutViewController)
}
