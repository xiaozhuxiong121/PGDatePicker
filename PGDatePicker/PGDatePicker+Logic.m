//
//  PGDatePicker+Logic.m
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker+Logic.h"
#import "PGDatePickerHeader.h"
#import "PGDatePicker+Common.h"

@implementation PGDatePicker (Logic)
- (void)setDayListForMonthDays:(NSInteger)day {
    NSMutableArray *days = [NSMutableArray arrayWithCapacity:day];
    NSInteger minDay = 1, maxDay = self.maximumComponents.day;
    if (self.yearList.count == 1 && self.monthList.count == 1) {
        minDay = self.minimumComponents.day;
        day = maxDay;
    }
    if (self.selectComponents.year == self.maximumComponents.year && self.selectComponents.month == self.maximumComponents.month) {
        day = maxDay;
    }
    if (self.selectComponents.year == self.minimumComponents.year && self.selectComponents.month == self.minimumComponents.month) {
        minDay = self.minimumComponents.day;
    }
    for (NSUInteger i = minDay; i <= day; i++) {
        [days addObject:[@(i) stringValue]];
    }
    self.dayList = days;
}

- (BOOL)setDayListWithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.year == self.maximumComponents.year && self.minimumComponents.month == self.maximumComponents.month) {
        NSInteger min = self.minimumComponents.day;
        NSInteger max = self.maximumComponents.day;
        if (min > max) {
            min = 1;
        }
        NSMutableArray *days = [NSMutableArray array];
        for (NSUInteger i = min; i <= max; i++) {
            [days addObject:[@(i) stringValue]];
        }
        self.dayList = days;
        return refresh;
    }
    
    BOOL tmp = refresh;
    NSString *yearString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.yearString].firstObject;
    dateComponents.year = [yearString integerValue];
    
    NSString *monthString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [monthString integerValue];
    NSInteger day = [self howManyDaysWithMonthInThisYear:[yearString integerValue] withMonth:[monthString integerValue]];
    [self setDayListForMonthDays:day];
    if (self.minimumComponents.year == dateComponents.year && self.minimumComponents.month == dateComponents.month) {
        NSMutableArray *days = [NSMutableArray array];
        for (NSUInteger i = self.minimumComponents.day; i <= day; i++) {
            [days addObject:[@(i) stringValue]];
        }
        self.dayList = days;
    }else if (self.maximumComponents.year == dateComponents.year && self.maximumComponents.month == dateComponents.month) {
        NSMutableArray *days = [NSMutableArray array];
        for (NSUInteger i = 1; i <= self.maximumComponents.day; i++) {
            [days addObject:[@(i) stringValue]];
        }
        self.dayList = days;
    }else{
        tmp = false;
        NSMutableArray *days = [NSMutableArray arrayWithCapacity:day];
        for (NSUInteger i = 1; i <= day; i++) {
            [days addObject:[@(i) stringValue]];
        }
        self.dayList = days;
    }
    return tmp;
}

//月开头的需要使用
- (BOOL)setDayList2WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.month == self.maximumComponents.month) {
        NSInteger min = self.minimumComponents.day;
        NSInteger max = self.maximumComponents.day;
        if (min > max) {
            min = 1;
        }
        NSMutableArray *days = [NSMutableArray array];
        for (NSUInteger i = min; i <= max; i++) {
            [days addObject:[@(i) stringValue]];
        }
        self.dayList = days;
        return refresh;
    }
    BOOL tmp = refresh;
    NSString *monthString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [monthString integerValue];
    NSInteger day = [self howManyDaysWithMonthInThisYear:dateComponents.year withMonth:[monthString integerValue]];
    [self setDayListForMonthDays:day];
    if (self.minimumComponents.month == dateComponents.month) {
        NSMutableArray *days = [NSMutableArray array];
        for (NSUInteger i = self.minimumComponents.day; i <= day; i++) {
            [days addObject:[@(i) stringValue]];
        }
        self.dayList = days;
    }else if (self.maximumComponents.month == dateComponents.month) {
        NSMutableArray *days = [NSMutableArray array];
        for (NSUInteger i = 1; i <= self.maximumComponents.day; i++) {
            [days addObject:[@(i) stringValue]];
        }
        self.dayList = days;
    }else{
        tmp = false;
        NSMutableArray *days = [NSMutableArray arrayWithCapacity:day];
        for (NSUInteger i = 1; i <= day; i++) {
            [days addObject:[@(i) stringValue]];
        }
        self.dayList = days;
    }
    return tmp;
}

