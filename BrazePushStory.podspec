Pod::Spec.new do |s|
  s.name              = 'BrazePushStory'
  s.version           = '5.3.1'
  s.summary           = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazepushstory/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.1/BrazePushStory-CocoaPods.zip',
    :sha256 => '8db3628e06363f75729088fbe7e5ce0948ae5509d6fd799c825805936b829107'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'
end
