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
@property (nonatomic, assign) BOOL isShadeBackground;

@property (nonatomic, copy) NSString *cancelButtonText;
@property (nonatomic, copy) UIFont *cancelButtonFont;
@property (nonatomic, copy) UIColor *cancelButtonTextColor;

/**
 set confirmButton title ,default is Sure
 */
@property (nonatomic, copy) NSString *confirmButtonText;

@property (nonatomic, copy) UIFont *confirmButtonFont;
/**
 set confirButton titleColor ,default is
 */
@property (nonatomic, copy) UIColor *confirmButtonTextColor;

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong)UIColor *headerViewBackgroundColor;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) BOOL isShowUnit;
@property (nonatomic, copy)  void(^cancelButtonMonitor)();

/**
 custom dismiss controller animation, return the total duration of the custom animation, default is nil
 */
@property (nonatomic, copy) NSTimeInterval(^customDismissAnimation)(UIView* dismissView, UIView* contentView );

@end
