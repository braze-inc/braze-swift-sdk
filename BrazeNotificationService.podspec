Pod::Spec.new do |s|
  s.name              = 'BrazeNotificationService'
  s.version           = '5.4.0'
  s.summary           = 'Braze notification service extension library providing support for Rich Push notifications.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazenotificationservice/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.4.0/BrazeNotificationService-CocoaPods.zip',
    :sha256 => '3ad4ccb1557c338f8a5018731aa6b543f523326cc54a055127a8c66d5ff212d4'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazeNotificationService.xcframework'
end
