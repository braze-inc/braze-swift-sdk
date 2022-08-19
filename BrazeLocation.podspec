Pod::Spec.new do |s|
  s.name        = 'BrazeLocation'
  s.version     = '5.2.0'
  s.summary     = 'Braze location library providing support for location analytics and geofence monitoring.'

  s.homepage    = 'https://braze.com'
  s.license     = { :type => 'Commercial' }
  s.authors     = 'Braze, Inc.'

  s.source      = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.2.0/BrazeLocation-CocoaPods.zip',
    :sha256 => '52b0736d7d1a2313e52ba8ea2f7c6d929c1544e21783ea731bd461979e62ecc5'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazeLocation.xcframework'

  # Depends on BrazeKit because BrazeKit includes the internal _BrazeLocationClient symbols required
  # for linking against BrazeLocation.
  s.dependency 'BrazeKit', '5.2.0'
end
