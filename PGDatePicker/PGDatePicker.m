//
//  PGDatePicker.m
//  HooDatePickerDemo
//
//  Created by piggybear on 2017/7/25.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"
#import "PGDatePickerView.h"
#import "NSBundle+PGDatePicker.h"
#import "PGDatePickerMacros.h"

@interface PGDatePicker()<PGPickerViewDelegate, PGPickerViewDataSource>{
    BOOL _isSubViewLayout;
    BOOL _isSetDateAnimation;
    BOOL _isDelay;
    BOOL _isSetDate;
    NSDate *_setDate;
    BOOL _isSelectedCancelButton;
}

@property (nonatomic, weak) PGPickerView *pickerView;

@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UIButton *confirmButton;

@property (nonatomic, strong) NSDateComponents *minimumComponents;
@property (nonatomic, strong) NSDateComponents *maximumComponents;

@property (nonatomic, strong) NSDateComponents *selectComponents;
@property (nonatomic, strong) NSDateComponents *selectedComponents;
@property (nonatomic, strong) NSDateComponents *currentComponents;

@property (nonatomic, strong) NSArray *yearList;
@property (nonatomic, strong) NSArray *monthList;
@property (nonatomic, strong) NSArray *dayList;
@property (nonatomic, strong) NSArray *hourList;
@property (nonatomic, strong) NSArray *minuteList;
@property (nonatomic, strong) NSArray *secondList;
@property (nonatomic, strong) NSArray *dateAndTimeList;

@property (nonatomic, assign) NSCalendarUnit unitFlags;
@property (nonatomic, assign) NSInteger components;
@property (nonatomic, assign) BOOL isCurrent;

@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UIView *dismissView;
@property (nonatomic, assign) BOOL isDisplayShadeBackgroud;

@property (nonatomic, copy) NSString *yearString;
@property (nonatomic, copy) NSString *monthString;
@property (nonatomic, copy) NSString *dayString;
@property (nonatomic, copy) NSString *hourString;
@property (nonatomic, copy) NSString *minuteString;
@property (nonatomic, copy) NSString *secondString;
@property (nonatomic, copy) NSString *mondayString;
@property (nonatomic, copy) NSString *tuesdayString;
@property (nonatomic, copy) NSString *wednesdayString;
@property (nonatomic, copy) NSString *thursdayString;
@property (nonatomic, copy) NSString *fridayString;
@property (nonatomic, copy) NSString *saturdayString;
@property (nonatomic, copy) NSString *sundayString;

@property (nonatomic, copy) NSString *middleYearString;
@property (nonatomic, copy) NSString *middleMonthString;
@property (nonatomic, copy) NSString *middleDayString;
@property (nonatomic, copy) NSString *middleHourString;
@property (nonatomic, copy) NSString *middleMinuteString;
@property (nonatomic, copy) NSString *middleSecondString;
@property (nonatomic, copy) NSString *middleMondayString;
@property (nonatomic, copy) NSString *middleTuesdayString;
@property (nonatomic, copy) NSString *middleWednesdayString;
@property (nonatomic, copy) NSString *middleThursdayString;
@property (nonatomic, copy) NSString *middleFridayString;
@property (nonatomic, copy) NSString *middleSaturdayString;
@property (nonatomic, copy) NSString *middleSundayString;

- (NSInteger)rowsInComponent:(NSInteger)component;
@end

static NSString *const reuseIdentifier = @"PGDatePickerView";

@implementation PGDatePicker

- (instancetype)init {
    if (self = [super init]) {
        self.isHiddenMiddleText = true;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_isSelectedCancelButton) {
        return;
    }
    if (self.headerView) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window bringSubviewToFront:self];
        [window bringSubviewToFront:self.headerView];
        CGFloat height = kTableViewHeight;
        CGFloat width =  [self.cancelButtonText sizeWithAttributes:@{NSFontAttributeName: self.cancelButtonFont}].width;
        self.cancelButton.titleLabel.font = self.cancelButtonFont;
        [self.cancelButton setTitle:self.cancelButtonText forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:self.cancelButtonTextColor forState:UIControlStateNormal];
        self.cancelButton.frame = CGRectMake(10, 0, width, kHeaderViewHeight);
        
        CGFloat confirmWidth =  [self.confirmButtonText sizeWithAttributes:@{NSFontAttributeName: self.confirmButtonFont}].width;
        self.confirmButton.frame = CGRectMake(kScreenWidth - confirmWidth - 10, 0, confirmWidth, kHeaderViewHeight);
        self.confirmButton.titleLabel.font = self.confirmButtonFont;
        [self.confirmButton setTitle:self.confirmButtonText forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:self.confirmButtonTextColor forState:UIControlStateNormal];
        
        CGFloat bottom = 0;
        if (@available(iOS 11.0, *)) {
            bottom = self.safeAreaInsets.bottom;
        }
        CGRect headerViewFrame = CGRectMake(0, kScreenHeight - height - kHeaderViewHeight - bottom, kScreenWidth, kHeaderViewHeight);
        [UIView animateWithDuration:0.3 animations:^{
            self.dismissView.alpha = 1;
            self.headerView.frame = headerViewFrame;
            self.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreenWidth, height + bottom);
        }];
    }
    _isSubViewLayout = true;
    [self setupPickerView];
}

- (void)setupPickerView {
    if (_setDate) {
        self.selectComponents = [self.calendar components:self.unitFlags fromDate:_setDate];
    }else {
        self.selectComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    }
    if (self.minimumDate || self.maximumDate) {
        if (self.currentComponents.year < self.minimumComponents.year) {
            self.selectComponents.year = self.minimumComponents.year;
            self.selectComponents.month = self.minimumComponents.month;
            self.selectComponents.day = self.minimumComponents.day;
            self.selectComponents.hour = self.minimumComponents.hour;
            self.selectComponents.minute = self.minimumComponents.minute;
            self.selectComponents.second = self.minimumComponents.second;
        }else if (self.currentComponents.year > self.maximumComponents.year) {
            self.selectComponents.year = self.maximumComponents.year;
            self.selectComponents.month = self.maximumComponents.month;
        }else if (self.currentComponents.year == self.minimumComponents.year) {
            self.selectComponents.month = self.minimumComponents.month;
        }
        NSInteger day = [self howManyDaysWithMonthInThisYear:self.selectComponents.year withMonth:self.selectComponents.month];
        [self setDayListForMonthDays:day];
    }else {
        NSInteger day = [self howManyDaysWithMonthInThisYear:self.currentComponents.year withMonth:self.currentComponents.month];
        [self setDayListForMonthDays:day];
    }
    
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = self.safeAreaInsets.bottom;
    }
    CGRect frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - bottom);
    PGPickerView *pickerView = [[PGPickerView alloc]initWithFrame:frame];
    if (_middleText) {
        self.isHiddenMiddleText = !_middleText;
    }
    pickerView.rowHeight = kTableViewCellHeight;
    pickerView.isHiddenMiddleText = self.isHiddenMiddleText;
    pickerView.middleTextColor = self.middleTextColor;
    pickerView.lineBackgroundColor = self.lineBackgroundColor;
    if (_titleColorForOtherRow) {
        self.textColorOfOtherRow = _titleColorForOtherRow;
    }
    if (_titleColorForSelectedRow) {
        self.textColorOfSelectedRow = _titleColorForSelectedRow;
    }
    pickerView.textColorOfSelectedRow = self.textColorOfSelectedRow;
    pickerView.textColorOfOtherRow = self.textColorOfOtherRow;
    
    pickerView.type = (PGPickerViewType)self.datePickerType;
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

