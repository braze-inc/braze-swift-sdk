Pod::Spec.new do |s|
  s.name              = 'BrazeNotificationService'
  s.version           = '6.2.0'
  s.summary           = 'Braze notification service extension library providing support for Rich Push notifications.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazenotificationservice/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/6.2.0/BrazeNotificationService.zip',
    :sha256 => '5a3d743c8cc7bab42e2e20f25ccea20d37f6f1fe540cad9c4de7d2bf59698d41'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '11.0'

  s.vendored_framework      = 'BrazeNotificationService.xcframework'

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
