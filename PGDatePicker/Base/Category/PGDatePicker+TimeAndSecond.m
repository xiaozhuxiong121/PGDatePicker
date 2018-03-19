//
//  PGDatePicker+TimeAndSecond.m
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker+TimeAndSecond.h"
#import "PGDatePickerHeader.h"
#import "PGDatePicker+Common.h"
#import "PGDatePicker+Logic.h"

@implementation PGDatePicker (TimeAndSecond)
- (void)timeAndSecond_setupSelectedDate {
    NSString *hourString = [self.pickerView textOfSelectedRowInComponent:0];
    hourString = [hourString componentsSeparatedByString:self.hourString].firstObject;
    self.selectedComponents.hour = [hourString integerValue];
    
    NSString *minuteString = [self.pickerView textOfSelectedRowInComponent:1];
    minuteString = [minuteString componentsSeparatedByString:self.minuteString].firstObject;
    self.selectedComponents.minute = [minuteString integerValue];
    
    NSString *secondString = [self.pickerView textOfSelectedRowInComponent:2];
    secondString = [secondString componentsSeparatedByString:self.secondString].firstObject;
    self.selectedComponents.second = [secondString integerValue];
}

- (void)timeAndSecond_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated {
    if (components.hour > self.maximumComponents.hour) {
        components = self.maximumComponents;
    }
    if (components.hour < self.minimumComponents.hour) {
        components = self.minimumComponents;
    }
    NSString *string = [NSString stringWithFormat:@"%ld", components.hour];
    if (components.hour < 10) {
        string = [NSString stringWithFormat:@"0%ld", components.hour];
    }
    NSInteger row = 0;
    BOOL isExist = [self.hourList containsObject:string];
    if (isExist) {
        row = [self.hourList indexOfObject:string];
    }
    [self.pickerView selectRow:row inComponent:0 animated:animated];
    {
        NSString *string = [NSString stringWithFormat:@"%ld", components.minute];
        if (components.minute < 10) {
            string = [NSString stringWithFormat:@"0%ld", components.minute];
        }
        NSInteger row = 0;
        BOOL isExist = [self.minuteList containsObject:string];
        if (isExist) {
            row = [self.minuteList indexOfObject:string];
        }
        [self.pickerView selectRow:row inComponent:1 animated:animated];
    }
    {
        NSString *string = [NSString stringWithFormat:@"%ld", components.second];
        if (components.second < 10) {
            string = [NSString stringWithFormat:@"0%ld", components.second];
        }
        NSInteger row = 0;
        BOOL isExist = [self.secondList containsObject:string];
        if (isExist) {
            row = [self.secondList indexOfObject:string];
        }
        [self.pickerView selectRow:row inComponent:2 animated:animated];
    }
}

- (void)timeAndSecond_didSelectWithComponent:(NSInteger)component {
    NSDateComponents *dateComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    NSString *str = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.hourString].firstObject;
    dateComponents.hour = [str integerValue];
    if (component == 0) {
        BOOL refresh = [self setMinuteList3WithComponent:component dateComponents:dateComponents refresh:true];
        [self.pickerView reloadComponent:1 refresh:refresh];
    }
    if (component != 2) {
        BOOL refresh = [self setSecondListWithComponent:component dateComponents:dateComponents refresh:true];
        [self.pickerView reloadComponent:2 refresh:refresh];
    }
}
@end