- (void)show {
    self.selectedComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    CGFloat height = kTableViewHeight;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = self.safeAreaInsets.bottom;
    }
    UIView *dismissView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - bottom)];
    if (self.isDisplayShadeBackgroud) {
        dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }else {
        dismissView.backgroundColor = [UIColor clearColor];
    }
    dismissView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelButtonHandler)];
    [dismissView addGestureRecognizer:tap];
    [window addSubview:dismissView];
    self.dismissView = dismissView;
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY (self.headerView.frame), kScreenWidth, height);
    self.frame = frame;
    self.backgroundColor = [UIColor whiteColor];
    [window addSubview:self];
    
    CGFloat width =  [self.cancelButtonText sizeWithAttributes:@{NSFontAttributeName: self.cancelButtonFont}].width;
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, width, kHeaderViewHeight)];
    cancel.titleLabel.font = self.cancelButtonFont;
    [cancel setTitle:self.cancelButtonText forState:UIControlStateNormal];
    [cancel setTitleColor:self.cancelButtonTextColor forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton = cancel;
    [self.headerView addSubview:cancel];
    
    CGFloat confirmWidth =  [self.confirmButtonText sizeWithAttributes:@{NSFontAttributeName: self.confirmButtonFont}].width;
    UIButton *confirm = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - confirmWidth - 10, 0, confirmWidth, kHeaderViewHeight)];
    confirm.titleLabel.font = self.confirmButtonFont;
    [confirm setTitle:self.confirmButtonText forState:UIControlStateNormal];
    [confirm setTitleColor:self.confirmButtonTextColor forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirmButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton = confirm;
    [self.headerView addSubview:confirm];
}

- (void)showWithShadeBackgroud {
    self.isDisplayShadeBackgroud = true;
    [self show];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    UILabel *label = object;
    NSString *newString = change[@"new"];
    CGSize size = [newString sizeWithAttributes:@{NSFontAttributeName: [label font]}];
    self.titleLabel.frame = CGRectMake(kScreenWidth / 2 - size.width / 2, 0, size.width, kHeaderViewHeight);
}

- (void)cancelButtonHandler {
    self.dismissView.hidden = true;
    _isSelectedCancelButton = true;
    CGFloat height = kTableViewHeight;
    CGRect headerViewFrame = CGRectMake(0, kScreenHeight, kScreenWidth, kHeaderViewHeight);
    [UIView animateWithDuration:0.3 animations:^{
        self.headerView.frame = headerViewFrame;
        self.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreenWidth, height);
        self.dismissView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.headerView removeFromSuperview];
        [self.dismissView removeFromSuperview];
        [self.titleLabel removeObserver:self forKeyPath:@"text"];
        [self removeFromSuperview];
    }];
}

- (void)confirmButtonHandler {
    if (self.autoSelected == false) {
        [self selectedDateLogic];
    }
    [self cancelButtonHandler];
}

