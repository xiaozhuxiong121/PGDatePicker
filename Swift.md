# CocoaPods安装

```
pod 'PGDatePicker'
```

# 使用
```
let datePickerManager = PGDatePickManager()
datePickerManager.isShadeBackgroud = true
let datePicker = datePickerManager.datePicker!
datePicker.delegate = self
self.present(datePickerManager, animated: false, completion: nil)
```
**得到选中的日期**
> 设置代理

```
func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
    print("dateComponents = ", dateComponents)
}
```

**设置样式**

```
let datePickerManager = PGDatePickManager()
let datePicker = datePickerManager.datePicker!
self.present(datePickerManager, animated: false, completion: nil)
datePicker.delegate = self
datePickerManager.titleLabel.text = "PGDatePicker"
//设置头部的背景颜色
datePickerManager.headerViewBackgroundColor = UIColor.orange
//设置半透明背景
datePickerManager.isShadeBackgroud = true
//设置线条的颜色
datePicker.lineBackgroundColor = UIColor.red
//设置选中行的字体颜色
datePicker.textColorOfSelectedRow = UIColor.red
//设置未选中行的字体颜色
datePicker.textColorOfOtherRow = UIColor.black

//设置取消按钮的字体颜色
datePickerManager.cancelButtonTextColor = UIColor.black
//设置取消按钮的字
datePickerManager.cancelButtonText = "Cancel"
//设置取消按钮的字体大小
datePickerManager.cancelButtonFont = UIFont.boldSystemFont(ofSize: 17)

//设置确定按钮的字体颜色
datePickerManager.confirmButtonTextColor = UIColor.red
//设置确定按钮的字
datePickerManager.confirmButtonText = "Sure"
//设置确定按钮的字体大小
datePickerManager.confirmButtonFont = UIFont.boldSystemFont(ofSize: 17)
datePicker.datePickerMode = .date

```

详细使用请下载swift版的[demo](https://github.com/xiaozhuxiong121/PGDatePicker/tree/master/SwiftDemo)查看。