//
//  PGPickerViewConfig.m
//  PGPickerView
//
//  Created by piggybear on 2017/7/27.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "PGPickerViewConfig.h"

@implementation PGPickerViewConfig
+ (instancetype)instance {
    static dispatch_once_t onceToken;
    static PGPickerViewConfig *config = nil;
    dispatch_once(&onceToken, ^{
        config = [[PGPickerViewConfig alloc]init];
    });
    return config;
}

@end
