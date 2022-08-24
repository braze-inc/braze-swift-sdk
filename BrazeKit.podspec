Pod::Spec.new do |s|
  s.name              = 'BrazeKit'
  s.version           = '5.3.0'
  s.summary           = 'Braze Main SDK library providing support for analytics and push notifications.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.0/BrazeKit-CocoaPods.zip',
    :sha256 => 'a82f9b804e718ee0b75d02cba7c247351e430f1cdfecfa833b8d71d37c054d56'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'
  s.tvos.deployment_target  = '10.0'

  s.vendored_framework      = 'BrazeKit.xcframework'
  s.resource_bundles        = { 'BrazeKit' => 'Sources/BrazeKitResources/Resources/**/*' }
end
