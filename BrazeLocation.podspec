Pod::Spec.new do |s|
  s.name              = 'BrazeLocation'
  s.version           = '14.0.4'
  s.summary           = 'Braze location library providing support for location analytics and geofence monitoring.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazelocation/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/14.0.4/BrazeLocation.zip',
    :sha256 => 'af3ea7125e88d3e3d2707c6b43ee67318f01993c3a6cb99a27765bde2c639b1c'
  }

  s.swift_version               = '5.0'
  s.ios.deployment_target       = '12.0'
  s.tvos.deployment_target      = '12.0'
  s.visionos.deployment_target  = '1.0'

  s.vendored_framework      = 'BrazeLocation.xcframework'
  s.resource_bundles        = { 'BrazeLocation' => ['Sources/BrazeLocationResources/Resources/**/*'] }

  s.dependency 'BrazeKit', '14.0.4'

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