- (void)selectedDateLogic {
    switch (self.datePickerMode) {
        case PGDatePickerModeYear:
        {
            NSString *yearString = [self.pickerView textOfSelectedRowInComponent:0];
            yearString = [yearString componentsSeparatedByString:self.yearString].firstObject;
            self.selectedComponents.year = [yearString integerValue];
        }
            break;
        case PGDatePickerModeYearAndMonth:
        {
            NSString *yearString = [self.pickerView textOfSelectedRowInComponent:0];
            yearString = [yearString componentsSeparatedByString:self.yearString].firstObject;
            
            NSString *monthString = [self.pickerView textOfSelectedRowInComponent:1];
            monthString = [monthString componentsSeparatedByString:self.monthString].firstObject;
            
            self.selectedComponents.year = [yearString integerValue];
            self.selectedComponents.month = [monthString integerValue];
        }
            break;
        case PGDatePickerModeDate:
        {
            NSString *yearString = [self.pickerView textOfSelectedRowInComponent:0];
            yearString = [yearString componentsSeparatedByString:self.yearString].firstObject;
            
            NSString *monthString = [self.pickerView textOfSelectedRowInComponent:1];
            monthString = [monthString componentsSeparatedByString:self.monthString].firstObject;
            
            NSString *dayString = [self.pickerView textOfSelectedRowInComponent:2];
            dayString = [dayString componentsSeparatedByString:self.dayString].firstObject;
            
            self.selectedComponents.year = [yearString integerValue];
            self.selectedComponents.month = [monthString integerValue];
            self.selectedComponents.day = [dayString integerValue];
        }
            break;
        case PGDatePickerModeDateHourMinute:
        {
            NSString *yearString = [self.pickerView textOfSelectedRowInComponent:0];
            yearString = [yearString componentsSeparatedByString:self.yearString].firstObject;
            self.selectedComponents.year = [yearString integerValue];
            
            NSString *monthString = [self.pickerView textOfSelectedRowInComponent:1];
            monthString = [monthString componentsSeparatedByString:self.monthString].firstObject;
            self.selectedComponents.month = [monthString integerValue];
            
            NSString *dayString = [self.pickerView textOfSelectedRowInComponent:2];
            dayString = [dayString componentsSeparatedByString:self.dayString].firstObject;
            self.selectedComponents.day = [dayString integerValue];
            
            NSString *hourString = [self.pickerView textOfSelectedRowInComponent:3];
            hourString = [hourString componentsSeparatedByString:self.hourString].firstObject;
            self.selectedComponents.hour = [hourString integerValue];
            
            NSString *minuteString = [self.pickerView textOfSelectedRowInComponent:4];
            minuteString = [minuteString componentsSeparatedByString:self.minuteString].firstObject;
            self.selectedComponents.minute = [minuteString integerValue];
        }
            break;
        case PGDatePickerModeDateHourMinuteSecond:
        {
            NSString *yearString = [self.pickerView textOfSelectedRowInComponent:0];
            yearString = [yearString componentsSeparatedByString:self.yearString].firstObject;
            self.selectedComponents.year = [yearString integerValue];
            
            NSString *monthString = [self.pickerView textOfSelectedRowInComponent:1];
            monthString = [monthString componentsSeparatedByString:self.monthString].firstObject;
            self.selectedComponents.month = [monthString integerValue];
            
            NSString *dayString = [self.pickerView textOfSelectedRowInComponent:2];
            dayString = [dayString componentsSeparatedByString:self.dayString].firstObject;
            self.selectedComponents.day = [dayString integerValue];
            
            NSString *hourString = [self.pickerView textOfSelectedRowInComponent:3];
            hourString = [hourString componentsSeparatedByString:self.hourString].firstObject;
            self.selectedComponents.hour = [hourString integerValue];
            
            NSString *minuteString = [self.pickerView textOfSelectedRowInComponent:4];
            minuteString = [minuteString componentsSeparatedByString:self.minuteString].firstObject;
            self.selectedComponents.minute = [minuteString integerValue];
            
            NSString *secondString = [self.pickerView textOfSelectedRowInComponent:5];
            secondString = [secondString componentsSeparatedByString:self.secondString].firstObject;
            self.selectedComponents.second = [secondString integerValue];
        }
            break;
        case PGDatePickerModeTime:
        {
            NSString *hourString = [self.pickerView textOfSelectedRowInComponent:0];
            hourString = [hourString componentsSeparatedByString:self.hourString].firstObject;
            
            NSString *minuteString = [self.pickerView textOfSelectedRowInComponent:1];
            minuteString = [minuteString componentsSeparatedByString:self.minuteString].firstObject;
            
            self.selectedComponents.hour = [hourString integerValue];
            self.selectedComponents.minute = [minuteString integerValue];
        }
            break;
        case PGDatePickerModeTimeAndSecond:
        {
            NSString *hourString = [self.pickerView textOfSelectedRowInComponent:0];
            hourString = [hourString componentsSeparatedByString:self.hourString].firstObject;
            self.selectedComponents.hour = [hourString integerValue];
            
            NSString *minuteString = [self.pickerView textOfSelectedRowInComponent:1];
            minuteString = [minuteString componentsSeparatedByString:self.minuteString].firstObject;
            self.selectedComponents.minute = [minuteString integerValue];
            
            NSString *secondString = [self.pickerView textOfSelectedRowInComponent:2];
            secondString = [secondString componentsSeparatedByString:self.secondString].firstObject;
            self.selectedComponents.second = [secondString integerValue];
        }
            break;
        case PGDatePickerModeDateAndTime:
        {
            NSString *string = [self.pickerView textOfSelectedRowInComponent:0];
            NSString *str = [string componentsSeparatedByString:self.monthString].firstObject;
            self.selectedComponents.month = [str integerValue];
            NSString *str2 = [string componentsSeparatedByString:self.monthString].lastObject;
            NSString *str3 = [str2 componentsSeparatedByString:self.dayString].firstObject;
            self.selectedComponents.day = [str3 integerValue];
            NSString *str4 = [str2 componentsSeparatedByString:self.dayString].lastObject;
            str4 = [str4 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.selectedComponents.weekday = [self weekDayMappingFrom:str4];
            
            NSString *hourString = [self.pickerView textOfSelectedRowInComponent:1];
            hourString = [hourString componentsSeparatedByString:self.hourString].firstObject;
            
            NSString *minuteString = [self.pickerView textOfSelectedRowInComponent:2];
            minuteString = [minuteString componentsSeparatedByString:self.minuteString].firstObject;
            
            self.selectedComponents.hour = [hourString integerValue];
            self.selectedComponents.minute = [minuteString integerValue];
        }
            break;
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePicker:didSelectDate:)]) {
        [self.delegate datePicker:self didSelectDate:self.selectedComponents];
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
    NSDateComponents *components = self.selectComponents;
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
            if (components.year > self.maximumComponents.year) {
                components.year = self.maximumComponents.year;
            }else if (components.year < self.minimumComponents.year) {
                components.year = self.minimumComponents.year;
            }
            NSInteger row = components.year - self.minimumComponents.year;
            [self.pickerView selectRow:row inComponent:0 animated:animated];
        }
            break;
        case PGDatePickerModeYearAndMonth:
        {
            if (components.year > self.maximumComponents.year) {
                components.year = self.maximumComponents.year;
            }else if (components.year < self.minimumComponents.year) {
                components.year = self.minimumComponents.year;
            }
            NSInteger row = components.year - self.minimumComponents.year;
            [self.pickerView selectRow:row inComponent:0 animated:animated];
            {
                NSInteger row = 0;
                NSString *string = [NSString stringWithFormat:@"%ld", components.month];
                BOOL isExist = [self.monthList containsObject:string];
                if (isExist) {
                    row = [self.monthList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:1 animated:animated];
            }
        }
            break;
        case PGDatePickerModeDate:
        {
            BOOL tf = false;
            if (components.year > self.maximumComponents.year) {
                components.year = self.maximumComponents.year;
                tf = true;
            }else if (components.year < self.minimumComponents.year) {
                components.year = self.minimumComponents.year;
                tf = true;
            }
            NSInteger row = components.year - self.minimumComponents.year;
            [self.pickerView selectRow:row inComponent:0 animated:animated];
            if (tf) {
//                return;
            }
            {
                NSInteger row = 0;
                NSString *string = [NSString stringWithFormat:@"%ld", components.month];
                BOOL isExist = [self.monthList containsObject:string];
                if (isExist) {
                    row = [self.monthList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:1 animated:animated];
            }
            {
                NSInteger row = 0;
                NSString *string = [NSString stringWithFormat:@"%ld", components.day];
                BOOL isExist = [self.dayList containsObject:string];
                if (isExist) {
                    row =[self.dayList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:2 animated:animated];
            }
        }
            break;
        case PGDatePickerModeDateHourMinute:
        {
            BOOL tf = false;
            if (components.year > self.maximumComponents.year) {
                components.year = self.maximumComponents.year;
                tf = true;
            }else if (components.year < self.minimumComponents.year) {
                components.year = self.minimumComponents.year;
                tf = true;
            }
            NSInteger row = components.year - self.minimumComponents.year;
            [self.pickerView selectRow:row inComponent:0 animated:animated];
            if (tf) {
                return;
            }
            {
                NSInteger row = 0;
                NSString *string = [NSString stringWithFormat:@"%ld", components.month];
                BOOL isExist = [self.monthList containsObject:string];
                if (isExist) {
                    row = [self.monthList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:1 animated:animated];
            }
            {
                NSInteger row = 0;
                NSString *string = [NSString stringWithFormat:@"%ld", components.day];
                BOOL isExist = [self.dayList containsObject:string];
                if (isExist) {
                    row =[self.dayList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:2 animated:animated];
            }
            {
                NSInteger row = 0;
                NSString *string = [NSString stringWithFormat:@"%ld", components.hour];
                if (components.hour < 10) {
                    string = [NSString stringWithFormat:@"0%ld", components.hour];
                }
                BOOL isExist = [self.hourList containsObject:string];
                if (isExist) {
                    row = [self.hourList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:3 animated:animated];
            }
            {
                NSInteger row = 0;
                NSString *string = [NSString stringWithFormat:@"%ld", components.minute];
                if (components.minute < 10) {
                    string = [NSString stringWithFormat:@"0%ld", components.minute];
                }
                BOOL isExist = [self.minuteList containsObject:string];
                if (isExist) {
                    row = [self.minuteList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:4 animated:animated];
            }
        }
            break;
        case PGDatePickerModeDateHourMinuteSecond:
        {
            BOOL tf = false;
            if (components.year > self.maximumComponents.year) {
                components.year = self.maximumComponents.year;
                tf = true;
            }else if (components.year < self.minimumComponents.year) {
                components.year = self.minimumComponents.year;
                tf = true;
            }
            NSInteger row = components.year - self.minimumComponents.year;
            [self.pickerView selectRow:row inComponent:0 animated:animated];
            if (tf) {
                return;
            }
            {
                NSInteger row = 0;
                NSString *string = [NSString stringWithFormat:@"%ld", components.month];
                BOOL isExist = [self.monthList containsObject:string];
                if (isExist) {
                    row = [self.monthList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:1 animated:animated];
            }
            {
                NSInteger row = 0;
                NSString *string = [NSString stringWithFormat:@"%ld", components.day];
                BOOL isExist = [self.dayList containsObject:string];
                if (isExist) {
                    row =[self.dayList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:2 animated:animated];
            }
            {
                NSInteger row = 0;
                NSString *string = [NSString stringWithFormat:@"%ld", components.hour];
                if (components.hour < 10) {
                    string = [NSString stringWithFormat:@"0%ld", components.hour];
                }
                BOOL isExist = [self.hourList containsObject:string];
                if (isExist) {
                    row = [self.hourList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:3 animated:animated];
            }
            {
                NSInteger row = 0;
                NSString *string = [NSString stringWithFormat:@"%ld", components.minute];
                if (components.minute < 10) {
                    string = [NSString stringWithFormat:@"0%ld", components.minute];
                }
                BOOL isExist = [self.minuteList containsObject:string];
                if (isExist) {
                    row = [self.minuteList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:4 animated:animated];
            }
            {
                NSString *string = [NSString stringWithFormat:@"%ld", components.second];
                if (components.second < 10) {
                    string = [NSString stringWithFormat:@"0%ld", components.second];
                }
                NSInteger row = 0;
                BOOL isExist = [self.secondList containsObject:string];
                if (isExist) {
                    row = [self.secondList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:5 animated:animated];
            }
        }
            break;
        case PGDatePickerModeTime:
        {
            if (components.hour > self.maximumComponents.hour) {
                components = self.maximumComponents;
            }
            if (components.hour < self.minimumComponents.hour) {
                components = self.minimumComponents;
            }
            NSString *string = [NSString stringWithFormat:@"%ld", components.hour];
            if (components.hour < 10) {
                string = [NSString stringWithFormat:@"0%ld", components.hour];
            }
            NSInteger row = 0;
            BOOL isExist = [self.hourList containsObject:string];
            if (isExist) {
                row = [self.hourList indexOfObject:string];
            }
            [self.pickerView selectRow:row inComponent:0 animated:animated];
            {
                NSString *string = [NSString stringWithFormat:@"%ld", components.minute];
                if (components.minute < 10) {
                    string = [NSString stringWithFormat:@"0%ld", components.minute];
                }
                NSInteger row = 0;
                BOOL isExist = [self.minuteList containsObject:string];
                if (isExist) {
                    row = [self.minuteList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:1 animated:animated];
            }
        }
            break;
        case PGDatePickerModeTimeAndSecond:
        {
            if (components.hour > self.maximumComponents.hour) {
                components = self.maximumComponents;
            }
            if (components.hour < self.minimumComponents.hour) {
                components = self.minimumComponents;
            }
            NSString *string = [NSString stringWithFormat:@"%ld", components.hour];
            if (components.hour < 10) {
                string = [NSString stringWithFormat:@"0%ld", components.hour];
            }
            NSInteger row = 0;
            BOOL isExist = [self.hourList containsObject:string];
            if (isExist) {
                row = [self.hourList indexOfObject:string];
            }
            [self.pickerView selectRow:row inComponent:0 animated:animated];
            {
                NSString *string = [NSString stringWithFormat:@"%ld", components.minute];
                if (components.minute < 10) {
                    string = [NSString stringWithFormat:@"0%ld", components.minute];
                }
                NSInteger row = 0;
                BOOL isExist = [self.minuteList containsObject:string];
                if (isExist) {
                    row = [self.minuteList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:1 animated:animated];
            }
            {
                NSString *string = [NSString stringWithFormat:@"%ld", components.second];
                if (components.second < 10) {
                    string = [NSString stringWithFormat:@"0%ld", components.second];
                }
                NSInteger row = 0;
                BOOL isExist = [self.secondList containsObject:string];
                if (isExist) {
                    row = [self.secondList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:2 animated:animated];
            }
        }
            break;
            
        case PGDatePickerModeDateAndTime:
        {
            if (components.month > self.maximumComponents.month) {
                components = self.maximumComponents;
            }
            if (components.month < self.minimumComponents.month) {
                components = self.minimumComponents;
            }
            NSString *string = [NSString stringWithFormat:@"%ld%@%ld%@ %@ ", components.month, self.monthString, components.day, self.dayString, [self weekMappingFrom:components.weekday]];
            NSInteger row = 0;
            BOOL isExist = [self.dateAndTimeList containsObject:string];
            if (isExist) {
                row = [self.dateAndTimeList indexOfObject:string];
            }
            [self.pickerView selectRow:row inComponent:0 animated:animated];
            {
                NSString *string = [NSString stringWithFormat:@"%ld", components.hour];
                if (components.hour < 10) {
                    string = [NSString stringWithFormat:@"0%ld", components.hour];
                }
                NSInteger row = 0;
                BOOL isExist = [self.hourList containsObject:string];
                if (isExist) {
                    row = [self.hourList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:1 animated:animated];
            }
            {
                NSString *string = [NSString stringWithFormat:@"%ld", components.minute];
                if (components.minute < 10) {
                    string = [NSString stringWithFormat:@"0%ld", components.minute];
                }
                NSInteger row = 0;
                BOOL isExist = [self.minuteList containsObject:string];
                if (isExist) {
                    row = [self.minuteList indexOfObject:string];
                }
                [self.pickerView selectRow:row inComponent:2 animated:animated];
            }
        }
            break;
        default:
            break;
    }
}

- (void)setDayListForMonthDays:(NSInteger)day {
    NSMutableArray *days = [NSMutableArray arrayWithCapacity:day];
    NSInteger minDay = 1, maxDay = self.maximumComponents.day;
    if (self.yearList.count == 1 && self.monthList.count == 1) {
        minDay = self.minimumComponents.day;
        day = maxDay;
    }
    if (self.selectComponents.year == self.maximumComponents.year && self.selectComponents.month == self.maximumComponents.month) {
        day = maxDay;
    }
    if (self.selectComponents.year == self.minimumComponents.year && self.selectComponents.month == self.minimumComponents.month) {
        minDay = self.minimumComponents.day;
    }
    for (NSUInteger i = minDay; i <= day; i++) {
        [days addObject:[@(i) stringValue]];
    }
    self.dayList = days;
}

- (NSInteger)howManyDaysWithMonthInThisYear:(NSInteger)year withMonth:(NSInteger)month{
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
        return 28;
    if(year % 400 == 0)
        return 29;
    if(year % 100 == 0)
        return 28;
    return 29;
}

- (NSString *)weekMappingFrom:(NSInteger)weekDay {
    switch (weekDay) {
        case 1:
            return self.sundayString;
        case 2:
            return self.mondayString;
        case 3:
            return self.tuesdayString;
        case 4:
            return self.wednesdayString;
        case 5:
            return self.thursdayString;
        case 6:
            return self.fridayString;
        case 7:
            return self.saturdayString;
        default:
            break;
    }
    return nil;
}

- (NSInteger)weekDayMappingFrom:(NSString *)weekString {
    if ([weekString isEqualToString:self.sundayString]) {
        return 1;
    }
    if ([weekString isEqualToString:self.mondayString]) {
        return 2;
    }
    if ([weekString isEqualToString:self.tuesdayString]) {
        return 3;
    }
    if ([weekString isEqualToString:self.wednesdayString]) {
        return 4;
    }
    if ([weekString isEqualToString:self.thursdayString]) {
        return 5;
    }
    if ([weekString isEqualToString:self.fridayString]) {
        return 6;
    }
    if ([weekString isEqualToString:self.saturdayString]) {
        return 7;
    }
    return 0;
}

- (BOOL)setDayListLogic:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.year == self.maximumComponents.year && self.minimumComponents.month == self.maximumComponents.month) {
        NSInteger min = self.minimumComponents.day;
        NSInteger max = self.maximumComponents.day;
        if (min > max) {
            min = 1;
        }
        NSMutableArray *days = [NSMutableArray array];
        for (NSUInteger i = min; i <= max; i++) {
            [days addObject:[@(i) stringValue]];
        }
        self.dayList = days;
        return refresh;
    }
    
    BOOL tmp = refresh;
    NSString *yearString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.yearString].firstObject;
    dateComponents.year = [yearString integerValue];
    
    NSString *monthString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [monthString integerValue];
    
    NSInteger day = [self howManyDaysWithMonthInThisYear:[yearString integerValue] withMonth:[monthString integerValue]];
    [self setDayListForMonthDays:day];
    if (self.minimumComponents.year == dateComponents.year && self.minimumComponents.month == dateComponents.month) {
        NSMutableArray *days = [NSMutableArray array];
        for (NSUInteger i = self.minimumComponents.day; i <= day; i++) {
            [days addObject:[@(i) stringValue]];
        }
        self.dayList = days;
    }else if (self.maximumComponents.year == dateComponents.year && self.maximumComponents.month == dateComponents.month) {
        NSMutableArray *days = [NSMutableArray array];
        for (NSUInteger i = 1; i <= self.maximumComponents.day; i++) {
            [days addObject:[@(i) stringValue]];
        }
        self.dayList = days;
    }else{
        tmp = false;
        NSMutableArray *days = [NSMutableArray arrayWithCapacity:day];
        for (NSUInteger i = 1; i <= day; i++) {
            [days addObject:[@(i) stringValue]];
        }
        self.dayList = days;
    }
    return tmp;
}

- (BOOL)setHourListLogic:(PGPickerView *)pickerView dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    BOOL tmp = refresh;
    NSInteger length = 23;
    if (self.minimumComponents.month == dateComponents.month && self.minimumComponents.day == dateComponents.day) {
        refresh = true;
        NSInteger index = length - self.minimumComponents.hour;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.hour; i <= length; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }else if (self.maximumComponents.month == dateComponents.month && self.maximumComponents.day == dateComponents.day) {
        refresh = true;
        NSInteger index = self.maximumComponents.hour;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.hour; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }else{
        tmp = false;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }
    return  tmp;
}

- (BOOL)setHourListLogic2:(PGPickerView *)pickerView dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.year == self.maximumComponents.year && self.minimumComponents.month == self.maximumComponents.month && self.minimumComponents.day == self.maximumComponents.day) {
        NSInteger min = self.minimumComponents.hour;
        NSInteger max = self.maximumComponents.hour;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
        return refresh;
    }
    
    NSString *yearString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.yearString].firstObject;
    dateComponents.year = [yearString integerValue];
    
    NSString *monthString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [monthString integerValue];
    
    NSString *dayString = [[self.pickerView textOfSelectedRowInComponent:2] componentsSeparatedByString:self.dayString].firstObject;
    dateComponents.day = [dayString integerValue];
    
    BOOL tmp = refresh;
    NSInteger length = 23;
    if (self.minimumComponents.year == dateComponents.year && self.minimumComponents.month == dateComponents.month && self.minimumComponents.day == dateComponents.day) {
        refresh = true;
        NSInteger index = length - self.minimumComponents.hour;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.hour; i <= length; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }else if (self.maximumComponents.year == dateComponents.year && self.maximumComponents.month == dateComponents.month && self.maximumComponents.day == dateComponents.day) {
        refresh = true;
        NSInteger index = self.maximumComponents.hour;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.hour; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }else{
        tmp = false;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        self.hourList = hours;
    }
    return tmp;
}

- (BOOL)setMinuteListLogic:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.hour == self.maximumComponents.hour) {
        NSInteger min = self.minimumComponents.minute;
        NSInteger max = self.maximumComponents.minute;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i++) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
        return refresh;
    }
    
    NSInteger length = 59;
    BOOL tmp = refresh;
    if (self.minimumComponents.month == dateComponents.month && self.minimumComponents.day == dateComponents.day && self.minimumComponents.hour == dateComponents.hour) {
        refresh = true;
        NSInteger index = length - self.minimumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.minute; i <= length; i++) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else if (self.maximumComponents.month == dateComponents.month && self.maximumComponents.day == dateComponents.day && self.maximumComponents.hour == dateComponents.hour) {
        refresh = true;
        NSInteger index = self.maximumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.minute; i++) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else{
        refresh = false;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i++) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }
    return tmp;
}

- (BOOL)setMinuteListLogic2:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.year == self.maximumComponents.year && self.minimumComponents.month == self.maximumComponents.month && self.minimumComponents.day == self.maximumComponents.day && self.minimumComponents.hour == self.maximumComponents.hour) {
        NSInteger min = self.minimumComponents.minute;
        NSInteger max = self.maximumComponents.minute;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i++) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
        return refresh;
    }
    BOOL tmp = refresh;
    NSString *yearString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.yearString].firstObject;
    dateComponents.year = [yearString integerValue];
    
    NSString *monthString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [monthString integerValue];
    
    NSString *dayString = [[self.pickerView textOfSelectedRowInComponent:2] componentsSeparatedByString:self.dayString].firstObject;
    dateComponents.day = [dayString integerValue];
    
    NSString *hourString = [[self.pickerView textOfSelectedRowInComponent:3] componentsSeparatedByString:self.hourString].firstObject;
    dateComponents.hour = [hourString integerValue];
    
    NSInteger length = 59;
    if (self.minimumComponents.year == dateComponents.year && self.minimumComponents.month == dateComponents.month && self.minimumComponents.day == dateComponents.day && self.minimumComponents.hour == dateComponents.hour) {
        NSInteger index = length - self.minimumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.minute; i <= length; i++) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else if (self.maximumComponents.year == dateComponents.year && self.maximumComponents.month == dateComponents.month && self.maximumComponents.day == dateComponents.day && self.maximumComponents.hour == dateComponents.hour) {
        NSInteger index = self.maximumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.minute; i++) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else{
        tmp = false;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i++) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }
    return tmp;
}

