//
//  PGDatePickManager.h
//
//  Created by piggybear on 2018/1/7.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGDatePicker.h"
#import "PGEnumeration.h"

@interface PGDatePickManager : UIViewController

@property (nonatomic, weak) PGDatePicker *datePicker;
@property (nonatomic, assign) PGDatePickManagerStyle style;
@property (nonatomic, assign) BOOL isShadeBackgroud;

@property (nonatomic, copy) NSString *cancelButtonText;
@property (nonatomic, copy) UIFont *cancelButtonFont;
@property (nonatomic, copy) UIColor *cancelButtonTextColor;

@property (nonatomic, copy) NSString *confirmButtonText;
@property (nonatomic, copy) UIFont *confirmButtonFont;
@property (nonatomic, copy) UIColor *confirmButtonTextColor;

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong)UIColor *headerViewBackgroundColor;
@property (nonatomic, assign) CGFloat headerHeight;
@end
