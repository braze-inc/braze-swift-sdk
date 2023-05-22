Pod::Spec.new do |s|
  s.name              = 'BrazeUI'
  s.version           = '6.2.0'
  s.summary           = 'Braze-provided user interface library for In-App Messages and Content Cards.'

  s.homepage          = 'https://braze.com'
  s.documentation_url = 'https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/'
  s.license           = { :type => 'Commercial' }
  s.authors           = 'Braze, Inc.'

  s.source            = { :git => 'https://github.com/braze-inc/braze-swift-sdk.git', :tag => '6.2.0' }

  s.swift_version           = '5.0'
  s.ios.deployment_target   = '11.0'
  s.static_framework        = true

  s.source_files            = 'Sources/BrazeUI/**/*.swift'
  s.resource_bundles        = { 'BrazeUI' => ['Sources/BrazeUI/Resources/**/*'] }

  s.dependency 'BrazeKit', '6.2.0'

  s.pod_target_xcconfig     = { 'DEFINES_MODULE' => 'YES' }
end
