//
//  PGDatePicker.m
//
//  Created by piggybear on 2017/7/25.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"
#import "PGDatePickerView.h"
#import "NSBundle+PGDatePicker.h"
#import "PGDatePickerHeader.h"
#import "PGDatePicker+Year.h"
#import "PGDatePicker+YearAndMonth.h"
#import "PGDatePicker+Date.h"
#import "PGDatePicker+DateHour.h"
#import "PGDatePicker+DateHourMinute.h"
#import "PGDatePicker+DateHourMinuteSecond.h"
#import "PGDatePicker+Time.h"
#import "PGDatePicker+TimeAndSecond.h"
#import "PGDatePicker+MinuteAndSecond.h"
#import "PGDatePicker+DateAndTime.h"
#import "PGDatePicker+Common.h"
#import "PGDatePicker+Logic.h"
#import "PGDatePicker+MonthDay.h"
#import "PGDatePicker+MonthDayHour.h"
#import "PGDatePicker+MonthDayHourMinute.h"
#import "PGDatePicker+MonthDayHourMinuteSecond.h"

static NSString *const reuseIdentifier = @"PGDatePickerView";

@implementation PGDatePicker

- (instancetype)init {
    if (self = [super init]) {
        self.isHiddenMiddleText = true;
        self.isHiddenWheels = true;
        
        self.secondInterval = 1;
        self.minuteInterval = 1;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.isHiddenMiddleText = true;
        self.isHiddenWheels = true;
        
        self.secondInterval = 1;
        self.minuteInterval = 1;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_isSelectedCancelButton) {
        return;
    }
    if (_isSubViewLayout) {
        return;
    }
    self.selectedComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    _isSubViewLayout = true;
    [self setupPickerView];
}

- (void)setupPickerView {
    if (_setDate) {
        self.selectComponents = [self.calendar components:self.unitFlags fromDate:_setDate];
    }else {
        self.selectComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    }
    NSInteger day = [self daysWithMonthInThisYear:self.selectComponents.year withMonth:self.selectComponents.month];
    [self setDayListForMonthDays:day];
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = self.safeAreaInsets.bottom;
    }
    CGRect frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - bottom);
    PGPickerView *pickerView = [[PGPickerView alloc]initWithFrame:frame];
    if (_middleText) {
        self.isHiddenMiddleText = !_middleText;
    }
    pickerView.rowHeight = self.rowHeight;
    pickerView.isHiddenMiddleText = self.isHiddenMiddleText;
    pickerView.middleTextColor = self.middleTextColor;
    pickerView.isHiddenWheels = self.isHiddenWheels;
    pickerView.isCycleScroll = self.isCycleScroll;
    pickerView.lineBackgroundColor = self.lineBackgroundColor;
    if (_titleColorForOtherRow) {
        self.textColorOfOtherRow = _titleColorForOtherRow;
    }
    if (_titleColorForSelectedRow) {
        self.textColorOfSelectedRow = _titleColorForSelectedRow;
    }
    pickerView.textColorOfSelectedRow = self.textColorOfSelectedRow;
    pickerView.textFontOfSelectedRow = self.textFontOfSelectedRow;
    pickerView.textColorOfOtherRow = self.textColorOfOtherRow;
    pickerView.textFontOfOtherRow = self.textFontOfOtherRow;
    pickerView.type = (PGPickerViewLineType)self.datePickerType;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self addSubview:pickerView];
    self.pickerView = pickerView;
    if (_setDate) {
        [self setDate:_setDate animated:_isSetDateAnimation];
    }else {
        _setDate = [NSDate date];
        [self setDate:_setDate animated:false];
    }
}

- (void)tapSelectedHandler {
    if (self.autoSelected == false) {
        [self selectedDateLogic];
    }
}

- (void)selectedDateLogic {
    switch (self.datePickerMode) {
        case PGDatePickerModeYear:
        {
            [self year_setupSelectedDate];
        }
            break;
        case PGDatePickerModeYearAndMonth:
        {
            [self yearAndMonth_setupSelectedDate];
        }
            break;
        case PGDatePickerModeDate:
        {
            [self date_setupSelectedDate];
        }
            break;
        case PGDatePickerModeDateHour:
        {
            [self dateHour_setupSelectedDate];
        }
            break;
        case PGDatePickerModeDateHourMinute:
        {
            [self dateHourMinute_setupSelectedDate];
        }
            break;
        case PGDatePickerModeDateHourMinuteSecond:
        {
            [self dateHourMinuteSecond_setupSelectedDate];
        }
            break;
        case PGDatePickerModeMonthDay:
        {
            [self monthDay_setupSelectedDate];
        }
            break;
        case PGDatePickerModeMonthDayHour:
        {
            [self monthDayHour_setupSelectedDate];
        }
            break;
        case PGDatePickerModeMonthDayHourMinute:
        {
            [self monthDayHourMinute_setupSelectedDate];
        }
            break;
        case PGDatePickerModeMonthDayHourMinuteSecond:
        {
            [self monthDayHourMinuteSecond_setupSelectedDate];
        }
            break;
        case PGDatePickerModeTime:
        {
            [self time_setupSelectedDate];
        }
            break;
        case PGDatePickerModeTimeAndSecond:
        {
            [self timeAndSecond_setupSelectedDate];
        }
            break;
        case PGDatePickerModeMinuteAndSecond:
        {
            [self minuteAndSecond_setupSelectedDate];
        }
            break;
        case PGDatePickerModeDateAndTime:
        {
            [self dateAndTime_setupSelectedDate];
        }
            break;
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePicker:didSelectDate:)]) {
        [self.delegate datePicker:self didSelectDate:self.selectedComponents];
    }
    if (self.selectedDate) {
        self.selectedDate(self.selectedComponents);
    }
}

