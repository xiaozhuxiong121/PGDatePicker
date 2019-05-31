Pod::Spec.new do |s|
  s.name         = "PGDatePickerFix"
  s.version      = "2.7.0"
  s.summary      = "日期选择器"
  s.homepage     = "https://github.com/jw10126121/PGDatePicker"
  s.license      = "MIT"
  s.author       = { "jw10126121" => "10126121@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/jw10126121/PGDatePicker.git", :tag => s.version}
  s.source_files = "PGDatePicker", "PGDatePicker/*.{h,m}"
  s.resource     = 'PGDatePicker/PGDatePicker.bundle'
  s.frameworks   = "UIKit"
  s.requires_arc = true
  s.dependency 'PGPickerView'
  s.module_name  = 'PGDatePicker'
end
 
 
 

 
