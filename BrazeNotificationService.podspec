Pod::Spec.new do |s|
  s.name        = 'BrazeNotificationService'
  s.version     = '5.2.0'
  s.summary     = 'Braze notification service extension library providing support for Rich Push notifications.'

  s.homepage    = 'https://braze.com'
  s.license     = { :type => 'Commercial' }
  s.authors     = 'Braze, Inc.'

  s.source      = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.2.0/BrazeNotificationService-CocoaPods.zip',
    :sha256 => '83877056947d5169827334dd1edc459defd9fa3f2734c925f2103ba2a8a77ea5'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazeNotificationService.xcframework'
end
