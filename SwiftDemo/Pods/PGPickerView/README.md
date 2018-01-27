# PGPickerView
PGPickerView是将UIPickerView的弯曲弧度变成直列表，可以是单列表，多列表，还可以修改选中label的字体颜色等，用法跟UIPickerView一样。  
![](01F3FA58-E2F9-4BFF-9F49-F07BD32322DD.png)

[![CocoaPods compatible](https://img.shields.io/cocoapods/v/PGPickerView.svg)](https://cocoapods.org/pods/PGPickerView)
![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg)
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 
 [![](https://img.shields.io/badge/jianshu-piggybear-red.svg)](http://www.jianshu.com/u/3740632b2002)

![PGPickerView.gif](PGPickerView.gif)

> 内置3中样式

# 样式一
![样式一](Images/type1.png)


# 样式二
![样式一](Images/type2.png)

# 样式三
![样式一](Images/type3.png)

# 显示中间字
![middle](Images/middle.png)

# CocoaPods安装

```
pod 'PGPickerView', '>= 1.2.1'
```

# 使用

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
# 设置样式
```
//设置线条的颜色
pickerView.lineBackgroundColor = [UIColor redColor];
//设置选中行的字体颜色
pickerView.textColorOfSelectedRow = [UIColor blueColor];
//设置未选中行的字体颜色
pickerView.textColorOfOtherRow = [UIColor blackColor];

```

**更多的使用方法请下载[demo](https://github.com/xiaozhuxiong121/PGPickerView)查看**

# 想要所的话
喜欢的话扔一个免费的[star](https://github.com/xiaozhuxiong121/PGPickerView)，谢谢啦🌺

# 许可证

PGPickerView 使用 MIT 许可证，详情见 [LICENSE](LICENSE) 文件。