- (BOOL)setMinuteListLogic3:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.hour == self.maximumComponents.hour) {
        NSInteger min = self.minimumComponents.minute;
        NSInteger max = self.maximumComponents.minute;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i++) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
        return refresh;
    }
    
    BOOL tmp = refresh;
    NSInteger length = 59;
    if (self.minimumComponents.hour == dateComponents.hour) {
        NSInteger index = length - self.minimumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.minute; i <= length; i++) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else if (self.maximumComponents.hour == dateComponents.hour) {
        NSInteger index = self.maximumComponents.minute;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.minute; i++) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }else{
        tmp = false;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i++) {
            if (i < 10) {
                [minutes addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [minutes addObject:[@(i) stringValue]];
            }
        }
        self.minuteList = minutes;
    }
    return tmp;
}

- (BOOL)setSecondListLogic:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.hour == self.maximumComponents.hour && self.minimumComponents.minute == self.maximumComponents.minute) {
        NSInteger min = self.minimumComponents.second;
        NSInteger max = self.maximumComponents.second;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i++) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
        return refresh;
    }
    BOOL tmp = refresh;
    NSString *hourString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.hourString].firstObject;
    dateComponents.hour = [hourString integerValue];
    
    NSString *minuteString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.minuteString].firstObject;
    dateComponents.minute = [minuteString integerValue];
    
    NSInteger length = 59;
    if (self.minimumComponents.hour == dateComponents.hour && self.minimumComponents.minute == dateComponents.minute) {
        NSInteger index = length - self.minimumComponents.second;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.second; i <= length; i++) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }else if (self.maximumComponents.hour == dateComponents.hour && self.maximumComponents.minute == dateComponents.minute) {
        NSInteger index = self.maximumComponents.second;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.second; i++) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }else{
        tmp = false;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i++) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }
    return tmp;
}

