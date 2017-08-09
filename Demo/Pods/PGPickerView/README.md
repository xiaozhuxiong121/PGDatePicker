# PGPickerView
PGPickerView是将UIPickerView的弯曲弧度变成直列表，可以是单列表，多列表，还可以修改选中label的字体颜色等，用法跟UIPickerView一模一样。  
![01F3FA58-E2F9-4BFF-9F49-F07BD32322DA.png](http://upload-images.jianshu.io/upload_images/1340308-ac6535112d5550ba.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

[![CocoaPods compatible](https://img.shields.io/cocoapods/v/PGPickerView.svg)](https://cocoapods.org/pods/PGPickerView)
![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg)
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 
 [![](https://img.shields.io/badge/jianshu-piggybear-red.svg)](http://www.jianshu.com/u/3740632b2002)

![PGPickerView.gif](http://upload-images.jianshu.io/upload_images/1340308-7a18c3fbd338a1fd.gif?imageMogr2/auto-orient/strip)

# Installation with CocoaPods

```
pod 'PGPickerView'
```

# Usage

```
PGPickerView *pickerView = [[PGPickerView alloc]initWithFrame:self.view.bounds];
pickerView.delegate = self;
pickerView.dataSource = self;
[self.view addSubview:pickerView];

#pragma PGPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(PGPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(PGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}
#pragma  PGPickerViewDelegate
- (nullable NSString *)pickerView:(PGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"label%ld--%ld", component, row];
}
```
# LICENSE

PGPickerView is released under an MIT license. See [LICENSE](LICENSE) for more information.