//
//  PGEnumeration.h
//
//  Created by piggybear on 2018/1/7.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#ifndef PGEnumeration_h
#define PGEnumeration_h

typedef NS_ENUM(NSUInteger, PGDatePickManagerStyle) {
    PGDatePickManagerStyleSheet,
    PGDatePickManagerStyleAlertTopButton,
    PGDatePickManagerStyleAlertBottomButton
};

typedef NS_ENUM(NSInteger, PGDatePickerMode) {
    PGDatePickerModeYear, //年
    PGDatePickerModeYearAndMonth, //年月
    PGDatePickerModeDate, //年月日
    PGDatePickerModeDateHour, //年月日时
    PGDatePickerModeDateHourMinute, //年月日时分
    PGDatePickerModeDateHourMinuteSecond, //年月日时分秒
    PGDatePickerModeMonthDay, //月日
    PGDatePickerModeMonthDayHour, //月日时
    PGDatePickerModeMonthDayHourMinute, //月日时分
    PGDatePickerModeMonthDayHourMinuteSecond, //月日时分秒
    PGDatePickerModeTime, //时分
    PGDatePickerModeTimeAndSecond, //时分秒
    PGDatePickerModeMinuteAndSecond, //分秒
    PGDatePickerModeDateAndTime, //月日周 时分
    PGDatePickerModeText // 文本
};


/**
 <#Description#>
 
 - PGDatePickerSeparateline: <#PGDatePickerSeparateline description#>
 - PGDatePickerSeparatelineSegment: <#PGDatePickerSeparatelineSegment description#>
 - PGDatePickerSeparatelineVertical: <#PGDatePickerSeparatelineVertical description#>
 */
typedef NS_ENUM(NSUInteger, PGDatePickerSeparate) {
    PGDatePickerSeparateline,
    PGDatePickerSeparatelineSegment,
    PGDatePickerSeparatelineVertical,
};

typedef NS_ENUM(NSUInteger, PGShowUnitType) {
    PGShowUnitTypeAll,
    PGShowUnitTypeCenter,
    PGShowUnitTypeNone,
};


//MARK: <#注释说明#>

static const NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;

#endif /* PGEnumeration_h */
