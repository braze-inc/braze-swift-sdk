Pod::Spec.new do |s|
  s.name        = 'BrazeKit'
  s.version     = '5.2.0'
  s.summary     = 'Braze Main SDK library providing support for analytics and push notifications.'

  s.homepage    = 'https://braze.com'
  s.license     = { :type => 'Commercial' }
  s.authors     = 'Braze, Inc.'

  s.source      = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.2.0/BrazeKit-CocoaPods.zip',
    :sha256 => '65f46bdb2d365a97e7d5cb7807e460098040fd08013f9b41c868332c92907cb4'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazeKit.xcframework'
  s.resource_bundles        = { 'BrazeKit' => 'Sources/BrazeKitResources/Resources/**/*' }
end
