//
//  ViewController.m
//  Demo
//
//  Created by piggybear on 2017/8/8.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "ViewController.h"
#import "PGDatePickManager.h"

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
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.style = PGDatePickManagerStyle2;
    datePickManager.isShadeBackgroud = true;
    
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.isHiddenMiddleText = false;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeYear;
    [self presentViewController:datePickManager animated:false completion:nil];
    
    
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
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.style = PGDatePickManagerStyle3;
    datePickManager.isShadeBackgroud = true;
    
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType2;
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    [self presentViewController:datePickManager animated:false completion:nil];
    
    //    datePicker.minimumDate = [NSDate setYear:2015 month:5];
    //    datePicker.maximumDate = [NSDate setYear:2017 month:10];
    //
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    //    NSDate *date = [dateFormatter dateFromString: @"2015-08-10 05:04"];
    //    [datePicker setDate:date animated:true];
    
    
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    //    NSDate *date = [dateFormatter dateFromString: @"2019-08-10 05:04"];
    //    [datePicker setDate:date animated:true];
}

/**
 年月日
 */
- (IBAction)dateHandler:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.isHiddenMiddleText = false;
    datePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
    
//    datePicker.minimumDate = [NSDate setYear:2015 month:5 day:10];
//    datePicker.maximumDate = [NSDate setYear:2029 month:10 day:16];
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    NSDate *date = [dateFormatter dateFromString: @"2019-08-10 05:04"];
//    [datePicker setDate:date animated:true];
}

/**
 年月日时分
 */
- (IBAction)dateHourMinuteHandler:(UIButton *)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType2;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinute;
    [self presentViewController:datePickManager animated:false completion:nil];
    
    
//    datePicker.minimumDate = [NSDate setYear:2018 month:1 day:10 hour:18 minute:6];
//    datePicker.maximumDate = [NSDate setYear:2020 month:2 day:27 hour:22 minute:30];
//
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    NSDate *date = [dateFormatter dateFromString: @"2020-01-27 05:04"];
//    [datePicker setDate:date animated:true];
}

/**
 年月日时分秒
 */
- (IBAction)dateHourMinuteSecondHandler:(UIButton *)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinuteSecond;
    [self presentViewController:datePickManager animated:false completion:nil];
    
//        datePicker.minimumDate = [NSDate setYear:2018 month:5 day:10 hour:18 minute:6 second:10];
//        datePicker.maximumDate = [NSDate setYear:2019 month:11 day:27 hour:22 minute:30 second:40];
    
    
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //    NSDate *date = [dateFormatter dateFromString: @"2019-08-10 05:44:55"];
    //    [datePicker setDate:date animated:true];
}

/**
 时分
 */
- (IBAction)timeHandler:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeTime;
    [self presentViewController:datePickManager animated:false completion:nil];
    
//    datePicker.minimumDate = [NSDate setHour:10 minute:10];
//    datePicker.maximumDate = [NSDate setHour:23 minute:5];
    
    
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //    NSDate *date = [dateFormatter dateFromString: @"2019-08-10 05:04:05"];
    //    [datePicker setDate:date animated:true];
}

/**
 时分秒
 */
- (IBAction)timeAndSecondHandler:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeTimeAndSecond;
    [self presentViewController:datePickManager animated:false completion:nil];
    
    
    //    datePicker.minimumDate = [NSDate setHour:10 minute:10 second:10];
    //    datePicker.maximumDate = [NSDate setHour:23 minute:20 second:40];
    
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //    NSDate *date = [dateFormatter dateFromString: @"2019-08-10 05:04:05"];
    //    [datePicker setDate:date animated:true];
}

/**
 分秒
 */
- (IBAction)minuteAndSecondHandler:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeMinuteAndSecond;
    [self presentViewController:datePickManager animated:false completion:nil];
    
//    datePicker.minimumDate = [NSDate setMinute:1 second:10];
//    datePicker.maximumDate = [NSDate setMinute:6 second:20];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSDate *date = [dateFormatter dateFromString: @"2019-08-10 05:04:05"];
//    [datePicker setDate:date animated:true];
}

/**
 月日周 时分
 */
- (IBAction)dateAndTimeHandler:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.isHiddenMiddleText = false;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeDateAndTime;
    [self presentViewController:datePickManager animated:false completion:nil];
}

/**
 显示标题
 */
- (IBAction)titleHandler:(UIButton *)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePickManager.titleLabel.text = @"PGDatePicker";
    datePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
}

/**
 设置样式
 */
- (IBAction)styleHandler:(id)sender {
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
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
}

@end