- (BOOL)setSecondListLogic2:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.year == self.maximumComponents.year && self.minimumComponents.month == self.maximumComponents.month && self.minimumComponents.day == self.maximumComponents.day && self.minimumComponents.hour == self.maximumComponents.hour && self.minimumComponents.minute == self.maximumComponents.minute) {
        NSInteger min = self.minimumComponents.second;
        NSInteger max = self.maximumComponents.second;
        if (min > max) {
            min = 0;
        }
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:max-min];
        for (NSUInteger i = min; i <= max; i++) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
        return refresh;
    }
    BOOL tmp = refresh;
    NSString *yearString = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.yearString].firstObject;
    dateComponents.year = [yearString integerValue];
    
    NSString *monthString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.monthString].firstObject;
    dateComponents.month = [monthString integerValue];
    
    NSString *dayString = [[self.pickerView textOfSelectedRowInComponent:2] componentsSeparatedByString:self.dayString].firstObject;
    dateComponents.day = [dayString integerValue];
    
    NSString *hourString = [[self.pickerView textOfSelectedRowInComponent:3] componentsSeparatedByString:self.hourString].firstObject;
    dateComponents.hour = [hourString integerValue];
    
    NSString *minuteString = [[self.pickerView textOfSelectedRowInComponent:4] componentsSeparatedByString:self.minuteString].firstObject;
    dateComponents.minute = [minuteString integerValue];
    
    NSInteger length = 59;
    if (self.minimumComponents.year == dateComponents.year && self.minimumComponents.month == dateComponents.month && self.minimumComponents.day == dateComponents.day && self.minimumComponents.hour == dateComponents.hour && self.minimumComponents.minute == dateComponents.minute) {
        NSInteger index = length - self.minimumComponents.second;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.second; i <= length; i++) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }else if (self.maximumComponents.year == dateComponents.year && self.maximumComponents.month == dateComponents.month && self.maximumComponents.day == dateComponents.day && self.maximumComponents.hour == dateComponents.hour && self.maximumComponents.minute == dateComponents.minute) {
        NSInteger index = self.maximumComponents.second;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i <= self.maximumComponents.second; i++) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }else{
        tmp = false;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:length];
        for (NSUInteger i = 0; i <= length; i++) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%ld", i]];
            }else {
                [seconds addObject:[@(i) stringValue]];
            }
        }
        self.secondList = seconds;
    }
    return tmp;
}

