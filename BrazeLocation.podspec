Pod::Spec.new do |s|
  s.name              = 'BrazeLocation'
  s.version           = '14.1.0'
  s.summary           = 'Braze location library providing support for location analytics and geofence monitoring.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazelocation/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/14.1.0/BrazeLocation.zip',
    :sha256 => '7e6c0d0b0896d05ac4c93ef866848ba9caef3cd4a9cec5b10e391a8454706589'
  }

  s.swift_version               = '5.0'
  s.ios.deployment_target       = '12.0'
  s.tvos.deployment_target      = '12.0'
  s.visionos.deployment_target  = '1.0'

  s.vendored_framework      = 'BrazeLocation.xcframework'
  s.resource_bundles        = { 'BrazeLocation' => ['Sources/BrazeLocationResources/Resources/**/*'] }

  s.dependency 'BrazeKit', '14.1.0'

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
