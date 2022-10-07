Pod::Spec.new do |s|
  s.name              = 'BrazePushStory'
  s.version           = '5.5.1'
  s.summary           = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazepushstory/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.5.1/BrazePushStory-CocoaPods.zip',
    :sha256 => '361fe3ec0e7fd03f5eafe8c6f582fbaeb7d60af765fe01cb1136b423b4176123'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'
end
