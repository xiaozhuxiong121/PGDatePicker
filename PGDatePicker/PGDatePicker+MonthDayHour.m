//
//  PGDatePicker+MonthDayHour.m
//  Demo
//
//  Created by piggybear on 2018/4/9.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker+MonthDayHour.h"
#import "PGDatePickerHeader.h"
#import "PGDatePicker+Common.h"
#import "PGDatePicker+Logic.h"

@implementation PGDatePicker (MonthDayHour)
- (void)monthDayHour_setupSelectedDate {
    NSString *monthString = [self.pickerView textOfSelectedRowInComponent:0];
    monthString = [monthString componentsSeparatedByString:self.monthString].firstObject;
    self.selectedComponents.month = [monthString integerValue];
    
    NSString *dayString = [self.pickerView textOfSelectedRowInComponent:1];
    dayString = [dayString componentsSeparatedByString:self.dayString].firstObject;
    self.selectedComponents.day = [dayString integerValue];
    
    NSString *hourString = [self.pickerView textOfSelectedRowInComponent:2];
    hourString = [hourString componentsSeparatedByString:self.hourString].firstObject;
    self.selectedComponents.hour = [hourString integerValue];
}

- (void)monthDayHour_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated {
    BOOL tf = false;
    if (components.month > self.maximumComponents.month) {
        components.month = self.maximumComponents.month;
        tf = true;
    }else if (components.month < self.minimumComponents.month) {
        components.month = self.minimumComponents.month;
        tf = true;
    }
    NSInteger row = components.month - self.minimumComponents.month;
    [self.pickerView selectRow:row inComponent:0 animated:animated];
    if (tf) {
        return;
    }
    {
        NSInteger row = 0;
        NSString *string = [NSString stringWithFormat:@"%ld", components.day];
        BOOL isExist = [self.dayList containsObject:string];
        if (isExist) {
            row =[self.dayList indexOfObject:string];
        }
        [self.pickerView selectRow:row inComponent:1 animated:animated];
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
        [self.pickerView selectRow:row inComponent:2 animated:animated];
    }
}

- (void)monthDayHour_didSelectWithComponent:(NSInteger)component {
    NSDateComponents *dateComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    NSString *str = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [str integerValue];
    if (component == 0) {
        BOOL refresh = [self setDayList2WithComponent:component dateComponents:dateComponents refresh:true];
        [self.pickerView reloadComponent:1 refresh:refresh];
    }
    if (component == 0 || component == 1) {
        BOOL refresh = [self setHourList3WithDateComponents:dateComponents refresh:true];
        [self.pickerView reloadComponent:2 refresh:refresh];
    }
}
@end
