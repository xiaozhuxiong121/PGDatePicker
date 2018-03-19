//
//  NSBundle+PGDatePicker.h
//
//  Created by piggybear on 2017/11/4.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (PGDatePicker)
+ (NSString *)localizedStringForKey:(NSString *)key;
+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value;
@end