//在临界值的时候(处于最大/最小值)且component=>2(大于等于3列)的时候需要刷新
- (BOOL)setMonthListLogic:(NSDateComponents *)dateComponents refresh:(BOOL)refresh {
    if (self.minimumComponents.year == self.maximumComponents.year) {
        NSInteger min = self.minimumComponents.month;
        NSInteger max = self.maximumComponents.month;
        if (max < min) {
            min = 1;
        }
        NSMutableArray *months = [NSMutableArray arrayWithCapacity:max - min];
        for (NSUInteger i = min; i <= max; i++) {
            [months addObject:[@(i) stringValue]];
        }
        self.monthList = months;
        return refresh;
    }
    BOOL tmp = refresh;
    if (self.minimumComponents.year == dateComponents.year) {
        NSInteger index = 12 - self.minimumComponents.month;
        NSMutableArray *months = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.month; i <= 12; i++) {
            [months addObject:[@(i) stringValue]];
        }
        self.monthList = months;
    }else if (self.maximumComponents.year == dateComponents.year) {
        NSInteger index = self.maximumComponents.month;
        NSMutableArray *months = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 1; i <= self.maximumComponents.month; i++) {
            [months addObject:[@(i) stringValue]];
        }
        self.monthList = months;
    }else{
        tmp = false;
        NSMutableArray *months = [NSMutableArray arrayWithCapacity:12];
        for (NSUInteger i = 1; i <= 12; i++) {
            [months addObject:[@(i) stringValue]];
        }
        self.monthList = months;
    }
    return tmp;
}

#pragma mark - PGPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(PGPickerView *)pickerView {
    return self.components;
}

- (NSInteger)pickerView:(PGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self rowsInComponent:component];
}

#pragma mark - PGPickerViewDelegate
- (CGFloat)rowHeightInPickerView:(PGPickerView *)pickerView {
    return kTableViewCellHeight;
}

