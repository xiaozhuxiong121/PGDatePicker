//
//  PGDatePicker+TimeAndSecond.h
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (TimeAndSecond)
- (void)timeAndSecond_setupSelectedDate;
- (void)timeAndSecond_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated;
- (void)timeAndSecond_didSelectWithComponent:(NSInteger)component;
@end
