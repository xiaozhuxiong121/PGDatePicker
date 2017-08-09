//
//  PGPickerViewConfig.h
//  PGPickerView
//
//  Created by piggybear on 2017/7/27.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PGPickerViewConfig : NSObject
+ (instancetype)instance;
@property (nonatomic, assign) CGFloat tableViewHeightForRow;
@end
