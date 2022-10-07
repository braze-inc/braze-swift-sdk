Pod::Spec.new do |s|
  s.name              = 'BrazeNotificationService'
  s.version           = '5.5.1'
  s.summary           = 'Braze notification service extension library providing support for Rich Push notifications.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazenotificationservice/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.5.1/BrazeNotificationService-CocoaPods.zip',
    :sha256 => '05991a10529346219ad4101d1c6305bc578555b26136312f1c2619338deeb07a'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazeNotificationService.xcframework'
end
