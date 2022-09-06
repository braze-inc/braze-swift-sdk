Pod::Spec.new do |s|
  s.name              = 'BrazePushStory'
  s.version           = '5.3.2'
  s.summary           = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazepushstory/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.2/BrazePushStory-CocoaPods.zip',
    :sha256 => '352f37e0c9877165f1a44416157f4c784f0db2de5f08ccaf34cea26663e9f50f'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'
end
