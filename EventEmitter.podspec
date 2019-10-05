Pod::Spec.new do |s|
  s.name             = 'EventEmitter'
  s.version          = '0.7.1'
  s.swift_version    = '4.2'
  s.summary          = 'A lightweight tool to easily implement listener pattern.'
 
  s.description      = <<-DESC

  A lightweight tool to easily implement listener pattern. A lightweight tool to easily implement listener pattern.
                       DESC
 
  s.homepage         = 'https://github.com/egabor/EventEmitter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Máté Gujgiczer' => 'mate.gujgiczer@icloud.com' }
  s.source           = { :git => 'https://github.com/egabor/EventEmitter.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '9.3'
  s.source_files = 'EventEmitter/**/*.swift'
 
end
