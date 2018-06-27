Pod::Spec.new do |s|
s.name             = 'SPKit'
s.version          = '0.3.0'
s.summary          = '基于 BlFoundation 对 UIKit 的一些扩展'


s.homepage         = 'https://github.com/linhay/SPKit.git'
s.license          = { :type => 'Apache License 2.0', :file => 'LICENSE' }
s.author           = { 'lin' => 'linhan.bigl055@outlook.com' }
s.source = { :git => 'https://github.com/linhay/SPKit.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.frameworks = ['UIKit']
s.requires_arc = true
# s.dependency 'BLFoundation'


s.subspec 'Core' do |ss|
  ss.source_files = 'Sources/Core/**'
end

s.subspec 'CALayer' do |ss|
  ss.source_files = 'Sources/CALayer/**'
  ss.dependency 'SPKit/Core'
end

s.subspec 'NSLayoutConstraint' do |ss|
  ss.source_files = 'Sources/NSLayoutConstraint/**'
  ss.dependency 'SPKit/Core'
end

s.subspec 'UIApplication' do |ss|
  ss.source_files = 'Sources/UIApplication/**'
  ss.dependency 'SPKit/Core'
end

s.subspec 'UIBarButtonItem' do |ss|
  ss.source_files = 'Sources/UIBarButtonItem/**'
  ss.dependency 'SPKit/Core'
end

s.subspec 'UIButton' do |ss|
  ss.source_files = 'Sources/UIButton/**'
  ss.dependency 'SPKit/Core'
end

s.subspec 'UICell' do |ss|
  ss.source_files = 'Sources/UICell/**'
  ss.dependency 'SPKit/Core'
end

s.subspec 'UIColor' do |ss|
  ss.source_files = 'Sources/UIColor/**'
  ss.dependency 'SPKit/Core'
end

s.subspec 'UIControl' do |ss|
  ss.source_files = 'Sources/UIControl/**'
  ss.dependency 'SPKit/Core'
  ss.dependency 'BLFoundation'
end

s.subspec 'UIImage' do |ss|
  ss.source_files = 'Sources/UIImage/**'
  ss.dependency 'SPKit/Core'
end

s.subspec 'UILabel' do |ss|
  ss.source_files = 'Sources/UILabel/**'
  ss.dependency 'SPKit/Core'
  ss.dependency 'BLFoundation'
end

s.subspec 'UIStoryboard' do |ss|
  ss.source_files = 'Sources/UIStoryboard/**'
  ss.dependency 'SPKit/Core'
end

s.subspec 'UITextField' do |ss|
  ss.source_files = 'Sources/UITextField/**'
  ss.dependency 'SPKit/Core'
end

s.subspec 'UIView' do |ss|
  ss.source_files = 'Sources/UIView/**'
  ss.dependency 'SPKit/Core'
end

s.subspec 'UIViewController' do |ss|
  ss.source_files = 'Sources/UIViewController/**'
  ss.dependency 'SPKit/Core'
end


s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