- (NSInteger)rowsInComponent:(NSInteger)component {
    switch (self.datePickerMode) {
        case PGDatePickerModeYear:
            return self.yearList.count;
        case PGDatePickerModeYearAndMonth:
        {
            if (component == 1) {
                return self.monthList.count;
            }
            return self.yearList.count;
        }
        case PGDatePickerModeDate:
        {
            if (component == 1) {
                return self.monthList.count;
            }
            if (component == 2) {
                return self.dayList.count;
            }
            return self.yearList.count;
        }
        case PGDatePickerModeDateHour:
        {
            if (component == 0) {
                return self.yearList.count;
            }
            if (component == 1) {
                return self.monthList.count;
            }
            if (component == 2) {
                return self.dayList.count;
            }
            if (component == 3) {
                return self.hourList.count;
            }
        }
        case PGDatePickerModeDateHourMinute:
        {
            if (component == 0) {
                return self.yearList.count;
            }
            if (component == 1) {
                return self.monthList.count;
            }
            if (component == 2) {
                return self.dayList.count;
            }
            if (component == 3) {
                return self.hourList.count;
            }
            if (component == 4) {
                return self.minuteList.count;
            }
        }
        case PGDatePickerModeDateHourMinuteSecond:
        {
            if (component == 0) {
                return self.yearList.count;
            }
            if (component == 1) {
                return self.monthList.count;
            }
            if (component == 2) {
                return self.dayList.count;
            }
            if (component == 3) {
                return self.hourList.count;
            }
            if (component == 4) {
                return self.minuteList.count;
            }
            if (component == 5) {
                return self.secondList.count;
            }
        }
        case PGDatePickerModeMonthDay:
        {
            if (component == 1) {
                return self.dayList.count;
            }
            return self.monthList.count;
        }
        case PGDatePickerModeMonthDayHour:
        {
            if (component == 0) {
                return self.monthList.count;
            }
            if (component == 1) {
                return self.dayList.count;
            }
            if (component == 2) {
                return self.hourList.count;
            }
        }
        case PGDatePickerModeMonthDayHourMinute:
        {
            if (component == 0) {
                return self.monthList.count;
            }
            if (component == 1) {
                return self.dayList.count;
            }
            if (component == 2) {
                return self.hourList.count;
            }
            if (component == 3) {
                return self.minuteList.count;
            }
        }
        case PGDatePickerModeMonthDayHourMinuteSecond:
        {
            if (component == 0) {
                return self.monthList.count;
            }
            if (component == 1) {
                return self.dayList.count;
            }
            if (component == 2) {
                return self.hourList.count;
            }
            if (component == 3) {
                return self.minuteList.count;
            }
            if (component == 4) {
                return self.secondList.count;
            }
        }
        case PGDatePickerModeTime:
        {
            if (component == 1) {
                return self.minuteList.count;
            }
            return self.hourList.count;
        }
        case PGDatePickerModeTimeAndSecond:
        {
            if (component == 0) {
                return self.hourList.count;
            }
            if (component == 1) {
                return self.minuteList.count;
            }
            if (component == 2) {
                return self.secondList.count;
            }
        }
        case PGDatePickerModeMinuteAndSecond:
        {
            if (component == 0) {
                return self.minuteList.count;
            }
            if (component == 1) {
                return self.secondList.count;
            }
        }
        case PGDatePickerModeDateAndTime:
        {
            if (component == 1) {
                return self.hourList.count;
            }
            if (component == 2) {
                return self.minuteList.count;
            }
            return self.dateAndTimeList.count;
        }
            
        default:
            break;
    }
    return 0;
}

- (void)setDate:(NSDate *)date {
    [self setDate:date animated:false];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    _isSetDateAnimation = animated;
    _setDate = date;
    if (!_isSubViewLayout) {
        return;
    }
    NSDateComponents *components = [self.calendar components:self.unitFlags fromDate:_setDate];
    if (self.minimumDate == nil && animated && !_isSetDate) {
        NSInteger year = components.year - 10;
        if (year <= self.minimumComponents.year) {
            year = self.minimumComponents.year;
        }else {
            components.year = year;
        }
        components.month = 1;
        components.day = 1;
        components.hour = 0;
        components.minute = 0;
        components.second = 0;
        _isSetDate = true;
        animated = false;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self setDate:_setDate animated:_isSetDateAnimation];
        });
    }
    switch (self.datePickerMode) {
        case PGDatePickerModeYear:
        {
            [self year_setDateWithComponents:components animated:animated];
        }
            break;
        case PGDatePickerModeYearAndMonth:
        {
            [self yearAndMonth_setDateWithComponents:components animated:animated];
        }
            break;
        case PGDatePickerModeDate:
        {
            [self date_setDateWithComponents:components animated:animated];
        }
            break;
        case PGDatePickerModeDateHour:
        {
            [self dateHour_setDateWithComponents:components animated:animated];
        }
            break;
        case PGDatePickerModeDateHourMinute:
        {
            [self dateHourMinute_setDateWithComponents:components animated:animated];
        }
            break;
        case PGDatePickerModeDateHourMinuteSecond:
        {
            [self dateHourMinuteSecond_setDateWithComponents:components animated:animated];
        }
            break;
        case PGDatePickerModeMonthDay:
        {
            [self monthDay_setDateWithComponents:components animated:animated];
        }
            break;
        case PGDatePickerModeMonthDayHour:
        {
            [self monthDayHour_setDateWithComponents:components animated:animated];
        }
            break;
        case PGDatePickerModeMonthDayHourMinute:
        {
            [self monthDayHourMinute_setDateWithComponents:components animated:animated];
        }
            break;
        case PGDatePickerModeMonthDayHourMinuteSecond:
        {
            [self monthDayHourMinuteSecond_setDateWithComponents:components animated:animated];
        }
            break;
        case PGDatePickerModeTime:
        {
            [self time_setDateWithComponents:components animated:animated];
        }
            break;
        case PGDatePickerModeTimeAndSecond:
        {
            [self timeAndSecond_setDateWithComponents:components animated:animated];
        }
            break;
        case PGDatePickerModeMinuteAndSecond:
        {
            [self minuteAndSecond_setDateWithComponents:components animated:animated];
        }
            break;
            
        case PGDatePickerModeDateAndTime:
        {
            [self dateAndTime_setDateWithComponents:components animated:animated];
        }
            break;
        default:
            break;
    }
}

