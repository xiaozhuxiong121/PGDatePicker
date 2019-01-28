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
    datePickManager.style = PGDatePickManagerStyleAlertTopButton;
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.showUnit = PGShowUnitTypeNone;
    datePicker.isHiddenMiddleText = false;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerTypeVertical;
    datePicker.datePickerMode = PGDatePickerModeYear;
    [self presentViewController:datePickManager animated:false completion:nil];
    
    
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //    dateFormatter.dateFormat = @"yyyy";
    //
    //    datePicker.minimumDate = [dateFormatter dateFromString: @"2019"];
    //    datePicker.maximumDate = [dateFormatter dateFromString: @"2029"];
    //
    //    NSDate *date = [dateFormatter dateFromString: @"2019"];
    //    [datePicker setDate:date animated:true];
}

/**
 年月
 */
- (IBAction)yearAndMonthHandler:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.style = PGDatePickManagerStyleAlertBottomButton;
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.isHiddenMiddleText = false;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerTypeSegment;
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    [self presentViewController:datePickManager animated:false completion:nil];

//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM";
    
//    datePicker.minimumDate = [dateFormatter dateFromString: @"2018-01"];
//    datePicker.maximumDate = [dateFormatter dateFromString: @"2020-10"];
    
//    NSDate *date = [dateFormatter dateFromString: @"2019-08"];
//    [datePicker setDate:date animated:false];
}

/**
 年月日
 */
- (IBAction)dateHandler:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerTypeVertical;
    datePicker.isHiddenMiddleText = false;
//    datePicker.isCycleScroll = true;
    datePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
//    datePicker.minimumDate = [dateFormatter dateFromString: @"2018-02-18"];
//    datePicker.maximumDate = [dateFormatter dateFromString: @"2020-01-18"];
    
//    NSDate *date = [dateFormatter dateFromString: @"2019-01-18"];
//    [datePicker setDate:date animated:true];
}

/**
 年月日时
 */
- (IBAction)dateHourHandler:(UIButton *)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeDateHour;
    [self presentViewController:datePickManager animated:false completion:nil];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH";
//
//    datePicker.minimumDate = [dateFormatter dateFromString: @"2018-02-01 05"];
//    datePicker.maximumDate = [dateFormatter dateFromString: @"2028-02-01 05"];
    
//    NSDate *date = [dateFormatter dateFromString: @"2020-02-01 05"];
//    [datePicker setDate:date animated: true];
}

/**
 年月日时分
 */
- (IBAction)dateHourMinuteHandler:(UIButton *)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerTypeSegment;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinute;
    [self presentViewController:datePickManager animated:false completion:nil];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
//    datePicker.minimumDate = [dateFormatter dateFromString: @"2018-02-01 05:04"];
//    datePicker.maximumDate = [dateFormatter dateFromString: @"2028-02-01 05:04"];
    
//    NSDate *date = [dateFormatter dateFromString: @"2020-02-01 05:04"];
//    [datePicker setDate:date animated: true];
}

/**
 年月日时分秒
 */
- (IBAction)dateHourMinuteSecondHandler:(UIButton *)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerTypeVertical;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinuteSecond;
    [self presentViewController:datePickManager animated:false completion:nil];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
//    datePicker.minimumDate = [dateFormatter dateFromString: @"2018-02-01 05:04:23"];
//    datePicker.maximumDate = [dateFormatter dateFromString: @"2028-02-01 05:04:23"];
    
//    NSDate *date = [dateFormatter dateFromString: @"2020-02-01 05:04:23"];
//    [datePicker setDate:date animated: true];
}

/**
 月日
 */
- (IBAction)monthAndDayHandler:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerTypeLine;
    datePicker.isHiddenMiddleText = true;
    datePicker.datePickerMode = PGDatePickerModeMonthDay;
    [self presentViewController:datePickManager animated:false completion:nil];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"MM-dd";
//
//    datePicker.minimumDate = [dateFormatter dateFromString: @"02-10"];
//    datePicker.maximumDate = [dateFormatter dateFromString: @"10-18"];
//
//    NSDate *date = [dateFormatter dateFromString: @"05-15"];
//    [datePicker setDate:date animated:true];
}

