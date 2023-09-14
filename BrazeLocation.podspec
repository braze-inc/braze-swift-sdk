Pod::Spec.new do |s|
  s.name              = 'BrazeLocation'
  s.version           = '6.6.1'
  s.summary           = 'Braze location library providing support for location analytics and geofence monitoring.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazelocation/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/6.6.1/BrazeLocation.zip',
    :sha256 => 'b89f1fc5287e90ea9e936c2f83bf2afa6622d2c2c883f32a7cfea6d78d9700e7'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '11.0'
  s.tvos.deployment_target  = '11.0'

  s.vendored_framework      = 'BrazeLocation.xcframework'

  # Depends on BrazeKit because BrazeKit includes the internal _BrazeLocationClient symbols required
  # for linking against BrazeLocation.
  s.dependency 'BrazeKit', '6.6.1'

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