- (BOOL)setHourListWithDateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.month == self.maximumComponents.month && self.minimumComponents.day == dateComponents.day) {
        NSInteger min = self.minimumComponents.hour;
        NSInteger max = self.maximumComponents.hour;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
        return refresh;
    }
    
    BOOL tmp = refresh;
    NSInteger length = 23;
    if (self.minimumComponents.month == dateComponents.month && self.minimumComponents.day == dateComponents.day) {
        refresh = true;
        NSInteger index = length - self.minimumComponents.hour;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.hour; i <= length; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }else if (self.maximumComponents.month == dateComponents.month && self.maximumComponents.day == dateComponents.day) {
        refresh = true;
        NSInteger index = self.maximumComponents.hour;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.hour; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }else{
        tmp = false;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }
    return  tmp;
}

- (BOOL)setHourList2WithDateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.year == self.maximumComponents.year && self.minimumComponents.month == self.maximumComponents.month && self.minimumComponents.day == self.maximumComponents.day) {
        NSInteger min = self.minimumComponents.hour;
        NSInteger max = self.maximumComponents.hour;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
        return refresh;
    }
    
    NSString *yearString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.yearString].firstObject;
    dateComponents.year = [yearString integerValue];
    
    NSString *monthString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [monthString integerValue];
    
    NSString *dayString = [[self.pickerView textOfSelectedRowInComponent:2] componentsSeparatedByString:self.dayString].firstObject;
    dateComponents.day = [dayString integerValue];
    
    BOOL tmp = refresh;
    NSInteger length = 23;
    if (self.minimumComponents.year == dateComponents.year && self.minimumComponents.month == dateComponents.month && self.minimumComponents.day == dateComponents.day) {
        refresh = true;
        NSInteger index = length - self.minimumComponents.hour;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.hour; i <= length; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }else if (self.maximumComponents.year == dateComponents.year && self.maximumComponents.month == dateComponents.month && self.maximumComponents.day == dateComponents.day) {
        refresh = true;
        NSInteger index = self.maximumComponents.hour;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.hour; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }else{
        tmp = false;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }
    return tmp;
}

- (BOOL)setHourList3WithDateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.month == self.maximumComponents.month && self.minimumComponents.day == self.maximumComponents.day) {
        NSInteger min = self.minimumComponents.hour;
        NSInteger max = self.maximumComponents.hour;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
        return refresh;
    }
    
    NSString *monthString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [monthString integerValue];
    
    NSString *dayString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.dayString].firstObject;
    dateComponents.day = [dayString integerValue];
    
    BOOL tmp = refresh;
    NSInteger length = 23;
    if (self.minimumComponents.month == dateComponents.month && self.minimumComponents.day == dateComponents.day) {
        refresh = true;
        NSInteger index = length - self.minimumComponents.hour;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.hour; i <= length; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }else if (self.maximumComponents.month == dateComponents.month && self.maximumComponents.day == dateComponents.day) {
        refresh = true;
        NSInteger index = self.maximumComponents.hour;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.hour; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }else{
        tmp = false;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }
    return tmp;
}