#pragma mark - PGPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(PGPickerView *)pickerView {
    return self.components;
}

- (NSInteger)pickerView:(PGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self rowsInComponent:component];
}

- (void)pickerView:(PGPickerView *)pickerView title:(NSString *)title didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    row = row + 1;
    switch (self.datePickerMode) {
        case PGDatePickerModeYearAndMonth:
        {
            [self yearAndMonth_didSelectWithComponent:component];
        }
            break;
        case PGDatePickerModeDate:
        {
            [self date_didSelectWithComponent:component];
        }
            break;
        case PGDatePickerModeDateHour:
        {
            [self dateHour_didSelectWithComponent:component];
        }
            break;
        case PGDatePickerModeDateHourMinute:
        {
            [self dateHourMinute_didSelectWithComponent:component];
        }
            break;
        case PGDatePickerModeDateHourMinuteSecond:
        {
            [self dateHourMinuteSecond_didSelectWithComponent:component];
        }
            break;
        case PGDatePickerModeMonthDay:
        {
            [self monthDay_didSelectWithComponent:component];
        }
            break;
        case PGDatePickerModeMonthDayHour:
        {
            [self monthDayHour_didSelectWithComponent:component];
        }
            break;
        case PGDatePickerModeMonthDayHourMinute:
        {
            [self monthDayHourMinute_didSelectWithComponent:component];
        }
            break;
        case PGDatePickerModeMonthDayHourMinuteSecond:
        {
            [self monthDayHourMinuteSecond_didSelectWithComponent:component];
        }
            break;
        case PGDatePickerModeTime:
        {
            [self time_didSelectWithComponent:component];
        }
            break;
        case PGDatePickerModeTimeAndSecond:
        {
            [self timeAndSecond_didSelectWithComponent:component];
        }
            break;
        case PGDatePickerModeMinuteAndSecond:
        {
            [self minuteAndSecond_didSelectWithComponent:component];
        }
            break;
        case PGDatePickerModeDateAndTime:
        {
            [self dateAndTime_didSelectWithComponent:component];
        }
            break;
        default:
            break;
    }
    if (self.autoSelected) {
        [self selectedDateLogic];
    }
}

