# CocoaPods安装

```
pod 'PGDatePicker', '>= 1.1.0'
```

# 使用
```
let datePicker = PGDatePicker()
datePicker.show()
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
let datePicker = PGDatePicker()
datePicker.delegate = self
datePicker.show()
datePicker.titleLabel.text = "PGDatePicker"
//设置线条的颜色
datePicker.lineBackgroundColor = UIColor.red
//设置选中行的字体颜色
datePicker.titleColorForSelectedRow = UIColor.red
//设置未选中行的字体颜色
datePicker.titleColorForOtherRow = UIColor.black

//设置取消按钮的字体颜色
datePicker.cancelButtonTextColor = UIColor.black
//设置取消按钮的字
datePicker.cancelButtonText = "取消"
//设置取消按钮的字体大小
datePicker.cancelButtonFont = UIFont.boldSystemFont(ofSize: 17)

//设置确定按钮的字体颜色
datePicker.confirmButtonTextColor = UIColor.red
//设置确定按钮的字
datePicker.confirmButtonText = "确定"
//设置确定按钮的字体大小
datePicker.confirmButtonFont = UIFont.boldSystemFont(ofSize: 17)datePicker.datePickerMode = .date

```

详细使用请下载swift版的[demo](https://github.com/xiaozhuxiong121/PGDatePicker/tree/master/SwiftDemo)查看。