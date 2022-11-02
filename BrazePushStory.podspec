Pod::Spec.new do |s|
  s.name              = 'BrazePushStory'
  s.version           = '5.6.1'
  s.summary           = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazepushstory/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.6.1/BrazePushStory-CocoaPods.zip',
    :sha256 => 'c7b71b96745388ba15df9b128a01c38fd4574237f9561d4bdadb90d62c1adc65'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'
end
