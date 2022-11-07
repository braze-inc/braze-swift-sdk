Pod::Spec.new do |s|
  s.name              = 'BrazePushStory'
  s.version           = '5.6.2'
  s.summary           = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazepushstory/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.6.2/BrazePushStory-CocoaPods.zip',
    :sha256 => '2d8c566210a1a69545d7858eb9ffa4ef9d05faf36e27ed2c56a15825278f06c1'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'
end
