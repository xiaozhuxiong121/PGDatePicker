Pod::Spec.new do |s|
  s.name         = "PGDatePicker"
  s.version      = "2.2.0"
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

    s.subspec 'Category' do |ss|
        ss.source_files = 'PGDatePicker/Category/*.{h,m}'
        ss.public_header_files = 'PGDatePicker/Category/*.h'
    end

    s.subspec 'Base' do |ss|
        ss.source_files = 'PGDatePicker/Base/*.{h,m}'
        ss.public_header_files = 'PGDatePicker/Base/*.h'
        ss.subspec 'Category' do |sss|
            sss.source_files = 'PGDatePicker/Base/Category/*.{h,m}'
            sss.public_header_files = 'PGDatePicker/Base/Category/*.h'
        end
    end
end
 
 
 

 
