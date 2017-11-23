//
//  ViewController.m
//  Demo
//
//  Created by piggybear on 2017/8/8.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "ViewController.h"
#import "PGDatePicker.h"

@interface ViewController ()<PGDatePickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 年份
 */
- (IBAction)yearHandler:(UIButton *)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType3;
    [datePicker show];
    datePicker.datePickerMode = PGDatePickerModeYear;
    
    
//    datePicker.minimumDate = [NSDate setYear:2015];
//    datePicker.maximumDate = [NSDate setYear:2030];
    
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    NSDate *date = [dateFormatter dateFromString: @"2019-08-10 05:04"];
//    [datePicker setDate:date animated:true];
}

/**
 年月
 */
- (IBAction)yearAndMonthHandler:(id)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    
    
//    datePicker.minimumDate = [NSDate setYear:2015 month:5];
//    datePicker.maximumDate = [NSDate setYear:2025 month:10];
    
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    NSDate *date = [dateFormatter dateFromString: @"2019-08-10 05:04"];
//    [datePicker setDate:date animated:true];
}

/**
 年月日
 */
- (IBAction)dateHandler:(id)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.datePickerType = PGPickerViewType2;
    datePicker.isHiddenMiddleText = false;
    datePicker.datePickerMode = PGDatePickerModeDate;
    
    
//    datePicker.minimumDate = [NSDate setYear:2015 month:8 day:5];
//    datePicker.maximumDate = [NSDate setYear:2025 month:10 day:20];


//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    NSDate *date = [dateFormatter dateFromString: @"2019-08-10 05:04"];
//    [datePicker setDate:date animated:true];
}

/**
 年月日时分
 */
- (IBAction)dateHourMinuteHandler:(UIButton *)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.datePickerType = PGPickerViewType2;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinute;
    
    
//    datePicker.minimumDate = [NSDate setYear:2015 month:5 day:10 hour:18 minute:6];
//    datePicker.maximumDate = [NSDate setYear:2025 month:11 day:27 hour:22 minute:30];


//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    NSDate *date = [dateFormatter dateFromString: @"2019-08-10 05:04"];
//    [datePicker setDate:date animated:true];
}

/**
 年月日时分秒
 */
- (IBAction)dateHourMinuteSecondHandler:(UIButton *)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinuteSecond;
    
    
//    datePicker.minimumDate = [NSDate setYear:2015 month:5 day:10 hour:18 minute:6 second:10];
//    datePicker.maximumDate = [NSDate setYear:2025 month:11 day:27 hour:22 minute:30 second:40];


//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSDate *date = [dateFormatter dateFromString: @"2019-08-10 05:44:55"];
//    [datePicker setDate:date animated:true];
}

/**
 时分
 */
- (IBAction)timeHandler:(id)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.datePickerMode = PGDatePickerModeTime;
    
    
//    datePicker.minimumDate = [NSDate setHour:10 minute:10];
//    datePicker.maximumDate = [NSDate setHour:23 minute:20];


//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSDate *date = [dateFormatter dateFromString: @"2019-08-10 05:04:05"];
//    [datePicker setDate:date animated:true];
}

/**
 时分秒
 */
- (IBAction)timeAndSecondHandler:(id)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.datePickerMode = PGDatePickerModeTimeAndSecond;
    
    
//    datePicker.minimumDate = [NSDate setHour:10 minute:10 second:10];
//    datePicker.maximumDate = [NSDate setHour:23 minute:20 second:40];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSDate *date = [dateFormatter dateFromString: @"2019-08-10 05:04:05"];
//    [datePicker setDate:date animated:true];
}

/**
 月日周 时分
 */
- (IBAction)dateAndTimeHandler:(id)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.datePickerMode = PGDatePickerModeDateAndTime;
}

/**
 显示标题
 */
- (IBAction)titleHandler:(UIButton *)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.titleLabel.text = @"PGDatePicker";
    datePicker.datePickerMode = PGDatePickerModeDate;
}

/**
 设置样式
 */
- (IBAction)styleHandler:(id)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.datePickerMode = PGDatePickerModeDate;
    
    datePicker.titleLabel.text = @"PGDatePicker";
    //设置线条的颜色
    datePicker.lineBackgroundColor = [UIColor redColor];
    //设置选中行的字体颜色
    datePicker.textColorOfSelectedRow = [UIColor redColor];
    //设置未选中行的字体颜色
    datePicker.textColorOfOtherRow = [UIColor blackColor];
    //设置取消按钮的字体颜色
    datePicker.cancelButtonTextColor = [UIColor blackColor];
    //设置取消按钮的字
    datePicker.cancelButtonText = @"Cancel";
    //设置取消按钮的字体大小
    datePicker.cancelButtonFont = [UIFont boldSystemFontOfSize:17];
    
    //设置确定按钮的字体颜色
    datePicker.confirmButtonTextColor = [UIColor redColor];
    //设置确定按钮的字
    datePicker.confirmButtonText = @"Sure";
    //设置确定按钮的字体大小
    datePicker.confirmButtonFont = [UIFont boldSystemFontOfSize:17];
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
}

@end
