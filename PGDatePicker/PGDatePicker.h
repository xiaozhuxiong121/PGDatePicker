//
//  PGDatePicker.h
//
//  Created by piggybear on 2017/7/25.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+PGCategory.h"
#import "UIColor+PGHex.h"
#import <PGPickerView/PGPickerView.h>
#import "PGEnumeration.h"

#define PGDatePickerDeprecated(instead) __attribute__((deprecated(instead)))

@protocol PGDatePickerDelegate;

@interface PGDatePicker : UIControl
@property (nonatomic, weak) id<PGDatePickerDelegate> delegate;
@property (nonatomic, assign) PGDatePickerMode datePickerMode; // default is PGDatePickerModeYear
@property(nonatomic, assign) PGDatePickerType datePickerType;
/*
 默认是false
 如果设置为true，则不用按下确定按钮也可以得到选中的日期
 每次滑动都会自动执行PGDatePickerDelegate代理方法，得到选中的日期
 */
@property(nonatomic, assign) BOOL autoSelected;
/*
 默认是false
 如果设置为true，只会显示中间的文字，其他行的文字则不会显示
 */
@property(nonatomic, assign) BOOL middleText PGDatePickerDeprecated("已过时，请使用isHiddenMiddleText进行替换");

/**
 设置行高
 */
@property (nonatomic, assign) CGFloat rowHeight; //default is 50

/*
 默认是true
 如果设置为false，只会显示中间的文字，其他行的文字则不会显示
 */
@property(nonatomic, assign) BOOL isHiddenMiddleText; // default is true

@property(nonatomic, assign) PGShowUnitType showUnit;
@property(nonatomic, copy) UIColor *middleTextColor;

@property (nonatomic, strong)UIColor *titleColorForSelectedRow PGDatePickerDeprecated("已过时，请使用textColorOfSelectedRow进行替换");
@property (nonatomic, strong)UIColor *titleColorForOtherRow PGDatePickerDeprecated("已过时，请使用textColorOfOtherRow进行替换");

@property (nonatomic, strong)UIColor *textColorOfSelectedRow;     //default is #69BDFF
@property(nonatomic, strong) UIFont *textFontOfSelectedRow;       //default is 17

@property (nonatomic, strong)UIColor *textColorOfOtherRow;        // default is [UIColor lightGrayColor]
@property(nonatomic, strong) UIFont *textFontOfOtherRow;          //default is 17

@property(nonatomic, strong) UIColor *lineBackgroundColor;       //default is #69BDFF

@property (nonatomic, strong) NSLocale   *locale;   // default is [NSLocale currentLocale]. setting nil returns to default
@property (nonatomic, copy)   NSCalendar *calendar; // default is [NSCalendar currentCalendar]. setting nil returns to default
@property (nonatomic, strong) NSTimeZone *timeZone; // default is nil. use current time zone or time zone from calendar

@property (nonatomic, strong) NSDate *minimumDate; // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
@property (nonatomic, strong) NSDate *maximumDate; // default is nil

@property (nonatomic, copy) void(^selectedDate)(NSDateComponents *dateComponents);

@property(nonatomic, assign) BOOL isHiddenWheels; // default is true  true -> hidden
@property(nonatomic, assign) BOOL isCycleScroll; //default is false
/*
 简体中文  language = zh-Hans
 繁体中文  language = zh-Hant
 英语     language = en
 */
@property(nonatomic, copy) NSString *language;
/**
 相当于确定按钮，执行此方法PGDatePickerDelegate代理方法会得到值
 */
- (void)tapSelectedHandler;

- (void)setDate:(NSDate *)date;
- (void)setDate:(NSDate *)date animated:(BOOL)animated;

//在时分的时候，只显示时
@property (nonatomic) BOOL isOnlyHourFlag;

//分间隔 默认时1
@property (nonatomic) NSInteger minuteInterval;

//秒间隔 默认时1
@property (nonatomic) NSInteger secondInterval;

@end

@protocol PGDatePickerDelegate <NSObject>

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents;
@end