- (NSString *)pickerView:(PGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (self.datePickerMode) {
        case PGDatePickerModeYear:
            return [self.yearList[row] stringByAppendingString:self.yearString];
        case PGDatePickerModeYearAndMonth:
        {
            if (component == 1) {
                return [self.monthList[row] stringByAppendingString:self.monthString];
            }
            return [self.yearList[row] stringByAppendingString:self.yearString];
        }
        case PGDatePickerModeDate:
        {
            if (component == 1) {
                return [self.monthList[row] stringByAppendingString:self.monthString];
            }
            if (component == 2) {
                return [self.dayList[row] stringByAppendingString:self.dayString];
            }
            return [self.yearList[row] stringByAppendingString:self.yearString];
        }
        case PGDatePickerModeDateHour:
        {
            if (component == 0) {
                return [self.yearList[row] stringByAppendingString:self.yearString];
            }
            if (component == 1) {
                return [self.monthList[row] stringByAppendingString:self.monthString];
            }
            if (component == 2) {
                return [self.dayList[row] stringByAppendingString:self.dayString];
            }
            if (component == 3) {
                return [self.hourList[row] stringByAppendingString:self.hourString];
            }
        }
        case PGDatePickerModeDateHourMinute:
        {
            if (component == 0) {
                return [self.yearList[row] stringByAppendingString:self.yearString];
            }
            if (component == 1) {
                return [self.monthList[row] stringByAppendingString:self.monthString];
            }
            if (component == 2) {
                return [self.dayList[row] stringByAppendingString:self.dayString];
            }
            if (component == 3) {
                return [self.hourList[row] stringByAppendingString:self.hourString];
            }
            if (component == 4) {
                return [self.minuteList[row] stringByAppendingString:self.minuteString];
            }
        }
        case PGDatePickerModeDateHourMinuteSecond:
        {
            if (component == 0) {
                return [self.yearList[row] stringByAppendingString:self.yearString];
            }
            if (component == 1) {
                return [self.monthList[row] stringByAppendingString:self.monthString];
            }
            if (component == 2) {
                return [self.dayList[row] stringByAppendingString:self.dayString];
            }
            if (component == 3) {
                return [self.hourList[row] stringByAppendingString:self.hourString];
            }
            if (component == 4) {
                return [self.minuteList[row] stringByAppendingString:self.minuteString];
            }
            if (component == 5) {
                return [self.secondList[row] stringByAppendingString:self.secondString];
            }
        }
        case PGDatePickerModeMonthDay:
        {
            if (component == 0) {
                return [self.monthList[row] stringByAppendingString:self.monthString];
            }
            return [self.dayList[row] stringByAppendingString:self.dayString];
        }
        case PGDatePickerModeMonthDayHour:
        {
            if (component == 0) {
                return [self.monthList[row] stringByAppendingString:self.monthString];
            }
            if (component == 1) {
                return [self.dayList[row] stringByAppendingString:self.dayString];
            }
            if (component == 2) {
                return [self.hourList[row] stringByAppendingString:self.hourString];
            }
        }
        case PGDatePickerModeMonthDayHourMinute:
        {
            if (component == 0) {
                return [self.monthList[row] stringByAppendingString:self.monthString];
            }
            if (component == 1) {
                return [self.dayList[row] stringByAppendingString:self.dayString];
            }
            if (component == 2) {
                return [self.hourList[row] stringByAppendingString:self.hourString];
            }
            if (component == 3) {
                return [self.minuteList[row] stringByAppendingString:self.minuteString];
            }
        }
        case PGDatePickerModeMonthDayHourMinuteSecond:
        {
            if (component == 0) {
                return [self.monthList[row] stringByAppendingString:self.monthString];
            }
            if (component == 1) {
                return [self.dayList[row] stringByAppendingString:self.dayString];
            }
            if (component == 2) {
                return [self.hourList[row] stringByAppendingString:self.hourString];
            }
            if (component == 3) {
                return [self.minuteList[row] stringByAppendingString:self.minuteString];
            }
            if (component == 4) {
                return [self.secondList[row] stringByAppendingString:self.secondString];
            }
        }
        case PGDatePickerModeTime:
        {
            if (component == 1) {
                return [self.minuteList[row] stringByAppendingString:self.minuteString];
            }
            return [self.hourList[row] stringByAppendingString:self.hourString];
        }
        case PGDatePickerModeTimeAndSecond:
        {
            if (component == 0) {
                return [self.hourList[row] stringByAppendingString:self.hourString];
            }
            if (component == 1) {
                return [self.minuteList[row] stringByAppendingString:self.minuteString];
            }
            if (component == 2) {
                return [self.secondList[row] stringByAppendingString:self.secondString];
            }
        }
        case PGDatePickerModeMinuteAndSecond:
        {
            if (component == 0) {
                return [self.minuteList[row] stringByAppendingString:self.minuteString];
            }
            if (component == 1) {
                return [self.secondList[row] stringByAppendingString:self.secondString];
            }
        }
        case PGDatePickerModeDateAndTime:
        {
            if (component == 1) {
                return [self.hourList[row] stringByAppendingString:self.hourString];
            }
            if (component == 2) {
                return [self.minuteList[row] stringByAppendingString:self.minuteString];
            }
            return self.dateAndTimeList[row];
        }
        default:
            break;
    }
    return @"";
}

- (NSString *)pickerView:(PGPickerView *)pickerView middleTextForcomponent:(NSInteger)component {
    if (_showUnit == PGShowUnitTypeNone) {
        return @"";
    }
    switch (self.datePickerMode) {
        case PGDatePickerModeYear:
            return self.middleYearString;
        case PGDatePickerModeYearAndMonth:
        {
            if (component == 1) {
                return self.middleMonthString;
            }
            return self.middleYearString;
        }
        case PGDatePickerModeDate:
        {
            if (component == 1) {
                return self.middleMonthString;
            }
            if (component == 2) {
                return self.middleDayString;
            }
            return self.middleYearString;
        }
        case PGDatePickerModeDateHour:
        {
            if (component == 0) {
                return self.middleYearString;
            }
            if (component == 1) {
                return self.middleMonthString;
            }
            if (component == 2) {
                return self.middleDayString;
            }
            if (component == 3) {
                return self.middleHourString;
            }
        }
        case PGDatePickerModeDateHourMinute:
        {
            if (component == 0) {
                return self.middleYearString;
            }
            if (component == 1) {
                return self.middleMonthString;
            }
            if (component == 2) {
                return self.middleDayString;
            }
            if (component == 3) {
                return self.middleHourString;
            }
            if (component == 4) {
                return self.middleMinuteString;
            }
        }
        case PGDatePickerModeDateHourMinuteSecond:
        {
            if (component == 0) {
                return self.middleYearString;
            }
            if (component == 1) {
                return self.middleMonthString;
            }
            if (component == 2) {
                return self.middleDayString;
            }
            if (component == 3) {
                return self.middleHourString;
            }
            if (component == 4) {
                return self.middleMinuteString;
            }
            if (component == 5) {
                return self.middleSecondString;
            }
        }
        case PGDatePickerModeMonthDay:
        {
            if (component == 0) {
                return self.middleMonthString;
            }
            return self.middleDayString;
        }
        case PGDatePickerModeMonthDayHour:
        {
            if (component == 0) {
                return self.middleMonthString;
            }
            if (component == 1) {
                return self.middleDayString;
            }
            if (component == 2) {
                return self.middleHourString;
            }
        }
        case PGDatePickerModeMonthDayHourMinute:
        {
            if (component == 0) {
                return self.middleMonthString;
            }
            if (component == 1) {
                return self.middleDayString;
            }
            if (component == 2) {
                return self.middleHourString;
            }
            if (component == 3) {
                return self.middleMinuteString;
            }
        }
        case PGDatePickerModeMonthDayHourMinuteSecond:
        {
            if (component == 0) {
                return self.middleMonthString;
            }
            if (component == 1) {
                return self.middleDayString;
            }
            if (component == 2) {
                return self.middleHourString;
            }
            if (component == 3) {
                return self.middleMinuteString;
            }
            if (component == 4) {
                return self.middleSecondString;
            }
        }
        case PGDatePickerModeTime:
        {
            if (component == 1) {
                return self.middleMinuteString;
            }
            return self.middleHourString;
        }
        case PGDatePickerModeTimeAndSecond:
        {
            if (component == 0) {
                return self.middleHourString;
            }
            if (component == 1) {
                return self.middleMinuteString;
            }
            if (component == 2) {
                return self.middleSecondString;
            }
        }
        case PGDatePickerModeMinuteAndSecond:
        {
            if (component == 0) {
                return self.middleMinuteString;
            }
            if (component == 1) {
                return self.middleSecondString;
            }
        }
        case PGDatePickerModeDateAndTime:
        {
            if (component == 1) {
                return self.middleHourString;
            }
            if (component == 2) {
                return self.middleMinuteString;
            }
            return @"";
        }
        default:
            break;
    }
    return @"";
}

