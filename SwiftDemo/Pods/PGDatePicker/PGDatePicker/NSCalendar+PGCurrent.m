//
//  NSCalendar+PGCurrent.m
//  HooDatePickerDemo
//
//  Created by piggybear on 2017/7/25.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "NSCalendar+PGCurrent.h"
#import <objc/runtime.h>

@implementation NSCalendar (PGCurrent)
static const char currentComponentsKey = '\0';
- (void)setCurrentComponents:(NSDateComponents *)currentComponents {
    objc_setAssociatedObject(self, &currentComponentsKey, currentComponents,  OBJC_ASSOCIATION_ASSIGN);
}

- (NSDateComponents *)currentComponents {
    NSDateComponents *components = objc_getAssociatedObject(self, &currentComponentsKey);
    if (components == nil) {
        NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
        [self setCurrentComponents:[self components:unitFlags fromDate:[NSDate date]]];
    }
    return objc_getAssociatedObject(self, &currentComponentsKey);
}
@end
