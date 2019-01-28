//
//  NSDate+PGCategory.m
//
//  Created by piggybear on 2017/8/1.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "NSDate+PGCategory.h"

@implementation NSDate (PGCategory)

+ (NSDate *)dateFromComponents:(NSDateComponents*)dateComponents {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate * date = [calendar dateFromComponents:dateComponents];
    return date;
}

@end
