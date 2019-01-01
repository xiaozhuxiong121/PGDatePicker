//
//  PGDatePicker+DateHourMinute.h
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (DateHourMinute)
- (void)dateHourMinute_setupSelectedDate;
- (void)dateHourMinute_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated;
- (void)dateHourMinute_didSelectWithComponent:(NSInteger)component;
@end
