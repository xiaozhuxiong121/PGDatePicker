//
//  PGDatePicker+MonthDay.h
//  Demo
//
//  Created by piggybear on 2018/4/9.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (MonthDay)
- (void)monthDay_setupSelectedDate;
- (void)monthDay_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated;
- (void)monthDay_didSelectWithComponent:(NSInteger)component;
@end
