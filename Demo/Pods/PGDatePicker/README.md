# PGDatePicker
日期选择器，支持年、年月、年月日、时分、年月周 时分等
> 由于使用UIPickerView的话，列表会有个弧度，所以这里用了[PGPickerView](https://github.com/xiaozhuxiong121/PGPickerView)  

![](F734F5F9-FB12-4BA7-B43E-B39D0FF1DA3B.png)  

[![CocoaPods compatible](https://img.shields.io/cocoapods/v/PGDatePicker.svg)](https://cocoapods.org/pods/PGDatePicker)
![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg)
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 
 [![](https://img.shields.io/badge/jianshu-piggybear-red.svg)](http://www.jianshu.com/u/3740632b2002)
![PGDatePicker](PGDatePicker.gif)    


# CocoaPods安装

```
pod 'PGDatePicker', '>= 1.1.0'
```

# 使用
```
PGDatePicker *datePicker = [[PGDatePicker alloc]init];
datePicker.delegate = self;
[datePicker show];
datePicker.datePickerMode = PGDatePickerModeYear;
 
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
}
```
# 设置Date
> 建议用NSDate+PGCategory类所定义的方法去设置  

```
+ (NSDate *)setYear:(NSUInteger)year;
+ (NSDate *)setYear:(NSUInteger)year month:(NSUInteger)month;
+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)setMonth:(NSUInteger)month day:(NSUInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
+ (NSDate *)setHour:(NSInteger)hour minute:(NSInteger)minute;
```  
比如：```datePicker.maximumDate = [NSDate setYear:2017];```

# 设置样式
```
//设置线条的颜色
datePicker.lineBackgroundColor = [UIColor redColor]; 
//设置选中行的字体颜色
datePicker.titleColorForSelectedRow = [UIColor redColor]; 
//设置未选中行的字体颜色
datePicker.titleColorForOtherRow = [UIColor blackColor]; 
//设置取消按钮的字体颜色
[datePicker.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//设置确定按钮的字体颜色
[datePicker.confirmButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

```

# Swift的使用
[查看使用文档](Swift.md) 

# 许可证

PGNetworkHelper 使用 MIT 许可证，详情见 [LICENSE](LICENSE) 文件。
