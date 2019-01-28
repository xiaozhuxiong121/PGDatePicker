//
//  PGDatePicker+Common.m
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker+Common.h"
#import "PGDatePickerHeader.h"
@implementation PGDatePicker (Common)
- (NSInteger)weekDayMappingFrom:(NSString *)weekString {
    if ([weekString isEqualToString:self.sundayString]) {
        return 1;
    }
    if ([weekString isEqualToString:self.mondayString]) {
        return 2;
    }
    if ([weekString isEqualToString:self.tuesdayString]) {
        return 3;
    }
    if ([weekString isEqualToString:self.wednesdayString]) {
        return 4;
    }
    if ([weekString isEqualToString:self.thursdayString]) {
        return 5;
    }
    if ([weekString isEqualToString:self.fridayString]) {
        return 6;
    }
    if ([weekString isEqualToString:self.saturdayString]) {
        return 7;
    }
    return 0;
}

- (NSString *)weekMappingFrom:(NSInteger)weekDay {
    switch (weekDay) {
        case 1:
            return self.sundayString;
        case 2:
            return self.mondayString;
        case 3:
            return self.tuesdayString;
        case 4:
            return self.wednesdayString;
        case 5:
            return self.thursdayString;
        case 6:
            return self.fridayString;
        case 7:
            return self.saturdayString;
        default:
            break;
    }
    return nil;
}

- (NSInteger)daysWithMonthInThisYear:(NSInteger)year withMonth:(NSInteger)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld",year,month];
    NSDate *date = [formatter dateFromString:dateStr];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:date];
    return range.length;
    
}
@end
