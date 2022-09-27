Pod::Spec.new do |s|
  s.name              = 'BrazePushStory'
  s.version           = '5.5.0'
  s.summary           = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazepushstory/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.5.0/BrazePushStory-CocoaPods.zip',
    :sha256 => '563764ac805374f75df403fa91c13b5611d8eb8aad4fde64dc385b3c0623f68c'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'
end
