//
//  PGDatePicker+DateAndTime.h
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (DateAndTime)
- (void)dateAndTime_setupSelectedDate;
- (void)dateAndTime_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated;
- (void)dateAndTime_didSelectWithComponent:(NSInteger)component;
@end
