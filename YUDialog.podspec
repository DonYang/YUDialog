
Pod::Spec.new do |s|
  s.name         = "YUDialog"
  s.version      = "0.1.1"
  s.summary      = "YUDialog is an iOS dialog utility"
  s.description  = <<-DESC
                   You can use YUDialog to make a your own custom dialog or just use flat dialog.
                   DESC

  s.homepage     = "https://github.com/DonYang/YUDialog"
  s.license      = { :type => "MIT" }
  s.author       = { "DonYang" => "yuxiao.yang@qq.com" }
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.source       = { :git => "https://github.com/DonYang/YUDialog.git", :tag=>s.version.to_s}
  s.requires_arc = true
  s.source_files  = 'Source/**/*.{h,m}'
  s.framework  = "Foundation", "UIKit"

end
