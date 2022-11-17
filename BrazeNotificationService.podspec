Pod::Spec.new do |s|
  s.name              = 'BrazeNotificationService'
  s.version           = '5.6.3'
  s.summary           = 'Braze notification service extension library providing support for Rich Push notifications.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazenotificationservice/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.6.3/BrazeNotificationService-CocoaPods.zip',
    :sha256 => 'fe116d58686797e3a47bde2c5e4da73c89d9aea7f6578c648b558c80dd2c99ed'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazeNotificationService.xcframework'
end
