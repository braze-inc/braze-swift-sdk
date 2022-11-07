Pod::Spec.new do |s|
  s.name              = 'BrazeKit'
  s.version           = '5.6.2'
  s.summary           = 'Braze Main SDK library providing support for analytics and push notifications.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.6.2/BrazeKit-CocoaPods.zip',
    :sha256 => '2ff7e26dba1e17c05639796ef7f1904b3ecd44385606ff045920f7e7939d57a2'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'
  s.tvos.deployment_target  = '10.0'

  s.vendored_framework      = 'BrazeKit.xcframework'
  s.resource_bundles        = { 'BrazeKit' => 'Sources/BrazeKitResources/Resources/**/*' }
end
