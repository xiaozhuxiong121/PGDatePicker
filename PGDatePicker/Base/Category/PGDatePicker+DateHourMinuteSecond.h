//
//  PGDatePicker+DateHourMinuteSecond.h
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (DateHourMinuteSecond)
- (void)dateHourMinuteSecond_setupSelectedDate;
- (void)dateHourMinuteSecond_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated;
- (void)dateHourMinuteSecond_didSelectWithComponent:(NSInteger)component;
@end
