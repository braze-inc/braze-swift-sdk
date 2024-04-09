Pod::Spec.new do |s|
  s.name              = 'BrazeKitCompat'
  s.version           = '8.4.0'
  s.summary           = 'Compatibility library for users migrating from AppboyKit.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazekitcompat/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = { :git => 'https://github.com/braze-inc/braze-swift-sdk.git', :tag => '8.4.0' }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '12.0'
  s.tvos.deployment_target  = '12.0'

  s.source_files            = 'Sources/BrazeKitCompat/**/*.{h,m}'
  s.public_header_files     = 'Sources/BrazeKitCompat/include/*.h'
  s.static_framework        = true

  s.dependency 'BrazeKit', '8.4.0'
  s.dependency 'BrazeLocation', '8.4.0'

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
