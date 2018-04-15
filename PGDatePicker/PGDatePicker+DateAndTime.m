//
//  PGDatePicker+DateAndTime.m
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker+DateAndTime.h"
#import "PGDatePickerHeader.h"
#import "NSBundle+PGDatePicker.h"
#import "PGDatePicker+Common.h"
#import "PGDatePicker+Logic.h"

@implementation PGDatePicker (DateAndTime)
- (void)dateAndTime_setupSelectedDate {
    NSString *monthString = [NSBundle localizedStringForKey:@"monthString"];
    NSString *dayString = [NSBundle localizedStringForKey:@"dayString"];
    
    NSString *string = [self.pickerView textOfSelectedRowInComponent:0];
    NSString *str = [string componentsSeparatedByString:monthString].firstObject;
    self.selectedComponents.month = [str integerValue];
    
    NSString *str2 = [string componentsSeparatedByString:monthString].lastObject;
    NSString *str3 = [str2 componentsSeparatedByString:dayString].firstObject;
    self.selectedComponents.day = [str3 integerValue];
    
    NSString *str4 = [str2 substringWithRange:NSMakeRange(str2.length - 3, 2)];
    str4 = [str4 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.selectedComponents.weekday = [self weekDayMappingFrom:str4];
    
    NSString *hourString = [self.pickerView textOfSelectedRowInComponent:1];
    hourString = [hourString componentsSeparatedByString:self.hourString].firstObject;
    
    NSString *minuteString = [self.pickerView textOfSelectedRowInComponent:2];
    minuteString = [minuteString componentsSeparatedByString:self.minuteString].firstObject;
    
    self.selectedComponents.hour = [hourString integerValue];
    self.selectedComponents.minute = [minuteString integerValue];
}

- (void)dateAndTime_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated {
    if (components.month > self.maximumComponents.month) {
        components = self.maximumComponents;
    }
    if (components.month < self.minimumComponents.month) {
        components = self.minimumComponents;
    }
    NSString *monthString = [NSBundle localizedStringForKey:@"monthString"];
    NSString *dayString = [NSBundle localizedStringForKey:@"dayString"];
    NSString *string = [NSString stringWithFormat:@"%ld%@%ld%@ %@ ", components.month, monthString, components.day, dayString, [self weekMappingFrom:components.weekday]];
    NSInteger row = 0;
    BOOL isExist = [self.dateAndTimeList containsObject:string];
    if (isExist) {
        row = [self.dateAndTimeList indexOfObject:string];
    }
    [self.pickerView selectRow:row inComponent:0 animated:animated];
    {
        NSString *string = [NSString stringWithFormat:@"%ld", components.hour];
        if (components.hour < 10) {
            string = [NSString stringWithFormat:@"0%ld", components.hour];
        }
        NSInteger row = 0;
        BOOL isExist = [self.hourList containsObject:string];
        if (isExist) {
            row = [self.hourList indexOfObject:string];
        }
        [self.pickerView selectRow:row inComponent:1 animated:animated];
    }
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
        [self.pickerView selectRow:row inComponent:2 animated:animated];
    }
}

- (void)dateAndTime_didSelectWithComponent:(NSInteger)component {
    NSDateComponents *dateComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    NSString *string = [self.pickerView textOfSelectedRowInComponent:0];
    NSString *str = [string componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [str integerValue];
    NSString *str2 = [string componentsSeparatedByString:self.monthString].lastObject;
    NSString *str3 = [str2 componentsSeparatedByString:self.dayString].firstObject;
    dateComponents.day = [str3 integerValue];
    NSString *str4 = [str2 componentsSeparatedByString:self.dayString].lastObject;
    str4 = [str4 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    dateComponents.weekday = [self weekDayMappingFrom:str4];
    if (component == 0) {
        BOOL refresh = [self setHourListWithDateComponents:dateComponents refresh:true];
        [self.pickerView reloadComponent:1 refresh:refresh];
    }
    if (component != 2) {
        NSString *hourString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.hourString].firstObject;
        dateComponents.hour = [hourString integerValue];
        BOOL refresh = [self setMinuteList4WithComponent:component dateComponents:dateComponents refresh:false];
        [self.pickerView reloadComponent:2 refresh:refresh];
    }
}
@end