- (CGFloat)pickerView:(PGPickerView *)pickerView middleTextSpaceForcomponent:(NSInteger)component {
    switch (self.datePickerMode) {
        case PGDatePickerModeYear:
            return 20;
        case PGDatePickerModeYearAndMonth:
        {
            if (component == 0) {
                return 20;
            }
            if (component == 1) {
                return 10;
            }
        }
        case PGDatePickerModeDate:
        {
            if (component == 0) {
                return 22;
            }
            if (component == 1) {
                return 10;
            }
            if (component == 2) {
                return 10;
            }
        }
        case PGDatePickerModeDateHour:
        {
            if (component == 0) {
                return 20;
            }
            if (component == 1) {
                return 10;
            }
            if (component == 2) {
                return 10;
            }
            if (component == 3) {
                return 10;
            }
        }
        case PGDatePickerModeDateHourMinute:
        {
            if (component == 0) {
                return 20;
            }
            if (component == 1) {
                return 10;
            }
            if (component == 2) {
                return 10;
            }
            if (component == 3) {
                return 10;
            }
            if (component == 4) {
                return 10;
            }
        }
        case PGDatePickerModeDateHourMinuteSecond:
        {
            if (component == 0) {
                return 17;
            }
            if (component == 1) {
                return 10;
            }
            if (component == 2) {
                return 10;
            }
            if (component == 3) {
                return 10;
            }
            if (component == 4) {
                return 10;
            }
            if (component == 5) {
                return 13;
            }
        }
        case PGDatePickerModeMonthDay:
        {
             return 10;
        }
        case PGDatePickerModeMonthDayHour:
        {
             return 10;
        }
        case PGDatePickerModeMonthDayHourMinute:
        {
            return 10;
        }
        case PGDatePickerModeMonthDayHourMinuteSecond:
        {
            return 10;
        }
        case PGDatePickerModeTime:
        {
            if (component == 0) {
                return 17;
            }
            if (component == 1) {
                return 13;
            }
        }
        case PGDatePickerModeTimeAndSecond:
        {
            if (component == 0) {
                return 17;
            }
            if (component == 1) {
                return 13;
            }
            if (component == 2) {
                return 13;
            }
        }
        case PGDatePickerModeMinuteAndSecond:
        {
            if (component == 0) {
                return 17;
            }
            if (component == 1) {
                return 13;
            }
        }
        case PGDatePickerModeDateAndTime:
        {
            if (component == 0) {
                return 17;
            }
            if (component == 1) {
                return 13;
            }
            if (component == 2) {
                return 13;
            }
        }
        default:
            break;
    }
    return 0;
}

#pragma mark - Setter

- (void)setDatePickerMode:(PGDatePickerMode)datePickerMode {
    _datePickerMode = datePickerMode;
    [self.pickerView reloadAllComponents];
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    self.minimumComponents = [self.calendar components:self.unitFlags fromDate:minimumDate];
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    self.maximumComponents = [self.calendar components:self.unitFlags fromDate:maximumDate];
}

#pragma mark - Getter
- (NSDateComponents *)minimumComponents {
    if (self.minimumDate) {
        _minimumComponents = [self.calendar components:self.unitFlags fromDate:self.minimumDate];
    }else {
        _minimumComponents = [self.calendar components:self.unitFlags fromDate:[NSDate distantPast]];
        _minimumComponents.day = 1;
        _minimumComponents.month = 1;
        _minimumComponents.hour = 0;
        _minimumComponents.minute = 0;
        _minimumComponents.second = 0;
    }
    return _minimumComponents;
}

- (NSDateComponents *)maximumComponents {
    if (self.maximumDate) {
        _maximumComponents = [self.calendar components:self.unitFlags fromDate:self.maximumDate];
    }else {
        _maximumComponents = [self.calendar components:self.unitFlags fromDate:[NSDate distantFuture]];
        NSInteger day = [self daysWithMonthInThisYear:self.currentComponents.year withMonth:self.currentComponents.month];
        _maximumComponents.day = day;
        _maximumComponents.month = 12;
        _maximumComponents.hour = 23;
        _maximumComponents.minute = 59;
        _maximumComponents.second = 59;
    }
    return _maximumComponents;
}

