import BrazeUI
import UIKit

final class FullScreenBannerViewController: UIViewController {

  static let bannerPlacementID = "sdk-test-1"

  var hasBannerForPlacement: Bool = false {
    didSet {
      self.bannerView.isHidden = !hasBannerForPlacement
      self.errorView.isHidden = hasBannerForPlacement
    }
  }

  lazy var bannerView: BrazeBannerUI.BannerUIView = {
    var bannerView = BrazeBannerUI.BannerUIView(
      placementId: FullScreenBannerViewController.bannerPlacementID,
      braze: AppDelegate.braze!,
      processContentUpdates: { [weak self] result in
        // Update layout properties when banner content has finished loading.
        DispatchQueue.main.async {
          guard let self else { return }

          switch result {
          case .success(_):
            self.hasBannerForPlacement = true
          case .failure(_):
            self.hasBannerForPlacement = false
          }
        }
      }
    )

    bannerView.translatesAutoresizingMaskIntoConstraints = false
    bannerView.isHidden = true

    return bannerView
  }()

  lazy var errorView: UILabel = {
    let errorView = UILabel()
    errorView.text = "An error occurred while loading the banner."
    errorView.textAlignment = .center
    errorView.translatesAutoresizingMaskIntoConstraints = false
    errorView.isHidden = true
    return errorView
  }()

  override func loadView() {
    super.loadView()

    view.backgroundColor = .white
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.addSubview(bannerView)
    self.view.addSubview(errorView)

    NSLayoutConstraint.activate([
      bannerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      bannerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      bannerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      bannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

      errorView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      errorView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      errorView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      errorView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
    ])

    AppDelegate.braze?.banners.getBanner(for: FullScreenBannerViewController.bannerPlacementID) {
      [weak self] banner in
      self?.hasBannerForPlacement = banner != nil
    }
  }
}
