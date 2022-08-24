Pod::Spec.new do |s|
  s.name              = 'BrazePushStory'
  s.version           = '5.3.0'
  s.summary           = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazepushstory/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.0/BrazePushStory-CocoaPods.zip',
    :sha256 => '1dc9537d3739ab75db4c4299c5c71b11aafe71ee4a23b0200a7660c6f10c2910'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'
end
