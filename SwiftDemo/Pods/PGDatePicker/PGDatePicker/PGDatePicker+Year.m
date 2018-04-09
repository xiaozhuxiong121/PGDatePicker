//
//  PGDatePicker+Year.m
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker+Year.h"
#import "PGDatePickerHeader.h"

@implementation PGDatePicker (Year)
- (void)year_setupSelectedDate {
    NSString *yearString = [self.pickerView textOfSelectedRowInComponent:0];
    yearString = [yearString componentsSeparatedByString:self.yearString].firstObject;
    self.selectedComponents.year = [yearString integerValue];
}

- (void)year_setDateWithComponents:(NSDateComponents *)components animated:(BOOL)animated {
    if (components.year > self.maximumComponents.year) {
        components.year = self.maximumComponents.year;
    }else if (components.year < self.minimumComponents.year) {
        components.year = self.minimumComponents.year;
    }
    NSInteger row = components.year - self.minimumComponents.year;
    [self.pickerView selectRow:row inComponent:0 animated:animated];
}
@end
