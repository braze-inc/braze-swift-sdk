Pod::Spec.new do |s|
  s.name              = 'BrazeLocation'
  s.version           = '6.2.0'
  s.summary           = 'Braze location library providing support for location analytics and geofence monitoring.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazelocation/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/6.2.0/BrazeLocation.zip',
    :sha256 => '5568e6363155a2b836622405bba12c78c76184fb5e5ddd9153e84e703ac9f743'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '11.0'
  s.tvos.deployment_target  = '11.0'

  s.vendored_framework      = 'BrazeLocation.xcframework'

  # Depends on BrazeKit because BrazeKit includes the internal _BrazeLocationClient symbols required
  # for linking against BrazeLocation.
  s.dependency 'BrazeKit', '6.2.0'

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
