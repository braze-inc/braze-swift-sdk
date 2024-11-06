import BrazeKit
import Foundation

extension BrazeBannerUI.BannersImpressionTracker {

  /// The shared impression tracker for banners.
  static let shared = BrazeBannerUI.BannersImpressionTracker()

}

// MARK: - Banners Impression Tracker

extension BrazeBannerUI {

  /// The default implementation of impression tracking for Braze banners.
  @MainActor
  open class BannersImpressionTracker {

    public var visibilityTracker: VisibilityTracker<String>? {
      get { lock.sync { _visibilityTracker } }
      set { lock.sync { _visibilityTracker = newValue } }
    }
    private var _visibilityTracker: VisibilityTracker<String>?

    /// Whether the impression tracker is currently running.
    var isCurrentlyTracking: Bool {
      get { lock.sync { _isCurrentlyTracking } }
      set { lock.sync { _isCurrentlyTracking = newValue } }
    }
    private var _isCurrentlyTracking: Bool = false

    /// Banner views currently tracked for impression logging.
    ///
    /// Banner views are tracked and managed with their banner IDs (tracking string).
    var trackedBanners: NSMapTable<NSString, BrazeBannerUI.BannerUIView> {
      get { lock.sync { _trackedBanners } }
      set { lock.sync { _trackedBanners = newValue } }
    }
    private var _trackedBanners: NSMapTable<NSString, BrazeBannerUI.BannerUIView> = .init(
      keyOptions: .copyIn,
      valueOptions: .weakMemory
    )

    // Session

    /// The Braze cancellable watching the current session.
    var sessionSubscriber: Braze.Cancellable? {
      get { lock.sync { _sessionSubscriber } }
      set { lock.sync { _sessionSubscriber = newValue } }
    }
    private var _sessionSubscriber: Braze.Cancellable?

    /// The banner IDs that have been viewed this session.
    var viewedInSessionBanners: Set<String> {
      get { lock.sync { _viewedInSessionBanners } }
      set { lock.sync { _viewedInSessionBanners = newValue } }
    }
    private var _viewedInSessionBanners: Set<String> = []

    /// The lock guarding the properties.
    private let lock = NSRecursiveLock()

    /// Starts observing session updates to reset banner impressions.
    ///
    /// - Parameter braze: The Braze instance.
    public func startSessionTracking(with braze: Braze) {
      sessionSubscriber = braze.subscribeToSessionUpdates { [weak self] event in
        guard let self else { return }

        switch event {
        case .started:
          self.startVisibilityTracking()
        case .ended:
          self.viewedInSessionBanners = []
          self.stopVisibilityTracking()
        @unknown default:
          break
        }
      }
    }

    /// Register a Banner view for visibility tracking.
    ///
    /// - Parameter view: The Braze banner view.
    public func trackView(_ view: BrazeBannerUI.BannerUIView) {
      guard let bannerId = view.banner?.id,
        !viewedInSessionBanners.contains(bannerId)
      else { return }

      trackedBanners.setObject(view, forKey: bannerId as NSString)
      startVisibilityTracking()
    }

    /// Starts visibility and session tracking if tracking is not already running.
    func startVisibilityTracking() {
      guard !isCurrentlyTracking else { return }

      isCurrentlyTracking = true
      visibilityTracker = VisibilityTracker<String>(
        interval: 0.1,
        visibleIdentifiers: bannerIdentifiers,
        visibleForInterval: logBannerImpression
      )
      visibilityTracker?.start()
    }

    /// Stops visibility and session tracking.
    ///
    /// Aim to minimize operations whenever there are no longer any banners eligible for tracking.
    func stopVisibilityTracking() {
      guard isCurrentlyTracking else { return }

      isCurrentlyTracking = false
      visibilityTracker?.stop()
      visibilityTracker = nil
    }
  }

}

// MARK: - VisibilityTracker methods

extension BrazeBannerUI.BannersImpressionTracker {

  func bannerIdentifiers() -> [String] {
    return trackedBanners.keyEnumerator().allObjects.compactMap { key in
      guard let nsStringKey = key as? NSString,
        let view = trackedBanners.object(forKey: nsStringKey)
      else {
        return nil
      }
      return view.isCurrentlyVisible() ? nsStringKey as String : nil
    }
  }

  func logBannerImpression(bannerId: String) {
    guard let bannerView = trackedBanners.object(forKey: bannerId as NSString),
      let actualBannerId = bannerView.banner?.id,
      !viewedInSessionBanners.contains(actualBannerId)
    else { return }

    bannerView.logImpression()
    viewedInSessionBanners.insert(actualBannerId)

    // All banners that were visible are already tracked
    let allKeys = trackedBanners.keyEnumerator().allObjects.compactMap { $0 as? String }
    if viewedInSessionBanners.elementsEqual(allKeys) {
      stopVisibilityTracking()
    }
  }

}
