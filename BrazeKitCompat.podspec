Pod::Spec.new do |s|
  s.name              = 'BrazeKitCompat'
  s.version           = '5.11.2'
  s.summary           = 'Compatibility library for users migrating from AppboyKit.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazekitcompat/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = { :git => 'https://github.com/braze-inc/braze-swift-sdk.git', :tag => '5.11.2' }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '11.0'
  s.tvos.deployment_target  = '11.0'
  s.static_framework        = true

  s.source_files            = 'Sources/BrazeKitCompat/**/*.{h,m}'
  s.public_header_files     = 'Sources/BrazeKitCompat/include/*.h'

  s.dependency 'BrazeKit', '5.11.2'
  s.dependency 'BrazeLocation', '5.11.2'

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
