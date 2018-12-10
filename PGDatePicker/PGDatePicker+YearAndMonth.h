//
//  PGDatePicker+YearAndMonth.h
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (YearAndMonth)
- (void)yearAndMonth_setupSelectedDate;
- (void)yearAndMonth_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated;
- (void)yearAndMonth_didSelectWithComponent:(NSInteger)component;
@end
