Pod::Spec.new do |s|
  s.name              = 'BrazeNotificationService'
  s.version           = '11.9.0'
  s.summary           = 'Braze notification service extension library providing support for Rich Push notifications.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazenotificationservice/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/11.9.0/BrazeNotificationService.zip',
    :sha256 => 'd7c9cc5c5e6870aa211d9b0096c52cb8b72b7278f4d7f6cf9324774157a160c0'
  }

  s.swift_version               = '5.0'
  s.ios.deployment_target       = '12.0'
  s.visionos.deployment_target  = '1.0'

  s.vendored_framework      = 'BrazeNotificationService.xcframework'

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
