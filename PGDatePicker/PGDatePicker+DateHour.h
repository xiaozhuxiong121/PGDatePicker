//
//  PGDatePicker+DateHour.h
//  Demo
//
//  Created by winter on 2018/3/23.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (DateHour)
- (void)dateHour_setupSelectedDate;
- (void)dateHour_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated;
- (void)dateHour_didSelectWithComponent:(NSInteger)component;
@end
