//
//  PGDatePicker+MonthDayHourMinute.h
//  Demo
//
//  Created by piggybear on 2018/4/9.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (MonthDayHourMinute)
- (void)monthDayHourMinute_setupSelectedDate;
- (void)monthDayHourMinute_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated;
- (void)monthDayHourMinute_didSelectWithComponent:(NSInteger)component;
@end
