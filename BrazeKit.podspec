Pod::Spec.new do |s|
  s.name        = 'BrazeKit'
  s.version     = '5.1.0'
  s.summary     = 'Braze Main SDK library providing support for analytics and push notifications.'

  s.homepage    = 'https://braze.com'
  s.license     = { :type => 'Commercial' }
  s.authors     = 'Braze, Inc.'

  s.source      = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.1.0/BrazeKit-CocoaPods.zip',
    :sha256 => 'dfedd4d9375d4b71be2f4b4b0e604cd3e931339f92f55a37c90a8500f34a7b9a'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazeKit.xcframework'
  s.resource_bundles        = { 'BrazeKit' => 'Sources/BrazeKitResources/Resources/**/*' }
end