- (NSDateComponents *)currentComponents {
    if (!_currentComponents) {
        _currentComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    }
    return _currentComponents;
}

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
        _calendar.timeZone = self.timeZone;
        _calendar.locale = self.locale;
    }
    return _calendar;
}

- (NSLocale *)locale {
    if (!_locale) {
        _locale = [NSLocale currentLocale];
    }
    return _locale;
}

- (BOOL)isHiddenMiddleText{
    if (_showUnit == PGShowUnitTypeCenter) {
        return NO;
    }else if (_showUnit == PGShowUnitTypeAll){
        return YES;
    }
    return _isHiddenMiddleText;
}

- (NSArray *)yearList {
    if (!_yearList) {
        NSUInteger index = self.maximumComponents.year - self.minimumComponents.year;
        NSMutableArray *years = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.year; i <= self.maximumComponents.year; i++) {
            [years addObject:[@(i) stringValue]];
        }
        _yearList = years;
    }
    return _yearList;
}

- (NSArray *)monthList {
    if (!_monthList) {
        NSUInteger minimum = 1;
        NSUInteger maximum = 12;
        if (_setDate == nil && self.maximumComponents.year <= self.currentComponents.year) {
            maximum = self.maximumComponents.month;
        }
        if (self.selectComponents.year == self.minimumComponents.year) {
            minimum = self.minimumComponents.month;
        }
        if (self.selectComponents.year == self.maximumComponents.year) {
            maximum = self.maximumComponents.month;
        }
        if (self.minimumComponents.year == self.maximumComponents.year) {
            minimum = self.minimumComponents.month;
            maximum = self.maximumComponents.month;
            
        }
        NSMutableArray *months = [NSMutableArray arrayWithCapacity:maximum];
        for (NSUInteger i = minimum; i <= maximum; i++) {
            [months addObject:[@(i) stringValue]];
        }
        _monthList = months;
    }
    return _monthList;
}

- (NSArray *)hourList {
    if (!_hourList) {
        NSUInteger minimum = 0;
        NSUInteger maximum = 23;
        
        if (self.selectComponents.year == self.maximumComponents.year &&
            self.selectComponents.month == self.maximumComponents.month &&
            self.selectComponents.day == self.maximumComponents.day) {
            maximum = self.maximumComponents.hour;
        }
        if (self.selectComponents.year == self.minimumComponents.year &&
            self.selectComponents.month == self.minimumComponents.month &&
            self.selectComponents.day == self.minimumComponents.day) {
            minimum = self.minimumComponents.hour;
        }
        if (self.maximumComponents.year == self.minimumComponents.year &&
            self.maximumComponents.month == self.minimumComponents.month &&
            self.maximumComponents.day == self.minimumComponents.day) {
            minimum = self.minimumComponents.hour;
            maximum = self.maximumComponents.hour;
        }
        NSInteger index = maximum - minimum;
        if (self.datePickerMode == PGDatePickerModeTime || self.datePickerMode == PGDatePickerModeTimeAndSecond) {
            index = self.maximumComponents.hour - self.minimumComponents.hour;
            minimum = self.minimumComponents.hour;
            maximum = self.maximumComponents.hour;
            if (index < 0) {
                index = 23;
                minimum = 0;
                maximum = index;
            }
        }
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = minimum; i <= maximum; i++) {
            if (i < 10) {
                [hours addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [hours addObject:[@(i) stringValue]];
            }
        }
        _hourList = hours;
    }
    return _hourList;
}

- (NSArray *)minuteList {
    if (!_minuteList) {
        NSUInteger minimum = 0;
        NSUInteger maximum = 59;
        if (self.selectComponents.year == self.maximumComponents.year &&
            self.selectComponents.month == self.maximumComponents.month &&
            self.selectComponents.day == self.maximumComponents.day &&
            self.selectComponents.hour >= self.maximumComponents.hour) {
            maximum = self.maximumComponents.minute;
        }
        if (self.selectComponents.year == self.minimumComponents.year &&
            self.selectComponents.month == self.minimumComponents.month &&
            self.selectComponents.day == self.minimumComponents.day &&
            self.selectComponents.hour <= self.minimumComponents.hour) {
            minimum = self.minimumComponents.minute;
        }
        if (self.maximumComponents.year == self.minimumComponents.year &&
            self.maximumComponents.month == self.minimumComponents.month &&
            self.maximumComponents.day == self.minimumComponents.day &&
            self.maximumComponents.hour == self.minimumComponents.hour) {
            minimum = self.minimumComponents.minute;
            maximum = self.maximumComponents.minute;
        }
        if (self.datePickerMode == PGDatePickerModeTime || self.datePickerMode == PGDatePickerModeTimeAndSecond) {
            if (self.selectComponents.hour == self.minimumComponents.hour) {
                minimum = self.minimumComponents.minute;
            }
            if (self.selectComponents.hour == self.maximumComponents.hour) {
                maximum = self.maximumComponents.minute;
            }
        }
        NSInteger index = maximum - minimum;
        if (self.datePickerMode == PGDatePickerModeMinuteAndSecond) {
            index = self.maximumComponents.minute - self.minimumComponents.minute;
            minimum = self.minimumComponents.minute;
            maximum = self.maximumComponents.minute;
            if (index < 0) {
                index = 23;
                minimum = 0;
                maximum = index;
            }
        }
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = minimum; i <= maximum; i+=self.minuteInterval) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        _minuteList = minutes;
    }
    return _minuteList;
}

