Pod::Spec.new do |s|
  s.name              = 'BrazeUICompat'
  s.version           = '6.2.0'
  s.summary           = 'Compatibility UI library for users migrating from AppboyUI.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = { :git => 'https://github.com/braze-inc/braze-swift-sdk.git', :tag => '6.2.0' }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '11.0'
  s.static_framework        = true

  s.source_files            = 'Sources/BrazeUICompat/ABK*/**/*.{h,m}'
  s.public_header_files     = 'Sources/BrazeUICompat/ABK*/**/*.h'
  s.resource_bundles        = { 'BrazeUICompat' => 'Sources/BrazeUICompat/*/Resources/**/*.*' }

  s.dependency 'BrazeKitCompat', '6.2.0'
  s.dependency 'SDWebImage', '>= 5.8.2', '< 6'

  s.user_target_xcconfig    = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
  s.pod_target_xcconfig     = {
    'DEFINES_MODULE' => 'YES',
    'OTHER_CFLAGS' => '-Wno-deprecated-declarations -Wno-deprecated-implementations'
  }
end
