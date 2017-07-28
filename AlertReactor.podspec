Pod::Spec.new do |s|
  s.name             = "AlertReactor"
  s.version          = "0.1.0"
  s.summary          = "ReactorKit extension for UIAlertController"
  s.homepage         = "https://github.com/devxoul/AlertReactor"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Suyeol Jeon" => "devxoul@gmail.com" }
  s.source           = { :git => "https://github.com/devxoul/AlertReactor.git",
                         :tag => s.version.to_s }
  s.source_files = "Sources/**/*.{swift,h,m}"
  s.frameworks   = "UIKit"
  s.dependency "ReactorKit"
  s.dependency "RxSwift", ">= 3.0.0"
  s.dependency "RxCocoa", ">= 3.0.0"

  s.ios.deployment_target = "8.0"

  s.pod_target_xcconfig = {
    "SWIFT_VERSION" => "3.1"
  }
end
