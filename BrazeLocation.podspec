Pod::Spec.new do |s|
  s.name              = 'BrazeLocation'
  s.version           = '5.3.0'
  s.summary           = 'Braze location library providing support for location analytics and geofence monitoring.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazelocation/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.0/BrazeLocation-CocoaPods.zip',
    :sha256 => '81b11c20caa024cf648abd45c2780ce45d837f843028ff7dc7aa88258ac151b5'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'
  s.tvos.deployment_target  = '10.0'

  s.vendored_framework      = 'BrazeLocation.xcframework'

  # Depends on BrazeKit because BrazeKit includes the internal _BrazeLocationClient symbols required
  # for linking against BrazeLocation.
  s.dependency 'BrazeKit', '5.3.0'
end
