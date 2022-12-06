Pod::Spec.new do |s|
  s.name              = 'BrazeNotificationService'
  s.version           = '5.7.0'
  s.summary           = 'Braze notification service extension library providing support for Rich Push notifications.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazenotificationservice/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.7.0/BrazeNotificationService-CocoaPods.zip',
    :sha256 => '335ce992d5a53b0efc79097ea77ccf092ff92013d9a7e58d02ef7f86763b8c70'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazeNotificationService.xcframework'
end