- (BOOL)setMinuteListWithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.hour == self.maximumComponents.hour) {
        NSInteger min = self.minimumComponents.minute;
        NSInteger max = self.maximumComponents.minute;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
        return refresh;
    }
    
    NSInteger length = 59;
    BOOL tmp = refresh;
    if (self.minimumComponents.hour == dateComponents.hour) {
        refresh = true;
        NSInteger index = length - self.minimumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.minute; i <= length; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else if (self.maximumComponents.hour == dateComponents.hour) {
        refresh = true;
        NSInteger index = self.maximumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.minute; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else{
        refresh = false;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }
    return tmp;
}

- (BOOL)setMinuteList2WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.year == self.maximumComponents.year && self.minimumComponents.month == self.maximumComponents.month && self.minimumComponents.day == self.maximumComponents.day && self.minimumComponents.hour == self.maximumComponents.hour) {
        NSInteger min = self.minimumComponents.minute;
        NSInteger max = self.maximumComponents.minute;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
        return refresh;
    }
    BOOL tmp = refresh;
    NSString *yearString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.yearString].firstObject;
    dateComponents.year = [yearString integerValue];
    NSString *monthString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [monthString integerValue];
    
    NSString *dayString = [[self.pickerView textOfSelectedRowInComponent:2] componentsSeparatedByString:self.dayString].firstObject;
    dateComponents.day = [dayString integerValue];
    
    NSString *hourString = [[self.pickerView textOfSelectedRowInComponent:3] componentsSeparatedByString:self.hourString].firstObject;
    dateComponents.hour = [hourString integerValue];
    
    NSInteger length = 59;
    if (self.minimumComponents.year == dateComponents.year && self.minimumComponents.month == dateComponents.month && self.minimumComponents.day == dateComponents.day && self.minimumComponents.hour == dateComponents.hour) {
        NSInteger index = length - self.minimumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.minute; i <= length; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else if (self.maximumComponents.year == dateComponents.year && self.maximumComponents.month == dateComponents.month && self.maximumComponents.day == dateComponents.day && self.maximumComponents.hour == dateComponents.hour) {
        NSInteger index = self.maximumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.minute; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else{
        tmp = false;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }
    return tmp;
}

- (BOOL)setMinuteList3WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.hour == self.maximumComponents.hour) {
        NSInteger min = self.minimumComponents.minute;
        NSInteger max = self.maximumComponents.minute;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
        return refresh;
    }
    
    BOOL tmp = refresh;
    NSInteger length = 59;
    if (self.minimumComponents.hour == dateComponents.hour) {
        NSInteger index = length - self.minimumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.minute; i <= length; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else if (self.maximumComponents.hour == dateComponents.hour) {
        NSInteger index = self.maximumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.minute; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else{
        tmp = false;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }
    return tmp;
}

//月日周 时分
- (BOOL)setMinuteList4WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.month == self.maximumComponents.month && dateComponents.hour == self.minimumComponents.hour) {
        NSInteger min = self.minimumComponents.minute;
        NSInteger max = self.maximumComponents.minute;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i++) {
            [minutes addObject:[@(i) stringValue]];
        }
        self.minuteList = minutes;
        return refresh;
    }
    if (self.minimumComponents.month == self.maximumComponents.month && self.minimumComponents.day == self.maximumComponents.day &&self.minimumComponents.hour == self.maximumComponents.hour) {
        NSInteger min = self.minimumComponents.minute;
        NSInteger max = self.maximumComponents.minute;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
        return refresh;
    }
    
    NSInteger length = 59;
    BOOL tmp = refresh;
    if (self.minimumComponents.month == dateComponents.month && self.minimumComponents.day == dateComponents.day && self.minimumComponents.hour == dateComponents.hour) {
        refresh = true;
        NSInteger index = length - self.minimumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.minute; i <= length; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else if (self.maximumComponents.month == dateComponents.month && self.maximumComponents.day == dateComponents.day && self.maximumComponents.hour == dateComponents.hour) {
        refresh = true;
        NSInteger index = self.maximumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.minute; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else{
        refresh = false;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }
    return tmp;
}

- (BOOL)setMinuteList5WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.month == self.maximumComponents.month && self.minimumComponents.day == self.maximumComponents.day && self.minimumComponents.hour == self.maximumComponents.hour) {
        NSInteger min = self.minimumComponents.minute;
        NSInteger max = self.maximumComponents.minute;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
        return refresh;
    }
    BOOL tmp = refresh;
    NSString *monthString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [monthString integerValue];
    
    NSString *dayString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.dayString].firstObject;
    dateComponents.day = [dayString integerValue];
    
    NSString *hourString = [[self.pickerView textOfSelectedRowInComponent:2] componentsSeparatedByString:self.hourString].firstObject;
    dateComponents.hour = [hourString integerValue];
    
    NSInteger length = 59;
    if (self.minimumComponents.month == dateComponents.month && self.minimumComponents.day == dateComponents.day && self.minimumComponents.hour == dateComponents.hour) {
        NSInteger index = length - self.minimumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.minute; i <= length; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else if (self.maximumComponents.month == dateComponents.month && self.maximumComponents.day == dateComponents.day && self.maximumComponents.hour == dateComponents.hour) {
        NSInteger index = self.maximumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.minute; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else{
        tmp = false;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }
    return tmp;
}

- (BOOL)setSecondListWithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.hour == self.maximumComponents.hour && self.minimumComponents.minute == self.maximumComponents.minute) {
        NSInteger min = self.minimumComponents.second;
        NSInteger max = self.maximumComponents.second;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
        return refresh;
    }
    BOOL tmp = refresh;
    NSString *hourString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.hourString].firstObject;
    dateComponents.hour = [hourString integerValue];
    
    NSString *minuteString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.minuteString].firstObject;
    dateComponents.minute = [minuteString integerValue];
    
    NSInteger length = 59;
    if (self.minimumComponents.hour == dateComponents.hour && self.minimumComponents.minute == dateComponents.minute) {
        NSInteger index = length - self.minimumComponents.second;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.second; i <= length; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }else if (self.maximumComponents.hour == dateComponents.hour && self.maximumComponents.minute == dateComponents.minute) {
        NSInteger index = self.maximumComponents.second;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.second; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }else{
        tmp = false;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }
    return tmp;
}

