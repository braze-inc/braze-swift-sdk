Pod::Spec.new do |s|
  s.name        = 'BrazeLocation'
  s.version     = '5.1.0'
  s.summary     = 'Braze location library providing support for location analytics and geofence monitoring.'

  s.homepage    = 'https://braze.com'
  s.license     = { :type => 'Commercial' }
  s.authors     = 'Braze, Inc.'

  s.source      = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.1.0/BrazeLocation-CocoaPods.zip',
    :sha256 => '8d1c1b04e586b10dc4987ff57e91ac236246e519fbc214d9b3a2683bdb008b90'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazeLocation.xcframework'

  # Depends on BrazeKit because BrazeKit includes the internal _BrazeLocationClient symbols required
  # for linking against BrazeLocation.
  s.dependency 'BrazeKit', '5.1.0'
end