/**
 月日时
 */
- (IBAction)monthDayAndHourHandler:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerTypeLine;
    datePicker.isHiddenMiddleText = true;
    datePicker.datePickerMode = PGDatePickerModeMonthDayHour;
    [self presentViewController:datePickManager animated:false completion:nil];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"MM-dd-HH";
//
//    datePicker.minimumDate = [dateFormatter dateFromString: @"02-10-10"];
//    datePicker.maximumDate = [dateFormatter dateFromString: @"10-18-20"];
//
//    NSDate *date = [dateFormatter dateFromString: @"05-15-17"];
//    [datePicker setDate:date animated:true];
}

/**
 月日时分
 */
- (IBAction)monthDayHourAndMinuteHandler:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerTypeLine;
    datePicker.isHiddenMiddleText = true;
    datePicker.datePickerMode = PGDatePickerModeMonthDayHourMinute;
    [self presentViewController:datePickManager animated:false completion:nil];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"MM-dd-HH-mm";
//
//    datePicker.minimumDate = [dateFormatter dateFromString: @"02-10-10-15"];
//    datePicker.maximumDate = [dateFormatter dateFromString: @"10-18-20-50"];
//
//    NSDate *date = [dateFormatter dateFromString: @"05-15-17-30"];
//    [datePicker setDate:date animated:true];
}

/**
 月日时分秒
 */
- (IBAction)monthDayHourMinuteSecondHandler:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerTypeLine;
    datePicker.isHiddenMiddleText = true;
    datePicker.datePickerMode = PGDatePickerModeMonthDayHourMinuteSecond;
    [self presentViewController:datePickManager animated:false completion:nil];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"MM-dd-HH-mm-ss";
//
//    datePicker.minimumDate = [dateFormatter dateFromString: @"02-10-10-15-10"];
//    datePicker.maximumDate = [dateFormatter dateFromString: @"10-18-20-50-30"];
//
//    NSDate *date = [dateFormatter dateFromString: @"05-15-17-30-20"];
//    [datePicker setDate:date animated:true];
}

/**
 时分
 */
- (IBAction)timeHandler:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
//    datePicker.isOnlyHourFlag = YES;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeTime;
    [self presentViewController:datePickManager animated:false completion:nil];

//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"HH:mm";
//
//    datePicker.minimumDate = [dateFormatter dateFromString: @"10:11"];
//    datePicker.maximumDate = [dateFormatter dateFromString: @"23:11"];
//
//    NSDate *date = [dateFormatter dateFromString: @"20:11"];
//    [datePicker setDate:date animated:false];
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
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"HH:mm:ss";
//
//    datePicker.minimumDate = [dateFormatter dateFromString: @"10:11:10"];
//    datePicker.maximumDate = [dateFormatter dateFromString: @"23:11:20"];
//
//    NSDate *date = [dateFormatter dateFromString: @"20:11:15"];
//    [datePicker setDate:date animated:false];
}

/**
 分秒
 */
- (IBAction)minuteAndSecondHandler:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeMinuteAndSecond;
    datePicker.secondInterval = 5;
//    datePicker.minuteInterval = 5;
    [self presentViewController:datePickManager animated:false completion:nil];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"mm:ss";
//
//    datePicker.minimumDate = [dateFormatter dateFromString: @"05:10"];
//    datePicker.maximumDate = [dateFormatter dateFromString: @"23:20"];
//
//    NSDate *date = [dateFormatter dateFromString: @"11:15"];
//    [datePicker setDate:date animated:false];
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
    datePickManager.isShadeBackground = true;
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
    
    
    // 自定义收起动画逻辑
    datePickManager.customDismissAnimation = ^NSTimeInterval(UIView *dismissView, UIView *contentView) {
        NSTimeInterval duration = 1.0f;
        [UIView animateWithDuration:duration animations:^{
            contentView.frame = (CGRect){{contentView.frame.origin.x, CGRectGetMaxY(self.view.bounds)}, contentView.bounds.size};
        } completion:^(BOOL finished) {
        }];
        return duration;
    };
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
}

@end
