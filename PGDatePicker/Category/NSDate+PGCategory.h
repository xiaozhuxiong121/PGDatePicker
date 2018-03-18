//
//  NSDate+PGCategory.h
//
//  Created by piggybear on 2017/8/1.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PGCategory)
+ (NSDate *)setYear:(NSInteger)year;
+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month;
+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDate *)setHour:(NSInteger)hour minute:(NSInteger)minute;
+ (NSDate *)setMinute:(NSInteger)minute second:(NSInteger)second;
+ (NSDate *)setHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDate *)setMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
- (NSInteger)howManyDaysWithMonth;
@end
