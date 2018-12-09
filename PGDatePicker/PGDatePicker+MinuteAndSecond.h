//
//  PGDatePicker+MinuteAndSecond.h
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (MinuteAndSecond)
- (void)minuteAndSecond_setupSelectedDate;
- (void)minuteAndSecond_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated;
- (void)minuteAndSecond_didSelectWithComponent:(NSInteger)component;
@end
