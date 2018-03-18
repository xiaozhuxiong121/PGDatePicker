//
//  PGDatePicker+YearAndMonth.m
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker+YearAndMonth.h"

@implementation PGDatePicker (YearAndMonth)
- (void)setupSelectedDate {
    NSString *yearString = [self.pickerView textOfSelectedRowInComponent:0];
    yearString = [yearString componentsSeparatedByString:self.yearString].firstObject;
    self.selectedComponents.year = [yearString integerValue];
}
@end
