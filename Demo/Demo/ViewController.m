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

- (IBAction)yearHandler:(UIButton *)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.minimumDate = [NSDate setYear:2015];
    datePicker.maximumDate = [NSDate setYear:2020];
    datePicker.datePickerMode = PGDatePickerModeYear;
}

- (IBAction)yearAndMonthHandler:(id)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
//    datePicker.minimumDate = [NSDate setYear:2015 month:5];
    datePicker.maximumDate = [NSDate setYear:2020 month:10];
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
}

- (IBAction)dateHandler:(id)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.minimumDate = [NSDate setYear:2015 month:5 day:10];
    datePicker.maximumDate = [NSDate setYear:2020 month:10 day:20];
    datePicker.datePickerMode = PGDatePickerModeDate;
}

- (IBAction)timeHandler:(id)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.datePickerMode = PGDatePickerModeTime;
}

- (IBAction)dateAndTimeHandler:(id)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.datePickerMode = PGDatePickerModeDateAndTime;
}

- (IBAction)titleHandler:(UIButton *)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.titleLabel.text = @"PGDatePicker";
    datePicker.datePickerMode = PGDatePickerModeDate;
}

- (IBAction)styleHandler:(id)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.titleLabel.text = @"PGDatePicker";
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
    datePicker.datePickerMode = PGDatePickerModeDate;
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
}

@end
