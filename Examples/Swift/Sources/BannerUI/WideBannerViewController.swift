import BrazeUI
import UIKit

final class WideBannerViewController: UIViewController {

  static let bannerPlacementID = "sdk-test-2"

  var bannerHeightConstraint: NSLayoutConstraint?

  lazy var contentView: UILabel = {
    let contentView = UILabel()
    contentView.text = "Your Content Here"
    contentView.textAlignment = .center
    contentView.translatesAutoresizingMaskIntoConstraints = false
    return contentView
  }()

  lazy var bannerView: BrazeBannerUI.BannerUIView = {
    var bannerView = BrazeBannerUI.BannerUIView(
      placementId: WideBannerViewController.bannerPlacementID,
      braze: AppDelegate.braze!,
      processContentUpdates: { [weak self] result in
        // Update layout properties when banner content has finished loading.
        DispatchQueue.main.async {
          guard let self else { return }

          switch result {
          case .success(let updates):
            if let height = updates.height {
              self.bannerView.isHidden = false
              self.bannerHeightConstraint?.constant = min(height, 80)
            }
          case .failure(let error):
            return
          }
        }
      }
    )

    bannerView.translatesAutoresizingMaskIntoConstraints = false
    bannerView.isHidden = true

    return bannerView
  }()

  override func loadView() {
    super.loadView()

    view.backgroundColor = .white
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.addSubview(contentView)
    self.view.addSubview(bannerView)

    bannerHeightConstraint = bannerView.heightAnchor.constraint(equalToConstant: 0)

    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),

      bannerView.topAnchor.constraint(equalTo: self.contentView.bottomAnchor),

      bannerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      bannerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      bannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

      bannerHeightConstraint!,
    ])
  }
}
