import CoreLocation

let readme =
  """
  This sample presents a complete BrazeLocation integration.

  - AppDelegate.swift:
    - Configure the braze instance with BrazeLocation
  """

#if os(iOS)
let actions: [(String, String, (ReadmeViewController) -> Void)] = [
  (#"Request "always" authorization"#, "", requestAlwaysAuthorization),
  (#"Request "when in use" authorization"#, "", requestWhenInUseAuthorization),
]
#elseif os(tvOS)
let actions: [(String, String, (ReadmeViewController) -> Void)] = [
  (#"Request "when in use" authorization"#, "", requestWhenInUseAuthorization),
]
#endif

// MARK: - Internal

let locationManager = CLLocationManager()

#if os(iOS)
func requestAlwaysAuthorization(_ viewController: ReadmeViewController) {
  locationManager.requestAlwaysAuthorization()
}
#endif

func requestWhenInUseAuthorization(_ viewController: ReadmeViewController) {
  locationManager.requestWhenInUseAuthorization()
}
