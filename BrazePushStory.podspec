Pod::Spec.new do |s|
  s.name              = 'BrazePushStory'
  s.version           = '11.6.1'
  s.summary           = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazepushstory/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/11.6.1/BrazePushStory.zip',
    :sha256 => '16feab50c7a77d16075561697be5218d3a5f4c525c70634d4703c6be04cc90eb'
  }

  s.swift_version               = '5.0'
  s.ios.deployment_target       = '12.0'
  s.visionos.deployment_target  = '1.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'
  s.resource_bundles        = { 'BrazePushStory' => ['Sources/BrazePushStoryResources/Resources/**/*'] }

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
