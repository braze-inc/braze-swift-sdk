Pod::Spec.new do |s|
  s.name        = 'BrazeNotificationService'
  s.version     = '5.1.0'
  s.summary     = 'Braze notification service extension library providing support for Rich Push notifications.'

  s.homepage    = 'https://braze.com'
  s.license     = { :type => 'Commercial' }
  s.authors     = 'Braze, Inc.'

  s.source      = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.1.0/BrazeNotificationService-CocoaPods.zip',
    :sha256 => '43d2b4cb740391029f40b56ad4a71044498dddad56cf185ab9695aeb7ca550f4'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazeNotificationService.xcframework'
end
