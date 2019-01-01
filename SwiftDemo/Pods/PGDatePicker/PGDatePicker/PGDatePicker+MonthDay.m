//
//  PGDatePicker+MonthDay.m
//  Demo
//
//  Created by piggybear on 2018/4/9.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker+MonthDay.h"
#import "PGDatePickerHeader.h"
#import "PGDatePicker+Logic.h"
#import "PGDatePicker+Common.h"

@implementation PGDatePicker (MonthDay)
- (void)monthDay_setupSelectedDate {
    NSString *monthString = [self.pickerView textOfSelectedRowInComponent:0];
    monthString = [monthString componentsSeparatedByString:self.monthString].firstObject;
    
    NSString *dayString = [self.pickerView textOfSelectedRowInComponent:1];
    dayString = [dayString componentsSeparatedByString:self.dayString].firstObject;
    
    self.selectedComponents.month = [monthString integerValue];
    self.selectedComponents.day = [dayString integerValue];
}

- (void)monthDay_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated {
    if (components.month > self.maximumComponents.month) {
        components.month = self.maximumComponents.month;
    }else if (components.month < self.minimumComponents.month) {
        components.month = self.minimumComponents.month;
    }
    NSInteger row = components.month - self.minimumComponents.month;
    [self.pickerView selectRow:row inComponent:0 animated:animated];
    {
        NSInteger row = 0;
        NSString *string = [NSString stringWithFormat:@"%ld", components.day];
        BOOL isExist = [self.dayList containsObject:string];
        if (isExist) {
            row = [self.dayList indexOfObject:string];
        }
        [self.pickerView selectRow:row inComponent:1 animated:animated];
    }
}

- (void)monthDay_didSelectWithComponent:(NSInteger)component {
    NSDateComponents *dateComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    NSString *str = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [str integerValue];
    if (component == 0) {
        BOOL refresh = [self setDayList2WithComponent:component dateComponents:dateComponents refresh:true];
        [self.pickerView reloadComponent:1 refresh:refresh];
    }
}
@end
