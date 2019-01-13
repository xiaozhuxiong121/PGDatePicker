//
//  PGDatePicker+Common.h
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (Common)
- (NSInteger)weekDayMappingFrom:(NSString *)weekString;
- (NSString *)weekMappingFrom:(NSInteger)weekDay;
- (NSInteger)daysWithMonthInThisYear:(NSInteger)year withMonth:(NSInteger)month;
@end
