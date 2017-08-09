//
//  ViewController.m
//  Demo
//
//  Created by piggybear on 2017/8/8.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "ViewController.h"
#import <PGDatePicker/PGDatePicker.h>

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
    datePicker.datePickerMode = PGDatePickerModeYear;
}

- (IBAction)yearAndMonthHandler:(id)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
}

- (IBAction)dateHandler:(id)sender {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
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


#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
}

@end
