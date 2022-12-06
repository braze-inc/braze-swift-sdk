Pod::Spec.new do |s|
  s.name              = 'BrazePushStory'
  s.version           = '5.7.0'
  s.summary           = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazepushstory/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.7.0/BrazePushStory-CocoaPods.zip',
    :sha256 => '741f055974e9e4fb70810ba716fe2177ad486bd7b7d32779a65087a6055bb597'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'
end
