import CoreLocation

let readme =
  """
  This sample presents a complete BrazeLocation integration which enables location tracking and geofence monitoring.

  - AppDelegate.swift:
    - Configure the braze instance with BrazeLocationProvider
  """

#if os(iOS)
  @MainActor
  let actions: [(String, String, @MainActor (ReadmeViewController) -> Void)] = [
    (#"Request "always" authorization"#, "", requestAlwaysAuthorization),
    (#"Request "when in use" authorization"#, "", requestWhenInUseAuthorization),
  ]
#elseif os(tvOS) || os(visionOS)
  @MainActor
  let actions: [(String, String, @MainActor (ReadmeViewController) -> Void)] = [
    (#"Request "when in use" authorization"#, "", requestWhenInUseAuthorization)
  ]
#endif

// MARK: - Internal

@MainActor
let locationManager = CLLocationManager()

#if os(iOS)
  @MainActor
  func requestAlwaysAuthorization(_ viewController: ReadmeViewController) {
    locationManager.requestAlwaysAuthorization()
  }
#endif

@MainActor
func requestWhenInUseAuthorization(_ viewController: ReadmeViewController) {
  locationManager.requestWhenInUseAuthorization()
}
