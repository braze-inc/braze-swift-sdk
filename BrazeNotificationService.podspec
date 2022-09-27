Pod::Spec.new do |s|
  s.name              = 'BrazeNotificationService'
  s.version           = '5.5.0'
  s.summary           = 'Braze notification service extension library providing support for Rich Push notifications.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazenotificationservice/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.5.0/BrazeNotificationService-CocoaPods.zip',
    :sha256 => '47333461d0e12918222d755348158c496d9f296b9b5bf2e71b15d40b725ffcfb'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazeNotificationService.xcframework'
end