- (void)pickerView:(PGPickerView *)pickerView title:(NSString *)title didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (!_isDelay) {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.26 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            _isDelay = true;
        });
        return;
    }
    row = row + 1;
    NSDateComponents *dateComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    switch (self.datePickerMode) {
        case PGDatePickerModeYearAndMonth:
        {
            NSString *str = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.yearString].firstObject;
            dateComponents.year = [str integerValue];
            if (component == 0) {
                BOOL refresh = [self setMonthListLogic:dateComponents refresh:true];
                [self.pickerView reloadComponent:1 refresh:refresh];
            }
        }
            break;
        case PGDatePickerModeDate:
        {
            NSString *str = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.yearString].firstObject;
            dateComponents.year = [str integerValue];
            if (component == 0) {
                NSString *str = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.monthString].firstObject;
                dateComponents.month = [str integerValue];
                BOOL refresh = [self setMonthListLogic:dateComponents refresh:true];
                [self.pickerView reloadComponent:1 refresh:refresh];
            }
            if (component != 2) {
                BOOL refresh = [self setDayListLogic:pickerView component:component dateComponents:dateComponents refresh:false];
                [self.pickerView reloadComponent:2 refresh:refresh];
            }
        }
            break;
        case PGDatePickerModeDateHourMinute:
        {
            NSString *str = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.yearString].firstObject;
            dateComponents.year = [str integerValue];
            if (component == 0) {
                NSString *monthString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.monthString].firstObject;
                dateComponents.month = [monthString integerValue];
                BOOL refresh = [self setMonthListLogic:dateComponents refresh:true];
                [self.pickerView reloadComponent:1 refresh:refresh];
            }
            
            if (component == 0 || component == 1) {
                BOOL refresh = [self setDayListLogic:pickerView component:component dateComponents:dateComponents refresh:true];
                [self.pickerView reloadComponent:2 refresh:refresh];
            }
            if (component == 0 || component == 1 || component == 2) {
                BOOL refresh = [self setHourListLogic2:pickerView dateComponents:dateComponents refresh:true];
                [self.pickerView reloadComponent:3 refresh:refresh];
            }
            if (component != 4) {
                BOOL refresh = [self setMinuteListLogic2:pickerView component:component dateComponents:dateComponents refresh:true];
                [self.pickerView reloadComponent:4 refresh:refresh];
            }
        }
            break;
        case PGDatePickerModeDateHourMinuteSecond:
        {
            NSString *str = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.yearString].firstObject;
            dateComponents.year = [str integerValue];
            if (component == 0) {
                BOOL refresh = [self setMonthListLogic:dateComponents refresh:true];
                [self.pickerView reloadComponent:1 refresh:refresh];
            }
            if (component == 0 || component == 1) {
                BOOL refresh = [self setDayListLogic:pickerView component:component dateComponents:dateComponents refresh:true];
                [self.pickerView reloadComponent:2 refresh:refresh];
            }
            if (component == 0 || component == 1 || component == 2) {
                BOOL refresh = [self setHourListLogic2:pickerView dateComponents:dateComponents refresh:true];
                [self.pickerView reloadComponent:3 refresh:refresh];
            }
            if (component == 0 || component == 1 || component == 2 || component == 3) {
                BOOL refresh = [self setMinuteListLogic2:pickerView component:component dateComponents:dateComponents refresh:true];
                [self.pickerView reloadComponent:4 refresh:refresh];
            }
            if (component != 5) {
                BOOL refresh = [self setSecondListLogic2:pickerView component:component dateComponents:dateComponents refresh:true];
                [self.pickerView reloadComponent:5 refresh:refresh];
            }
        }
            break;
        case PGDatePickerModeTime:
        {
            NSString *str = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.hourString].firstObject;
            dateComponents.hour = [str integerValue];
            if (component == 0) {
                BOOL refresh = [self setMinuteListLogic:pickerView component:component dateComponents:dateComponents refresh:true];
                [self.pickerView reloadComponent:1 refresh:refresh];
            }
        }
            break;
        case PGDatePickerModeTimeAndSecond:
        {
            NSString *str = [[self.pickerView textOfSelectedRowInComponent:0] componentsSeparatedByString:self.hourString].firstObject;
            dateComponents.hour = [str integerValue];
            if (component == 0) {
                BOOL refresh = [self setMinuteListLogic3:pickerView component:component dateComponents:dateComponents refresh:true];
                [self.pickerView reloadComponent:1 refresh:refresh];
            }
            if (component != 2) {
                BOOL refresh = [self setSecondListLogic:pickerView component:component dateComponents:dateComponents refresh:true];
                [self.pickerView reloadComponent:2 refresh:refresh];
            }
        }
            break;
        case PGDatePickerModeDateAndTime:
        {
            NSString *string = [self.pickerView textOfSelectedRowInComponent:0];
            NSString *str = [string componentsSeparatedByString:self.monthString].firstObject;
            dateComponents.month = [str integerValue];
            NSString *str2 = [string componentsSeparatedByString:self.monthString].lastObject;
            NSString *str3 = [str2 componentsSeparatedByString:self.dayString].firstObject;
            dateComponents.day = [str3 integerValue];
            NSString *str4 = [str2 componentsSeparatedByString:self.dayString].lastObject;
            str4 = [str4 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            dateComponents.weekday = [self weekDayMappingFrom:str4];
            if (component == 0) {
                BOOL refresh = [self setHourListLogic:pickerView dateComponents:dateComponents refresh:true];
                [self.pickerView reloadComponent:1 refresh:refresh];
            }
            if (component != 2) {
                NSString *hourString = [[self.pickerView textOfSelectedRowInComponent:1] componentsSeparatedByString:self.hourString].firstObject;
                dateComponents.hour = [hourString integerValue];
                BOOL refresh = [self setMinuteListLogic:pickerView component:component dateComponents:dateComponents refresh:false];
                [self.pickerView reloadComponent:2 refresh:refresh];
            }
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
        NSInteger day = [self howManyDaysWithMonthInThisYear:self.currentComponents.year withMonth:self.currentComponents.month];
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

- (NSArray *)yearList {
    if (!_yearList) {
        NSInteger index = self.maximumComponents.year - self.minimumComponents.year;
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
        NSInteger minimum = 1;
        NSInteger maximum = 12;
        if (self.currentComponents.year <= self.minimumComponents.year) {
            minimum = self.minimumComponents.month;
        }
        if (self.currentComponents.year >= self.maximumComponents.year) {
            maximum = self.maximumComponents.month;
        }
        if (self.datePickerMode == PGDatePickerModeDateAndTime) {
            minimum = 1;
            maximum = 12;
        }
        if (self.currentComponents.year > self.minimumComponents.year && self.yearList.count == 1) {
            minimum = self.minimumComponents.month;
        }
        
        if (self.yearList.count == 1) {
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
        NSInteger minimum = 0;
        NSInteger maximum = 23;
        
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
        NSInteger minimum = 0;
        NSInteger maximum = 59;
        if (self.selectComponents.year == self.maximumComponents.year &&
            self.selectComponents.month == self.maximumComponents.month &&
            self.selectComponents.day == self.maximumComponents.day &&
            self.selectComponents.hour == self.maximumComponents.hour) {
            maximum = self.maximumComponents.minute;
        }
        if (self.selectComponents.year == self.minimumComponents.year &&
            self.selectComponents.month == self.minimumComponents.month &&
            self.selectComponents.day == self.minimumComponents.day &&
            self.selectComponents.hour == self.minimumComponents.hour) {
            minimum = self.minimumComponents.minute;
        }
        NSInteger index = maximum - minimum;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = minimum; i <= maximum; i++) {
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
        NSInteger minimum = 0;
        NSInteger maximum = 59;
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
        NSInteger index = maximum - minimum;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = minimum; i <= maximum; i++) {
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
        NSInteger firstIndex = self.minimumComponents.month - 1;
        NSInteger lastIndex = self.maximumComponents.month - 1;
        for (NSInteger i = firstIndex; i <= lastIndex; i++) {
            NSString *month = self.monthList[i];
            NSInteger day = [self howManyDaysWithMonthInThisYear:self.currentComponents.year withMonth:[month integerValue]];
            {
                NSMutableArray *days = [NSMutableArray arrayWithCapacity:day];
                NSInteger minDay = 1, maxDay = day;
                if (i == firstIndex) {
                    minDay = self.minimumComponents.day;
                }
                if (i == lastIndex && self.maximumComponents.day != 1) {
                    maxDay = self.maximumComponents.day;
                }
                for (NSUInteger i = minDay; i <= maxDay; i++) {
                    [days addObject:[@(i) stringValue]];
                }
                self.dayList = days;
            }
            [self.dayList enumerateObjectsUsingBlock:^(NSString*  _Nonnull day, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger weekDay = [self.calendar component:NSCalendarUnitWeekday fromDate:[NSDate setYear:self.currentComponents.year month:[month integerValue] day:[day integerValue]]];
                
                NSString *string = [NSString stringWithFormat:@"%@%@%@%@ %@ ", month, self.monthString, day, self.dayString, [self weekMappingFrom:weekDay]];
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
        case PGDatePickerModeDateHourMinute:
            return 5;
        case PGDatePickerModeDateHourMinuteSecond:
            return 6;
        case PGDatePickerModeTime:
            return 2;
        case PGDatePickerModeTimeAndSecond:
            return 3;
        case PGDatePickerModeDateAndTime:
            return 3;
        default:
            break;
    }
    return 0;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc]init];
        [self.headerView addSubview:label];
        label.textColor = [UIColor colorWithHexString:@"#848484"];
        label.font = [UIFont boldSystemFontOfSize:17];
        [label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIView *)headerView {
    if (!_headerView) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kHeaderViewHeight)];
        view.backgroundColor = [UIColor colorWithHexString:@"#F1EDF6"];
        [window addSubview:view];
        _headerView = view;
    }
    return _headerView;
}

- (UIColor *)lineBackgroundColor {
    if (!_lineBackgroundColor) {
        _lineBackgroundColor = [UIColor colorWithHexString:@"#69BDFF"];
    }
    return _lineBackgroundColor;
}

- (UIColor *)textColorOfOtherRow {
    if (!_textColorOfOtherRow) {
        _textColorOfOtherRow = [UIColor grayColor];
    }
    return _textColorOfOtherRow;
}

- (UIColor *)textColorOfSelectedRow {
    if (!_textColorOfSelectedRow) {
        _textColorOfSelectedRow = [UIColor colorWithHexString:@"#69BDFF"];
    }
    return _textColorOfSelectedRow;
}

- (UIColor *)middleTextColor {
    if (!_middleTextColor) {
        _middleTextColor = [UIColor grayColor];
    }
    return _middleTextColor;
}

- (UIFont *)cancelButtonFont {
    if (!_cancelButtonFont) {
        _cancelButtonFont = [UIFont systemFontOfSize:17];
    }
    return _cancelButtonFont;
}

- (NSString *)cancelButtonText {
    if (!_cancelButtonText) {
        _cancelButtonText = [NSBundle localizedStringForKey:@"cancelButtonText"];
    }
    return _cancelButtonText;
}

- (UIColor *)cancelButtonTextColor {
    if (!_cancelButtonTextColor) {
        _cancelButtonTextColor = [UIColor grayColor];
    }
    return _cancelButtonTextColor;
}

- (UIFont *)confirmButtonFont {
    if (!_confirmButtonFont) {
        _confirmButtonFont = [UIFont systemFontOfSize:17];
    }
    return _confirmButtonFont;
}

- (NSString *)confirmButtonText {
    if (!_confirmButtonText) {
        _confirmButtonText = [NSBundle localizedStringForKey:@"confirmButtonText"];
    }
    return _confirmButtonText;
}

- (UIColor *)confirmButtonTextColor {
    if (!_confirmButtonTextColor) {
        _confirmButtonTextColor = [UIColor colorWithHexString:@"#69BDFF"];
    }
    return _confirmButtonTextColor;
}

- (NSString *)yearString {
    if (!_yearString) {
        if (!self.isHiddenMiddleText) {
            _yearString = @"";
        }else {
            _yearString = [NSBundle localizedStringForKey:@"yearString"];
        }
    }
    return _yearString;
}

- (NSString *)middleYearString {
    if (!_middleYearString) {
        _middleYearString = [NSBundle localizedStringForKey:@"yearString"];
    }
    return _middleYearString;
}

- (NSString *)monthString {
    if (!_monthString) {
        if (!self.isHiddenMiddleText) {
            _monthString = @"";
        }else {
            _monthString = [NSBundle localizedStringForKey:@"monthString"];
        }
    }
    return _monthString;
}

- (NSString *)middleMonthString {
    if (!_middleMonthString) {
        _middleMonthString = [NSBundle localizedStringForKey:@"monthString"];
    }
    return _middleMonthString;
}

- (NSString *)dayString {
    if (!_dayString) {
        if (!self.isHiddenMiddleText) {
            _dayString = @"";
        }else {
            _dayString = [NSBundle localizedStringForKey:@"dayString"];
        }
    }
    return _dayString;
}

- (NSString *)middleDayString {
    if (!_middleDayString) {
        _middleDayString = [NSBundle localizedStringForKey:@"dayString"];
    }
    return _middleDayString;
}

- (NSString *)hourString {
    if (!_hourString) {
        if (!self.isHiddenMiddleText) {
            _hourString = @"";
        }else {
            _hourString = [NSBundle localizedStringForKey:@"hourString"];
        }
    }
    return _hourString;
}

- (NSString *)middleHourString {
    if (!_middleHourString) {
        _middleHourString = [NSBundle localizedStringForKey:@"hourString"];
    }
    return _middleHourString;
}

- (NSString *)minuteString {
    if (!_minuteString) {
        if (!self.isHiddenMiddleText) {
            _minuteString = @"";
        }else {
            _minuteString = [NSBundle localizedStringForKey:@"minuteString"];
        }
    }
    return _minuteString;
}

- (NSString *)middleMinuteString {
    if (!_middleMinuteString) {
        _middleMinuteString = [NSBundle localizedStringForKey:@"minuteString"];
    }
    return _middleMinuteString;
}

- (NSString *)secondString {
    if (!_secondString) {
        if (!self.isHiddenMiddleText) {
            _secondString = @"";
        }else {
            _secondString = [NSBundle localizedStringForKey:@"secondString"];
        }
    }
    return _secondString;
}

- (NSString *)middleSecondString {
    if (!_middleSecondString) {
        _middleSecondString = [NSBundle localizedStringForKey:@"secondString"];
    }
    return _middleSecondString;
}

- (NSString *)mondayString {
    if (!_mondayString) {
        _mondayString = [NSBundle localizedStringForKey:@"mondayString"];
    }
    return _mondayString;
}

- (NSString *)tuesdayString {
    if (!_tuesdayString) {
        _tuesdayString = [NSBundle localizedStringForKey:@"tuesdayString"];
    }
    return _tuesdayString;
}

- (NSString *)wednesdayString {
    if (!_wednesdayString) {
        _wednesdayString = [NSBundle localizedStringForKey:@"wednesdayString"];
    }
    return _wednesdayString;
}

- (NSString *)thursdayString {
    if (!_thursdayString) {
        _thursdayString = [NSBundle localizedStringForKey:@"thursdayString"];
    }
    return _thursdayString;
}

- (NSString *)fridayString {
    if (!_fridayString) {
        _fridayString = [NSBundle localizedStringForKey:@"fridayString"];
    }
    return _fridayString;
}

- (NSString *)saturdayString {
    if (!_saturdayString) {
        _saturdayString = [NSBundle localizedStringForKey:@"saturdayString"];
    }
    return _saturdayString;
}

- (NSString *)sundayString {
    if (!_sundayString) {
        _sundayString = [NSBundle localizedStringForKey:@"sundayString"];
    }
    return _sundayString;
}

@end

