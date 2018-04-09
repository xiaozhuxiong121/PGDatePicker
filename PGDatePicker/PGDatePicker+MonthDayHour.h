//
//  PGDatePicker+MonthDayHour.h
//  Demo
//
//  Created by piggybear on 2018/4/9.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (MonthDayHour)
- (void)monthDayHour_setupSelectedDate;
- (void)monthDayHour_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated;
- (void)monthDayHour_didSelectWithComponent:(NSInteger)component;
@end
