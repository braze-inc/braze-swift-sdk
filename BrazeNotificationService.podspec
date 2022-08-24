Pod::Spec.new do |s|
  s.name              = 'BrazeNotificationService'
  s.version           = '5.3.0'
  s.summary           = 'Braze notification service extension library providing support for Rich Push notifications.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazenotificationservice/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = {
    :http => 'https://github.com/braze-inc/braze-swift-sdk/releases/download/5.3.0/BrazeNotificationService-CocoaPods.zip',
    :sha256 => '04f18d05e0d4142f09f6d5386103388a8ee04598ca826fb66a423c40adfb8329'
  }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.vendored_framework      = 'BrazeNotificationService.xcframework'
end
