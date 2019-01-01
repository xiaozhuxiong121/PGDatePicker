//
//  NSBundle+PGDatePicker.h
//
//  Created by piggybear on 2017/11/4.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (PGDatePicker)
+ (NSString *)pg_localizedStringForKey:(NSString *)key;
+ (NSString *)pg_localizedStringForKey:(NSString *)key language:(NSString *)language;
+ (NSString *)pg_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)pg_localizedStringForKey:(NSString *)key value:(NSString *)value language:(NSString *)language;
@end
