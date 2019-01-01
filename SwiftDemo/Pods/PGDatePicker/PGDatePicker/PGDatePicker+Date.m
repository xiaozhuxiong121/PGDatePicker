//
//  PGDatePicker+Date.m
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker+Date.h"
#import "PGDatePickerHeader.h"
#import "PGDatePicker+Common.h"
#import "PGDatePicker+Logic.h"

@implementation PGDatePicker (Date)
- (void)date_setupSelectedDate {
    NSString *yearString = [self.pickerView textOfSelectedRowInComponent:0];
    yearString = [yearString componentsSeparatedByString:self.yearString].firstObject;
    
    NSString *monthString = [self.pickerView textOfSelectedRowInComponent:1];
    monthString = [monthString componentsSeparatedByString:self.monthString].firstObject;
    
    NSString *dayString = [self.pickerView textOfSelectedRowInComponent:2];
    dayString = [dayString componentsSeparatedByString:self.dayString].firstObject;
    
    self.selectedComponents.year = [yearString integerValue];
    self.selectedComponents.month = [monthString integerValue];
    self.selectedComponents.day = [dayString integerValue];
}

- (void)date_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated {
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
        //                return;
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
}

- (void)date_didSelectWithComponent:(NSInteger)component {
    NSDateComponents *dateComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    NSString *str = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.yearString].firstObject;
    dateComponents.year = [str integerValue];
    if (component == 0) {
        NSString *str = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.monthString].firstObject;
        dateComponents.month = [str integerValue];
        BOOL refresh = [self setMonthListWithComponents:dateComponents refresh:true];
        [self.pickerView reloadComponent:1 refresh:refresh];
    }
    if (component != 2) {
        BOOL refresh = [self setDayListWithComponent:component dateComponents:dateComponents refresh:false];
        [self.pickerView reloadComponent:2 refresh:refresh];
    }
}
@end
