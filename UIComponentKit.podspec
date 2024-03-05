Pod::Spec.new do |s|
  s.name             = 'UIComponentKit'
  s.version          = '0.0.1'
  s.summary          = "UI组件框架"
  s.description      = "UI组件框架"

  s.homepage         = 'https://github.com/X-my/UIComponentKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xumengyang' => 'woshixmy@163.com' }
  s.source           = { :git => 'https://github.com/X-my/UIComponentKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.dependency 'Yoga'
  s.dependency 'YYText'
  s.dependency 'Kingfisher'
  s.source_files = 'UIComponentKit/Classes/**/*.swift'
end
