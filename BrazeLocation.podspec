Pod::Spec.new do |s|
  s.name              = 'BrazeLocation'
  s.version           = '5.10.1'
  s.summary           = 'Braze location library providing support for location analytics and geofence monitoring.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazelocation/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.10.1/BrazeLocation.zip',
    :sha256 => '7c5d4a7180e712a6c676ed82d2bb86bd9c17e77cf1ad901513a4a43c1c120f2b'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '11.0'
  s.tvos.deployment_target  = '11.0'

  s.vendored_framework      = 'BrazeLocation.xcframework'

  # Depends on BrazeKit because BrazeKit includes the internal _BrazeLocationClient symbols required
  # for linking against BrazeLocation.
  s.dependency 'BrazeKit', '5.10.1'

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
