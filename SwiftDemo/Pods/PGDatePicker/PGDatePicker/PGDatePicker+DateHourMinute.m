//
//  PGDatePicker+DateHourMinute.m
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker+DateHourMinute.h"
#import "PGDatePickerHeader.h"
#import "PGDatePicker+Common.h"
#import "PGDatePicker+Logic.h"

@implementation PGDatePicker (DateHourMinute)
- (void)dateHourMinute_setupSelectedDate {
    NSString *yearString = [self.pickerView textOfSelectedRowInComponent:0];
    yearString = [yearString componentsSeparatedByString:self.yearString].firstObject;
    self.selectedComponents.year = [yearString integerValue];
    
    NSString *monthString = [self.pickerView textOfSelectedRowInComponent:1];
    monthString = [monthString componentsSeparatedByString:self.monthString].firstObject;
    self.selectedComponents.month = [monthString integerValue];
    
    NSString *dayString = [self.pickerView textOfSelectedRowInComponent:2];
    dayString = [dayString componentsSeparatedByString:self.dayString].firstObject;
    self.selectedComponents.day = [dayString integerValue];
    
    NSString *hourString = [self.pickerView textOfSelectedRowInComponent:3];
    hourString = [hourString componentsSeparatedByString:self.hourString].firstObject;
    self.selectedComponents.hour = [hourString integerValue];
    
    NSString *minuteString = [self.pickerView textOfSelectedRowInComponent:4];
    minuteString = [minuteString componentsSeparatedByString:self.minuteString].firstObject;
    self.selectedComponents.minute = [minuteString integerValue];
}

- (void)dateHourMinute_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated {
    BOOL tf = false;
    if (components.year > self.maximumComponents.year) {
        components.year = self.maximumComponents.year;
        tf = true;
    }else if (components.year < self.minimumComponents.year) {
        components.year = self.minimumComponents.year;
        tf = true;
    }
    NSInteger row = components.year - self.minimumComponents.year;
    [self.pickerView selectRow:row inComponent:0 animated:animated];
    if (tf) {
        return;
    }
    {
        NSInteger row = 0;
        NSString *string = [NSString stringWithFormat:@"%ld", components.month];
        BOOL isExist = [self.monthList containsObject:string];
        if (isExist) {
            row = [self.monthList indexOfObject:string];
        }
        [self.pickerView selectRow:row inComponent:1 animated:animated];
    }
    {
        NSInteger row = 0;
        NSString *string = [NSString stringWithFormat:@"%ld", components.day];
        BOOL isExist = [self.dayList containsObject:string];
        if (isExist) {
            row =[self.dayList indexOfObject:string];
        }
        [self.pickerView selectRow:row inComponent:2 animated:animated];
    }
    {
        NSInteger row = 0;
        NSString *string = [NSString stringWithFormat:@"%ld", components.hour];
        if (components.hour < 10) {
            string = [NSString stringWithFormat:@"0%ld", components.hour];
        }
        BOOL isExist = [self.hourList containsObject:string];
        if (isExist) {
            row = [self.hourList indexOfObject:string];
        }
        [self.pickerView selectRow:row inComponent:3 animated:animated];
    }
    {
        NSInteger row = 0;
        NSString *string = [NSString stringWithFormat:@"%ld", components.minute];
        if (components.minute < 10) {
            string = [NSString stringWithFormat:@"0%ld", components.minute];
        }
        BOOL isExist = [self.minuteList containsObject:string];
        if (isExist) {
            row = [self.minuteList indexOfObject:string];
        }
        [self.pickerView selectRow:row inComponent:4 animated:animated];
    }
}

- (void)dateHourMinute_didSelectWithComponent:(NSInteger)component {
    NSDateComponents *dateComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    NSString *str = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.yearString].firstObject;
    dateComponents.year = [str integerValue];
    if (component == 0) {
        NSString *monthString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.monthString].firstObject;
        dateComponents.month = [monthString integerValue];
        BOOL refresh = [self setMonthListWithComponents:dateComponents refresh:true];
        [self.pickerView reloadComponent:1 refresh:refresh];
    }
    
    if (component == 0 || component == 1) {
        BOOL refresh = [self setDayListWithComponent:component dateComponents:dateComponents refresh:true];
        [self.pickerView reloadComponent:2 refresh:refresh];
    }
    if (component == 0 || component == 1 || component == 2) {
        BOOL refresh = [self setHourList2WithDateComponents:dateComponents refresh:true];
        [self.pickerView reloadComponent:3 refresh:refresh];
    }
    if (component != 4) {
        BOOL refresh = [self setMinuteList2WithComponent:component dateComponents:dateComponents refresh:true];
        [self.pickerView reloadComponent:4 refresh:refresh];
    }
}
@end
