//
//  PGDatePicker+Logic.h
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"

@interface PGDatePicker (Logic)
- (void)setDayListForMonthDays:(NSInteger)day;
/*
    1、年月日时分 (PGDatePickerModeDateHourMinute)
    2、年月日时分秒 (PGDatePickerModeDateHourMinuteSecond)
    3、年月日 (PGDatePickerModeDate)
 */
- (BOOL)setDayListWithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;

/*
 PGDatePickerModeMonthDay, //月日
 PGDatePickerModeMonthDayHour, //月日时
 PGDatePickerModeMonthDayHourMinute, //月日时分
 PGDatePickerModeMonthDayHourMinuteSecond, //月日时分秒
 */
- (BOOL)setDayList2WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
/*
    PGDatePickerModeDateAndTime, //月日周 时分
 */
- (BOOL)setHourListWithDateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
/*
    1、PGDatePickerModeDateHourMinuteSecond, //年月日时分秒
    2、PGDatePickerModeDateHourMinute, //年月日时分
 */
- (BOOL)setHourList2WithDateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;

/*
 PGDatePickerModeMonthDayHour, //月日时
 PGDatePickerModeMonthDayHourMinute, //月日时分
 PGDatePickerModeMonthDayHourMinuteSecond, //月日时分秒
 */
- (BOOL)setHourList3WithDateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
/*
    PGDatePickerModeTime, //时分
 */
- (BOOL)setMinuteListWithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
/*
    1、PGDatePickerModeDateHourMinuteSecond, //年月日时分秒
    2、PGDatePickerModeDateHourMinute, //年月日时分
 */
- (BOOL)setMinuteList2WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
/*
    PGDatePickerModeTimeAndSecond, //时分秒
 */
- (BOOL)setMinuteList3WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
/*
 PGDatePickerModeTimeAndSecond, //时分秒
 */
- (BOOL)setMinuteList4WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
/*
 PGDatePickerModeMonthDayHourMinute, //月日时分
 PGDatePickerModeMonthDayHourMinuteSecond, //月日时分秒
 */
- (BOOL)setMinuteList5WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
/*
    PGDatePickerModeTimeAndSecond, //时分秒
 */
- (BOOL)setSecondListWithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
/*
    PGDatePickerModeDateHourMinuteSecond, //年月日时分秒
 */
- (BOOL)setSecondList2WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
/*
    PGDatePickerModeMinuteAndSecond, //分秒
 */
- (BOOL)setSecondList3WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
/*
    PGDatePickerModeMonthDayHourMinuteSecond, //月日时分秒
 */
- (BOOL)setSecondList4WithComponent:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
/*
     PGDatePickerModeYearAndMonth, //年月
     PGDatePickerModeDate, //年月日
     PGDatePickerModeDateHourMinute, //年月日时分
     PGDatePickerModeDateHourMinuteSecond, //年月日时分秒
 */
- (BOOL)setMonthListWithComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
@end