- (NSArray *)secondList {
    if (!_secondList) {
        NSUInteger minimum = 0;
        NSUInteger maximum = 59;
        if (self.selectComponents.year == self.maximumComponents.year &&
            self.selectComponents.month == self.maximumComponents.month &&
            self.selectComponents.day == self.maximumComponents.day &&
            self.selectComponents.hour == self.maximumComponents.hour &&
            self.selectComponents.minute == self.maximumComponents.minute) {
            maximum = self.maximumComponents.second;
        }
        if (self.selectComponents.year == self.minimumComponents.year &&
            self.selectComponents.month == self.minimumComponents.month &&
            self.selectComponents.day == self.minimumComponents.day &&
            self.selectComponents.hour == self.minimumComponents.hour &&
            self.selectComponents.minute == self.minimumComponents.minute) {
            minimum = self.minimumComponents.second;
        }
        if (self.maximumComponents.year == self.minimumComponents.year &&
            self.maximumComponents.month == self.minimumComponents.month &&
            self.maximumComponents.day == self.minimumComponents.day &&
            self.maximumComponents.hour == self.minimumComponents.hour &&
            self.maximumComponents.minute == self.minimumComponents.minute) {
            minimum = self.minimumComponents.second;
            maximum = self.maximumComponents.second;
        }
        if (self.datePickerMode == PGDatePickerModeTime || self.datePickerMode == PGDatePickerModeTimeAndSecond) {
            if (self.selectComponents.hour == self.minimumComponents.hour &&
                self.selectComponents.minute == self.minimumComponents.minute) {
                minimum = self.minimumComponents.second;
            }
            if (self.selectComponents.hour == self.maximumComponents.hour &&
                self.selectComponents.minute == self.maximumComponents.minute) {
                maximum = self.maximumComponents.second;
            }
        }
        NSUInteger index = maximum - minimum;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = minimum; i <= maximum; i+=self.secondInterval) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        _secondList = seconds;
    }
    return _secondList;
}

- (NSArray *)dateAndTimeList {
    if (!_dateAndTimeList) {
        NSMutableArray *array = [NSMutableArray array];
        NSUInteger firstIndex = self.minimumComponents.month - 1;
        NSUInteger lastIndex = self.maximumComponents.month - 1;
        NSString *monthString = [NSBundle pg_localizedStringForKey:@"monthString" language:self.language];
        NSString *dayString = [NSBundle pg_localizedStringForKey:@"dayString" language:self.language];
        if (firstIndex == lastIndex) {
            firstIndex = 0;
            lastIndex = 0;
        }
        for (NSUInteger i = firstIndex; i <= lastIndex; i++) {
            NSUInteger index = i - firstIndex;
            NSString *month = self.monthList[index];
            NSUInteger day = [self daysWithMonthInThisYear:self.currentComponents.year withMonth:[month integerValue]];
            {
                NSMutableArray *days = [NSMutableArray arrayWithCapacity:day];
                NSInteger minDay = 1, maxDay = day;
                if (i == firstIndex) {
                    minDay = self.minimumComponents.day;
                }
                if (i == lastIndex) {
                    maxDay = self.maximumComponents.day;
                }
                for (NSUInteger i = minDay; i <= maxDay; i++) {
                    [days addObject:[@(i) stringValue]];
                }
                self.dayList = days;
            }
            [self.dayList enumerateObjectsUsingBlock:^(NSString*  _Nonnull day, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
                dateComponents.year = self.currentComponents.year;
                dateComponents.month = [month integerValue];
                dateComponents.day = [day integerValue];
                NSInteger weekDay = [self.calendar component:NSCalendarUnitWeekday fromDate:[NSDate dateFromComponents:dateComponents]];
                NSString *string = [NSString stringWithFormat:@"%@%@%@%@ %@ ", month, monthString, day, dayString, [self weekMappingFrom:weekDay]];
                [array addObject:string];
            }];
        }
        _dateAndTimeList = array;
    }
    return _dateAndTimeList;
}

- (NSCalendarUnit)unitFlags {
    if (!_unitFlags) {
        _unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    }
    return _unitFlags;
}

- (NSInteger)components {
    switch (self.datePickerMode) {
        case PGDatePickerModeYear:
            return 1;
        case PGDatePickerModeYearAndMonth:
            return 2;
        case PGDatePickerModeDate:
            return 3;
        case PGDatePickerModeDateHour:
            return 4;
        case PGDatePickerModeDateHourMinute:
            return 5;
        case PGDatePickerModeDateHourMinuteSecond:
            return 6;
        case PGDatePickerModeMonthDay:
            return 2;
        case PGDatePickerModeMonthDayHour:
            return 3;
        case PGDatePickerModeMonthDayHourMinute:
            return 4;
        case PGDatePickerModeMonthDayHourMinuteSecond:
            return 5;
        case PGDatePickerModeTime:
            if(!self.isOnlyHourFlag) {
                return 2;
            }
            else return 1;
        case PGDatePickerModeTimeAndSecond:
            return 3;
        case PGDatePickerModeMinuteAndSecond:
            return 2;
        case PGDatePickerModeDateAndTime:
            return 3;
        default:
            break;
    }
    return 0;
}

- (UIColor *)lineBackgroundColor {
    if (!_lineBackgroundColor) {
        _lineBackgroundColor = [UIColor pg_colorWithHexString:@"#69BDFF"];
    }
    return _lineBackgroundColor;
}

- (UIColor *)textColorOfOtherRow {
    if (!_textColorOfOtherRow) {
        _textColorOfOtherRow = [UIColor lightGrayColor];
    }
    return _textColorOfOtherRow;
}

