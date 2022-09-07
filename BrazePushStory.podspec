Pod::Spec.new do |s|
  s.name              = 'BrazePushStory'
  s.version           = '5.4.0'
  s.summary           = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazepushstory/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.4.0/BrazePushStory-CocoaPods.zip',
    :sha256 => '47d56c8a5a79e72d2a87744d8f3207ee3a09943f460cf7d11d4a12ff97df1cdd'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'
end
