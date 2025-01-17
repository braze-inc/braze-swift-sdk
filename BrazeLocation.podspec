Pod::Spec.new do |s|
  s.name              = 'BrazeLocation'
  s.version           = '11.5.0'
  s.summary           = 'Braze location library providing support for location analytics and geofence monitoring.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazelocation/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/11.5.0/BrazeLocation.zip',
    :sha256 => 'b2aec021475e9c92979d1b77670d93b21b35898c8a5b6d65bf22586222340f40'
  }

  s.swift_version               = '5.0'
  s.ios.deployment_target       = '12.0'
  s.tvos.deployment_target      = '12.0'
  s.visionos.deployment_target  = '1.0'

  s.vendored_framework      = 'BrazeLocation.xcframework'
  s.resource_bundles        = { 'BrazeLocation' => ['Sources/BrazeLocationResources/Resources/**/*'] }

  s.dependency 'BrazeKit', '11.5.0'

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