- (BOOL)setSecondList2WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.year == self.maximumComponents.year && self.minimumComponents.month == self.maximumComponents.month && self.minimumComponents.day == self.maximumComponents.day && self.minimumComponents.hour == self.maximumComponents.hour && self.minimumComponents.minute == self.maximumComponents.minute) {
        NSInteger min = self.minimumComponents.second;
        NSInteger max = self.maximumComponents.second;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
        return refresh;
    }
    BOOL tmp = refresh;
    NSString *yearString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.yearString].firstObject;
    dateComponents.year = [yearString integerValue];
    
    NSString *monthString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [monthString integerValue];
    
    NSString *dayString = [[self.pickerView textOfSelectedRowInComponent:2] componentsSeparatedByString:self.dayString].firstObject;
    dateComponents.day = [dayString integerValue];
    
    NSString *hourString = [[self.pickerView textOfSelectedRowInComponent:3] componentsSeparatedByString:self.hourString].firstObject;
    dateComponents.hour = [hourString integerValue];
    
    NSString *minuteString = [[self.pickerView textOfSelectedRowInComponent:4] componentsSeparatedByString:self.minuteString].firstObject;
    dateComponents.minute = [minuteString integerValue];
    
    NSInteger length = 59;
    if (self.minimumComponents.year == dateComponents.year && self.minimumComponents.month == dateComponents.month && self.minimumComponents.day == dateComponents.day && self.minimumComponents.hour == dateComponents.hour && self.minimumComponents.minute == dateComponents.minute) {
        NSInteger index = length - self.minimumComponents.second;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.second; i <= length; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }else if (self.maximumComponents.year == dateComponents.year && self.maximumComponents.month == dateComponents.month && self.maximumComponents.day == dateComponents.day && self.maximumComponents.hour == dateComponents.hour && self.maximumComponents.minute == dateComponents.minute) {
        NSInteger index = self.maximumComponents.second;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.second; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }else{
        tmp = false;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }
    return tmp;
}