- (UIColor *)textColorOfSelectedRow {
    if (!_textColorOfSelectedRow) {
        _textColorOfSelectedRow = [UIColor pg_colorWithHexString:@"#69BDFF"];
    }
    return _textColorOfSelectedRow;
}

- (UIFont *)textFontOfSelectedRow {
    if (!_textFontOfSelectedRow) {
        _textFontOfSelectedRow = [UIFont systemFontOfSize:17];
    }
    return _textFontOfSelectedRow;
}

- (UIFont *)textFontOfOtherRow {
    if (!_textFontOfOtherRow) {
        _textFontOfOtherRow = [UIFont systemFontOfSize:17];
    }
    return _textFontOfOtherRow;
}

- (CGFloat)rowHeight {
    if (!_rowHeight) {
        _rowHeight = 50;
    }
    return _rowHeight;
}

- (UIColor *)middleTextColor {
    if (!_middleTextColor) {
        _middleTextColor = [UIColor pg_colorWithHexString:@"#69BDFF"];
    }
    return _middleTextColor;
}

- (NSString *)yearString {
    if (!_yearString) {
        if (!self.isHiddenMiddleText) {
            _yearString = @"";
        }else {
            _yearString = [NSBundle pg_localizedStringForKey:@"yearString" language:self.language];
        }
    }
    return _yearString;
}

- (NSString *)middleYearString {
    if (!_middleYearString) {
        _middleYearString = [NSBundle pg_localizedStringForKey:@"yearString" language:self.language];
    }
    return _middleYearString;
}

- (NSString *)monthString {
    if (!_monthString) {
        if (!self.isHiddenMiddleText) {
            _monthString = @"";
        }else {
            _monthString = [NSBundle pg_localizedStringForKey:@"monthString" language:self.language];
        }
    }
    return _monthString;
}

- (NSString *)middleMonthString {
    if (!_middleMonthString) {
        _middleMonthString = [NSBundle pg_localizedStringForKey:@"monthString" language:self.language];
    }
    return _middleMonthString;
}

- (NSString *)dayString {
    if (!_dayString) {
        if (!self.isHiddenMiddleText) {
            _dayString = @"";
        }else {
            _dayString = [NSBundle pg_localizedStringForKey:@"dayString" language:self.language];
        }
    }
    return _dayString;
}

- (NSString *)middleDayString {
    if (!_middleDayString) {
        _middleDayString = [NSBundle pg_localizedStringForKey:@"dayString" language:self.language];
    }
    return _middleDayString;
}

- (NSString *)hourString {
    if (!_hourString) {
        if (!self.isHiddenMiddleText) {
            _hourString = @"";
        }else {
            _hourString = [NSBundle pg_localizedStringForKey:@"hourString" language:self.language];
        }
    }
    return _hourString;
}

- (NSString *)middleHourString {
    if (!_middleHourString) {
        _middleHourString = [NSBundle pg_localizedStringForKey:@"hourString" language:self.language];
    }
    return _middleHourString;
}

- (NSString *)minuteString {
    if (!_minuteString) {
        if (!self.isHiddenMiddleText) {
            _minuteString = @"";
        }else {
            _minuteString = [NSBundle pg_localizedStringForKey:@"minuteString" language:self.language];
        }
    }
    return _minuteString;
}

- (NSString *)middleMinuteString {
    if (!_middleMinuteString) {
        _middleMinuteString = [NSBundle pg_localizedStringForKey:@"minuteString" language:self.language];
    }
    return _middleMinuteString;
}

- (NSString *)secondString {
    if (!_secondString) {
        if (!self.isHiddenMiddleText) {
            _secondString = @"";
        }else {
            _secondString = [NSBundle pg_localizedStringForKey:@"secondString" language:self.language];
        }
    }
    return _secondString;
}

- (NSString *)middleSecondString {
    if (!_middleSecondString) {
        _middleSecondString = [NSBundle pg_localizedStringForKey:@"secondString" language:self.language];
    }
    return _middleSecondString;
}

- (NSString *)mondayString {
    if (!_mondayString) {
        _mondayString = [NSBundle pg_localizedStringForKey:@"mondayString" language:self.language];
    }
    return _mondayString;
}

- (NSString *)tuesdayString {
    if (!_tuesdayString) {
        _tuesdayString = [NSBundle pg_localizedStringForKey:@"tuesdayString" language:self.language];
    }
    return _tuesdayString;
}

- (NSString *)wednesdayString {
    if (!_wednesdayString) {
        _wednesdayString = [NSBundle pg_localizedStringForKey:@"wednesdayString" language:self.language];
    }
    return _wednesdayString;
}

- (NSString *)thursdayString {
    if (!_thursdayString) {
        _thursdayString = [NSBundle pg_localizedStringForKey:@"thursdayString" language:self.language];
    }
    return _thursdayString;
}

- (NSString *)fridayString {
    if (!_fridayString) {
        _fridayString = [NSBundle pg_localizedStringForKey:@"fridayString" language:self.language];
    }
    return _fridayString;
}

- (NSString *)saturdayString {
    if (!_saturdayString) {
        _saturdayString = [NSBundle pg_localizedStringForKey:@"saturdayString" language:self.language];
    }
    return _saturdayString;
}

- (NSString *)sundayString {
    if (!_sundayString) {
        _sundayString = [NSBundle pg_localizedStringForKey:@"sundayString" language:self.language];
    }
    return _sundayString;
}
@end

