Pod::Spec.new do |s|
  s.name        = 'BrazePushStory'
  s.version     = '5.1.0'
  s.summary     = 'Braze notification content extension library providing support for Push Stories.'

  s.homepage    = 'https://braze.com'
  s.license     = { :type => 'Commercial' }
  s.authors     = 'Braze, Inc.'

  s.source      = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.1.0/BrazePushStory-CocoaPods.zip',
    :sha256 => 'b7478167cf457883c6b7ad4455b3a2acd805f258555a9e55bd427b9eeb933de9'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazePushStory.xcframework'
end