//分秒
- (BOOL)setSecondList3WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.minute == self.maximumComponents.minute) {
        NSInteger min = self.minimumComponents.second;
        NSInteger max = self.maximumComponents.second;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
        return refresh;
    }
    BOOL tmp = refresh;
    NSString *minuteString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.minuteString].firstObject;
    dateComponents.minute = [minuteString integerValue];
    
    NSInteger length = 59;
    if (self.minimumComponents.minute == dateComponents.minute) {
        NSInteger index = length - self.minimumComponents.second;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.second; i <= length; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }else if (self.maximumComponents.minute == dateComponents.minute) {
        NSInteger index = self.maximumComponents.second;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.second; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }else{
        tmp = false;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }
    return tmp;
}

- (BOOL)setSecondList4WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.month == self.maximumComponents.month &&
        self.minimumComponents.day == self.maximumComponents.day &&
        self.minimumComponents.hour == self.maximumComponents.hour &&
        self.minimumComponents.minute == self.maximumComponents.minute) {
        NSInteger min = self.minimumComponents.second;
        NSInteger max = self.maximumComponents.second;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
        return refresh;
    }
    BOOL tmp = refresh;
    NSString *monthString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [monthString integerValue];
    
    NSString *dayString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.dayString].firstObject;
    dateComponents.day = [dayString integerValue];
    
    NSString *hourString = [[self.pickerView textOfSelectedRowInComponent:2] componentsSeparatedByString:self.hourString].firstObject;
    dateComponents.hour = [hourString integerValue];
    
    NSString *minuteString = [[self.pickerView textOfSelectedRowInComponent:3] componentsSeparatedByString:self.minuteString].firstObject;
    dateComponents.minute = [minuteString integerValue];
    
    NSInteger length = 59;
    if (self.minimumComponents.month == dateComponents.month &&
        self.minimumComponents.day == dateComponents.day &&
        self.minimumComponents.hour == dateComponents.hour &&
        self.minimumComponents.minute == dateComponents.minute) {
        NSInteger index = length - self.minimumComponents.second;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.second; i <= length; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }else if (self.maximumComponents.month == dateComponents.month &&
              self.maximumComponents.day == dateComponents.day &&
              self.maximumComponents.hour == dateComponents.hour &&
              self.maximumComponents.minute == dateComponents.minute) {
        NSInteger index = self.maximumComponents.second;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.second; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }else{
        tmp = false;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }
    return tmp;
}

/*
 在临界值的时候(处于最大/最小值)且component=>2(大于等于3列)的时候需要刷新
 年月
 */
- (BOOL)setMonthListWithComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.year == self.maximumComponents.year) {
        NSInteger min = self.minimumComponents.month;
        NSInteger max = self.maximumComponents.month;
        if (max < min) {
            min = 1;
        }
        NSMutableArray *months = [NSMutableArray arrayWithCapacity:max - min];
        for (NSUInteger i = min; i <= max; i++) {
            [months addObject:[@(i) stringValue]];
        }
        self.monthList = months;
        return refresh;
    }
    BOOL tmp = refresh;
    if (self.minimumComponents.year == dateComponents.year) {
        NSInteger index = 12 - self.minimumComponents.month;
        NSMutableArray *months = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.month; i <= 12; i++) {
            [months addObject:[@(i) stringValue]];
        }
        self.monthList = months;
    }else if (self.maximumComponents.year == dateComponents.year) {
        NSInteger index = self.maximumComponents.month;
        NSMutableArray *months = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 1; i <= self.maximumComponents.month; i++) {
            [months addObject:[@(i) stringValue]];
        }
        self.monthList = months;
    }else{
        tmp = false;
        NSMutableArray *months = [NSMutableArray arrayWithCapacity:12];
        for (NSUInteger i = 1; i <= 12; i++) {
            [months addObject:[@(i) stringValue]];
        }
        self.monthList = months;
    }
    return tmp;
}
@end
