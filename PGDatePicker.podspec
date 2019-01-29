Pod::Spec.new do |s|
  s.name         = "PGDatePicker"
  s.version      = "2.6.9"
  s.summary      = "日期选择器"
  s.homepage     = "https://github.com/xiaozhuxiong121/PGDatePicker"
  s.license      = "MIT"
  s.author       = { "piggybear" => "piggybear_net@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/xiaozhuxiong121/PGDatePicker.git", :tag => s.version}
  s.source_files = "PGDatePicker", "PGDatePicker/*.{h,m}"
  s.resource     = 'PGDatePicker/PGDatePicker.bundle'
  s.frameworks   = "UIKit"
  s.requires_arc = true
  s.dependency 'PGPickerView'
end
 
 
 

 
