Pod::Spec.new do |s|
  s.name              = 'BrazePushStory'
  s.version           = '17.0.0'
  s.summary           = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazepushstory/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/17.0.0/BrazePushStory.zip',
    :sha256 => 'adeb78a83c926647032c59447663cc15e5fde7acc0156bd46cf4e1982a50130d'
  }

  s.swift_version               = '5.0'
  s.ios.deployment_target       = '12.0'
  s.visionos.deployment_target  = '1.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'
  s.resource_bundles        = { 'BrazePushStory' => ['Sources/BrazePushStoryResources/Resources/**/*'] }

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
