//
//  PGDatePicker+Time.m
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker+Time.h"
#import "PGDatePickerHeader.h"
#import "PGDatePicker+Common.h"
#import "PGDatePicker+Logic.h"

@implementation PGDatePicker (Time)
- (void)time_setupSelectedDate {
    NSString *hourString = [self.pickerView textOfSelectedRowInComponent:0];
    hourString = [hourString componentsSeparatedByString:self.hourString].firstObject;
    
    NSString *minuteString = [self.pickerView textOfSelectedRowInComponent:1];
    minuteString = [minuteString componentsSeparatedByString:self.minuteString].firstObject;
    
    self.selectedComponents.hour = [hourString integerValue];
    self.selectedComponents.minute = [minuteString integerValue];
}

- (void)time_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated {
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
}

- (void)time_didSelectWithComponent:(NSInteger)component {
    NSDateComponents *dateComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    NSString *str = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.hourString].firstObject;
    dateComponents.hour = [str integerValue];
    if (component == 0) {
        BOOL refresh = [self setMinuteListWithComponent:component dateComponents:dateComponents refresh:true];
        [self.pickerView reloadComponent:1 refresh:refresh];
    }
}
@end
