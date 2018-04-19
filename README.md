# PGDatePicker
日期选择器，支持年、年月、年月日、年月日时、年月日时分、年月日时分秒、月日、月日时、月日时分、月日时分秒、时分、时分秒、分秒、月日周 时分等，内置了3种样式。

> 由于使用UIPickerView的话，列表会有个弧度，所以这里用了[PGPickerView](https://github.com/xiaozhuxiong121/PGPickerView)  

![PGDatePicker](F734F5F9-FB12-4BA7-B43E-B39D0FF1DA3B.png)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/PGDatePicker.svg)](https://cocoapods.org/pods/PGDatePicker)
![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg)
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 
 [![](https://img.shields.io/badge/jianshu-piggybear-red.svg)](http://www.jianshu.com/u/3740632b2002)   


#### 直接看如何使用:[Wiki](https://github.com/xiaozhuxiong121/PGDatePicker/wiki)

# 样式1
![year](Images/样式1.png)
# 样式2
![year](Images/样式2.png)
# 样式3
![year](Images/样式3.png)

> 只显示中间的文字，设置```isHiddenMiddleText```为```false```即可，默认是```true```

# 年份
![year](Images/年.png)

# 年月
![year](Images/年月.png)

# 年月日
![year](Images/年月日.png)

# 年月日时
![year](Images/年月日时.png)

# 年月日时分
![year](Images/年月日时分.png)

# 年月日时分秒
![year](Images/年月日时分秒.png)
# 月日
![year](Images/月日.png)
# 月日时
![year](Images/月日时.png)
# 月日时分
![year](Images/月日时分.png)
# 月日时分秒
![year](Images/月日时分秒.png)


# 时分
![year](Images/时分.png)

# 时分秒
![year](Images/时分秒.png)
# 分秒
![year](Images/分秒.png)

# 月日周 时分
![year](Images/月日周时分.png)
# 其他样式
![屏幕快照1](Images/屏幕快照1.png)
# 其他样式
![屏幕快照2](Images/屏幕快照2.png)

# 设置自己的样式
如果内置的样式都满足不了你的需要，想自己设置样式，也是完全支持的，可以将`PGDatePicker`创建出来添加到你的`View`上。

```
PGDatePicker *datePicker = [[PGDatePicker alloc]init];
[self.view addSubview:datePicker];
```

`PGDatePickManager`类就是一个典型的例子，你可以下载源码查看`PGDatePickManager`的简单实现，或许对你自己封装会有所帮助。

# Swift使用
[查看使用文档](Swift.md) 

# CocoaPods安装

```
pod 'PGDatePicker'
```

> **在`1.5.1`版本中对iPhone X进行了适配** 

# 使用
引入头文件

```
#import <PGDatePick/PGDatePickManager.h>
```
```
PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
PGDatePicker *datePicker = datePickManager.datePicker;
datePicker.delegate = self;
[self presentViewController:datePickManager animated:false completion:nil];

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
NSLog(@"dateComponents = %@", dateComponents);
}
```
> 如果不设置```minimumDate```和```maximumDate```默认是无穷小和无穷大 

> 语言跟着手机系统语言走，默认有英文，中文，繁体中文，如果是模拟器的话，将模拟器的系统语言改成中文即显示中文

# 设置样式
```
PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
PGDatePicker *datePicker = datePickManager.datePicker;
datePicker.delegate = self;
datePicker.datePickerMode = PGDatePickerModeDate;
[self presentViewController:datePickManager animated:false completion:nil];

datePickManager.titleLabel.text = @"PGDatePicker";
//设置半透明的背景颜色
datePickManager.isShadeBackgroud = true;
//设置头部的背景颜色
datePickManager.headerViewBackgroundColor = [UIColor orangeColor];
//设置线条的颜色
datePicker.lineBackgroundColor = [UIColor redColor];
//设置选中行的字体颜色
datePicker.textColorOfSelectedRow = [UIColor redColor];
//设置未选中行的字体颜色
datePicker.textColorOfOtherRow = [UIColor blackColor];
//设置取消按钮的字体颜色
datePickManager.cancelButtonTextColor = [UIColor blackColor];
//设置取消按钮的字
datePickManager.cancelButtonText = @"Cancel";
//设置取消按钮的字体大小
datePickManager.cancelButtonFont = [UIFont boldSystemFontOfSize:17];

//设置确定按钮的字体颜色
datePickManager.confirmButtonTextColor = [UIColor redColor];
//设置确定按钮的字
datePickManager.confirmButtonText = @"Sure";
//设置确定按钮的字体大小
datePickManager.confirmButtonFont = [UIFont boldSystemFontOfSize:17];

```

# 最新版本
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/PGDatePicker.svg)]()

# 许可证

PGDatePicker 使用 MIT 许可证，详情见 [LICENSE](LICENSE) 文件。


