Pod::Spec.new do |s|
  s.name              = 'BrazePushStory'
  s.version           = '5.6.4'
  s.summary           = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazepushstory/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.6.4/BrazePushStory-CocoaPods.zip',
    :sha256 => 'f21f0c9655bb143790ac55e8ba105167b8ab7a5ef55df68992c0e61a91a24ecf'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'
end
