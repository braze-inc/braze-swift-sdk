Pod::Spec.new do |s|
  s.name              = 'BrazeLocation'
  s.version           = '19.0.0'
  s.summary           = 'Braze location library providing support for location analytics and geofence monitoring.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazelocation/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/19.0.0/BrazeLocation.zip',
    :sha256 => 'bd9938e246c227d63a4b7be18fac29a6fc690ba13c9a1ea715fabb063780aa5f'
  }

  s.swift_version               = '5.0'
  s.ios.deployment_target       = '15.0'
  s.tvos.deployment_target      = '15.0'
  s.visionos.deployment_target  = '1.0'

  s.vendored_framework      = 'BrazeLocation.xcframework'
  s.resource_bundles        = { 'BrazeLocation' => ['Sources/BrazeLocationResources/Resources/**/*'] }

  s.dependency 'BrazeKit', '19.0.0'

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
