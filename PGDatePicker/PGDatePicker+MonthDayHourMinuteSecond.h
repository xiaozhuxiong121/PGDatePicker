//
//  PGDatePicker+MonthDayHourMinuteSecond.h
//  Demo
//
//  Created by piggybear on 2018/4/9.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (MonthDayHourMinuteSecond)
- (void)monthDayHourMinuteSecond_setupSelectedDate;
- (void)monthDayHourMinuteSecond_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated;
- (void)monthDayHourMinuteSecond_didSelectWithComponent:(NSInteger)component;
@end
