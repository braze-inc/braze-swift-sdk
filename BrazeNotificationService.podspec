Pod::Spec.new do |s|
  s.name              = 'BrazeNotificationService'
  s.version           = '6.6.2'
  s.summary           = 'Braze notification service extension library providing support for Rich Push notifications.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazenotificationservice/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/6.6.2/BrazeNotificationService.zip',
    :sha256 => '508253a940ed73bcb84ce75227b953d1ead26e363636093a796782410399cca3'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '11.0'

  s.vendored_framework      = 'BrazeNotificationService.xcframework'

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
