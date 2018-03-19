//
//  PGDatePicker+Time.h
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (Time)
- (void)time_setupSelectedDate;
- (void)time_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated;
- (void)time_didSelectWithComponent:(NSInteger)component;
@end
