Pod::Spec.new do |s|
s.name             = 'SPKit'
s.version          = '0.2.2'
s.summary          = '基于 BlFoundation 对 UIKit 的一些扩展'


s.homepage         = 'https://github.com/linhay/SPKit.git'
s.license          = { :type => 'Apache License 2.0', :file => 'LICENSE' }
s.author           = { 'lin' => 'linhan.bigl055@outlook.com' }
s.source = { :git => 'https://github.com/linhay/SPKit.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = ["Sources/*/**","Sources/*/*/**","Sources/**"]

s.public_header_files = ["Sources/SPKit.h"]
s.frameworks = ['UIKit']
s.requires_arc = true
s.dependency 'BLFoundation'
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
