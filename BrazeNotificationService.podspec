Pod::Spec.new do |s|
  s.name              = 'BrazeNotificationService'
  s.version           = '5.3.2'
  s.summary           = 'Braze notification service extension library providing support for Rich Push notifications.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazenotificationservice/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.2/BrazeNotificationService-CocoaPods.zip',
    :sha256 => '553907894d384cfa0e9f47f46120c964da3fe38f0330dd5c0f6f37140489d643'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazeNotificationService.xcframework'
end
