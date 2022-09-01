Pod::Spec.new do |s|
  s.name              = 'BrazeNotificationService'
  s.version           = '5.3.1'
  s.summary           = 'Braze notification service extension library providing support for Rich Push notifications.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazenotificationservice/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.1/BrazeNotificationService-CocoaPods.zip',
    :sha256 => '373f4d84f6f1f0b82b19061f5fa525c82b1d50321f68348f206bed5016d647b8'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazeNotificationService.xcframework'
end
