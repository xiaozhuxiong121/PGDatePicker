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
- (BOOL)setDayListLogic:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
- (BOOL)setHourListLogic:(PGPickerView *)pickerView dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
- (BOOL)setHourListLogic2:(PGPickerView *)pickerView dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
- (BOOL)setMinuteListLogic:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
- (BOOL)setMinuteListLogic2:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
- (BOOL)setMinuteListLogic3:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
- (BOOL)setMinuteListLogic4:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
- (BOOL)setSecondListLogic:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
- (BOOL)setSecondListLogic2:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
- (BOOL)setSecondListLogic3:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
- (BOOL)setMonthListLogic:(NSDateComponents *)dateComponents refresh:(BOOL)refresh;
@end
