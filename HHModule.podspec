Pod::Spec.new do |s|
s.name = 'HHModule'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = '悬停视图'
s.homepage = 'https://github.com/yuwind/HHModule'
s.authors = { 'hxw' => 'hxwnan@163.com' }
s.source = { :git => "https://github.com/yuwind/HHModule.git", :tag => "1.0.0'"}
s.requires_arc = true
s.platform     = :ios, "7.0"
s.ios.deployment_target = '7.0'
s.source_files = "HHModule/**/*.{h,m}"
s.source = "HHModule/HHRefreshManager/refreshmImages.bundle"
s.frameworks = 'UIKit'
end