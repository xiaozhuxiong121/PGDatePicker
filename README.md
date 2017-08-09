# PGDatePicker
日期选择器，支持年、年月、年月日、时分、年月周 时分等

![](F734F5F9-FB12-4BA7-B43E-B39D0FF1DA3B.png)  

[![CocoaPods compatible](https://img.shields.io/cocoapods/v/PGDatePicker.svg)](https://cocoapods.org/pods/PGNetworkHelper)
![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg)
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 
 [![](https://img.shields.io/badge/jianshu-piggybear-red.svg)](http://www.jianshu.com/u/3740632b2002)
![PGDatePicker](PGDatePicker.gif)
# Installation with CocoaPods

```
pod 'PGDatePicker'
```

# Usage
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


# LICENSE

PGDatePicker is released under an MIT license. See [LICENSE](LICENSE) for more information.