//
//  NSDate+PGCategory.h
//  HooDatePickerDemo
//
//  Created by piggybear on 2017/8/1.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PGCategory)
+ (NSDate *)setYear:(NSUInteger)year;
+ (NSDate *)setYear:(NSUInteger)year month:(NSUInteger)month;
+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)setMonth:(NSUInteger)month day:(NSUInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
+ (NSDate *)setHour:(NSInteger)hour minute:(NSInteger)minute;
- (NSUInteger)howManyDaysWithMonth;
@end
