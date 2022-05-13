import CoreLocation

let readme =
  """
  This sample presents a complete BrazeLocation integration.

  - AppDelegate.swift:
    - Configure the braze instance with BrazeLocation
  """

let actions: [(String, String, (ReadmeViewController) -> Void)] = [
  (#"Request "always" authorization"#, "", requestAlwaysAuthorization),
  (#"Request "when in use" authorization"#, "", requestWhenInUseAuthorization),
]

// MARK: - Internal

let locationManager = CLLocationManager()

func requestAlwaysAuthorization(_ viewController: ReadmeViewController) {
  locationManager.requestAlwaysAuthorization()
}

func requestWhenInUseAuthorization(_ viewController: ReadmeViewController) {
  locationManager.requestWhenInUseAuthorization()
}
