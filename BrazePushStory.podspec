Pod::Spec.new do |s|
  s.name              = 'BrazePushStory'
  s.version           = '6.2.0'
  s.summary           = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazepushstory/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/6.2.0/BrazePushStory.zip',
    :sha256 => 'acda427a3d6995f9e64c3bb03b42a48eeef26e7d67279808736e1d7ef27bb8c5'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '11.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
