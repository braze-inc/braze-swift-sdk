Pod::Spec.new do |s|
  s.name        = 'BrazePushStory'
  s.version     = '5.2.0'
  s.summary     = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage    = 'https://braze.com'
  s.license     = { :type => 'Commercial' }
  s.authors     = 'Braze, Inc.'

  s.source      = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.2.0/BrazePushStory-CocoaPods.zip',
    :sha256 => '7b5e803fad8a2e16b7ad86c4ba47d445fce54efbbac1871e794e52a97e890fa5'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'
end
