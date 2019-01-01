//
//  PGDatePicker+Year.h
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (Year)
- (void)year_setupSelectedDate;
- (void)year_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated;
@end
