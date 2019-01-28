//
//  PGEnumeration.h
//
//  Created by piggybear on 2018/1/7.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#ifndef PGEnumeration_h
#define PGEnumeration_h

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
};

typedef NS_ENUM(NSUInteger, PGDatePickerType) {
    PGDatePickerTypeLine,
    PGDatePickerTypeSegment,
    PGDatePickerTypeVertical,
};

typedef NS_ENUM(NSUInteger, PGShowUnitType) {
    PGShowUnitTypeAll,
    PGShowUnitTypeCenter,
    PGShowUnitTypeNone,
};

typedef NS_ENUM(NSUInteger, PGDatePickManagerStyle) {
    PGDatePickManagerStyleSheet,
    PGDatePickManagerStyleAlertTopButton,
    PGDatePickManagerStyleAlertBottomButton
};

#endif /* PGEnumeration_h */
