//
//  PGDatePicker.m
//  HooDatePickerDemo
//
//  Created by piggybear on 2017/7/25.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "PGDatePicker.h"
#import "PGDatePickerView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTableViewHeight 220
#define kTableViewCellHeight 44
#define kHeaderViewHeight 40

@interface PGDatePicker()<PGPickerViewDelegate, PGPickerViewDataSource>{
    NSDate *_setDate;
    BOOL _setDateAnimation;
    BOOL _maxDate;
}

@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UIButton *confirmButton;
@property (nonatomic, weak) PGPickerView *pickerView;
@property (nonatomic, strong) NSDateComponents *minimumComponents;
@property (nonatomic, strong) NSDateComponents *maximumComponents;
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
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UIView *dismissView;
@property (nonatomic, assign) BOOL isCurrent;

- (NSInteger)rowsInComponent:(NSInteger)component;
@end

static NSString *const reuseIdentifier = @"PGDatePickerView";

@implementation PGDatePicker

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.headerView) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window bringSubviewToFront:self];
        [window bringSubviewToFront:self.headerView];
        [window bringSubviewToFront:self.dismissView];
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
        
        [UIView animateWithDuration:0.3 animations:^{
            self.headerView.frame = CGRectMake(0, kScreenHeight - height - kHeaderViewHeight, kScreenWidth, kHeaderViewHeight);
            self.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreenWidth, height);
        }];
    }
    [self setupPickerView];
}

- (void)setupPickerView {
    NSInteger day = [self howManyDaysWithMonthInThisYear:self.currentComponents.year withMonth:self.currentComponents.month];
    [self setDayListForMonthDays:day];
    PGPickerView *pickerView = [[PGPickerView alloc]initWithFrame:self.bounds];
    pickerView.lineBackgroundColor = self.lineBackgroundColor;
    pickerView.titleColorForSelectedRow = self.titleColorForSelectedRow;
    pickerView.titleColorForOtherRow = self.titleColorForOtherRow;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self addSubview:pickerView];
    self.pickerView = pickerView;
    if (_setDate) {
        [self setDate:_setDate animated:_setDateAnimation];
    }else {
        [self.pickerView selectRow:0 inComponent:0 animated:false];
    }
}

- (void)show {
    self.selectedComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    CGFloat height = kTableViewHeight;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];

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
    
    UIView *dismissView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - height - kHeaderViewHeight)];
    dismissView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelButtonHandler)];
    [dismissView addGestureRecognizer:tap];
    [window addSubview:dismissView];
    self.dismissView = dismissView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    UILabel *label = object;
    NSString *newString = change[@"new"];
    CGSize size = [newString sizeWithAttributes:@{NSFontAttributeName: [label font]}];
    self.titleLabel.frame = CGRectMake(kScreenWidth / 2 - size.width / 2, 0, size.width, kHeaderViewHeight);
}

- (void)cancelButtonHandler {
    self.dismissView.hidden = true;
    CGFloat height = kTableViewHeight;
    [UIView animateWithDuration:0.3 animations:^{
        self.headerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kHeaderViewHeight);
        self.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreenWidth, height);
    } completion:^(BOOL finished) {
        [self.headerView removeFromSuperview];
        [self.dismissView removeFromSuperview];
        [self.titleLabel removeObserver:self forKeyPath:@"text"];
        [self removeFromSuperview];
    }];
}

- (void)confirmButtonHandler {
    switch (self.datePickerMode) {
        case PGDatePickerModeYear:
        {
            NSString *yearString = [self.pickerView currentTitleInComponent:0];
            yearString = [yearString componentsSeparatedByString:@"年"].firstObject;
            self.selectedComponents.year = [yearString integerValue];
        }
            break;
        case PGDatePickerModeYearAndMonth:
        {
            NSString *yearString = [self.pickerView currentTitleInComponent:0];
            yearString = [yearString componentsSeparatedByString:@"年"].firstObject;
            
            NSString *monthString = [self.pickerView currentTitleInComponent:1];
            monthString = [monthString componentsSeparatedByString:@"月"].firstObject;
            
            self.selectedComponents.year = [yearString integerValue];
            self.selectedComponents.month = [monthString integerValue];
        }
            break;
        case PGDatePickerModeDate:
        {
            NSString *yearString = [self.pickerView currentTitleInComponent:0];
            yearString = [yearString componentsSeparatedByString:@"年"].firstObject;
            
            NSString *monthString = [self.pickerView currentTitleInComponent:1];
            monthString = [monthString componentsSeparatedByString:@"月"].firstObject;
            
            NSString *dayString = [self.pickerView currentTitleInComponent:2];
            dayString = [dayString componentsSeparatedByString:@"日"].firstObject;
            
            self.selectedComponents.year = [yearString integerValue];
            self.selectedComponents.month = [monthString integerValue];
            self.selectedComponents.day = [dayString integerValue];
        }
            break;
        case PGDatePickerModeTime:
        {
            NSString *hourString = [self.pickerView currentTitleInComponent:0];
            hourString = [hourString componentsSeparatedByString:@"时"].firstObject;
            
            NSString *minuteString = [self.pickerView currentTitleInComponent:1];
            minuteString = [minuteString componentsSeparatedByString:@"分"].firstObject;
            
            self.selectedComponents.hour = [hourString integerValue];
            self.selectedComponents.minute = [minuteString integerValue];
        }
            break;
        case PGDatePickerModeDateAndTime:
        {
            NSString *string = [self.pickerView currentTitleInComponent:0];
            NSString *str = [string componentsSeparatedByString:@"月"].firstObject;
            self.selectedComponents.month = [str integerValue];
            NSString *str2 = [string componentsSeparatedByString:@"月"].lastObject;
            NSString *str3 = [str2 componentsSeparatedByString:@"日"].firstObject;
            self.selectedComponents.day = [str3 integerValue];
            NSString *str4 = [str2 componentsSeparatedByString:@"日"].lastObject;
            str4 = [str4 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.selectedComponents.weekday = [self weekDayMappingFrom:str4];
            
            NSString *hourString = [self.pickerView currentTitleInComponent:1];
            hourString = [hourString componentsSeparatedByString:@"时"].firstObject;
            
            NSString *minuteString = [self.pickerView currentTitleInComponent:2];
            minuteString = [minuteString componentsSeparatedByString:@"分"].firstObject;
            
            self.selectedComponents.hour = [hourString integerValue];
            self.selectedComponents.minute = [minuteString integerValue];
        }
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePicker:didSelectDate:)]) {
        [self.delegate datePicker:self didSelectDate:self.selectedComponents];
    }
    [self cancelButtonHandler];
}

- (void)selectYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSInteger)hour minute:(NSInteger)minute animated:(BOOL)animated {
    switch (self.datePickerMode) {
        case PGDatePickerModeYear:
        {
            if (year >= self.minimumComponents.year && year <= self.maximumComponents.year) {
                NSInteger row = year - self.minimumComponents.year;
                [self.pickerView selectRow:row inComponent:0 animated:animated];
            }
        }
            break;
        case PGDatePickerModeYearAndMonth:
        {
            if (year >= self.minimumComponents.year && year <= self.maximumComponents.year) {
                NSInteger row = year - self.minimumComponents.year;
                [self.pickerView selectRow:row inComponent:0 animated:animated];
            }
            if (month >= self.minimumComponents.month && month <= self.maximumComponents.month) {
                NSInteger row = month - self.minimumComponents.month;
                [self.pickerView selectRow:row inComponent:1 animated:animated];
            }
        }
            break;
        case PGDatePickerModeDate:
        {
            if (year >= self.minimumComponents.year && year <= self.maximumComponents.year) {
                NSInteger row = year - self.minimumComponents.year;
                [self.pickerView selectRow:row inComponent:0 animated:animated];
            }
            if (month >= self.minimumComponents.month && month <= self.maximumComponents.month) {
                NSInteger row = month - self.minimumComponents.month;
                [self.pickerView selectRow:row inComponent:1 animated:animated];
            }
            NSInteger maxDay = 31;
            if (self.maximumDate) {
                maxDay = self.maximumComponents.day;
            }
            if (day >= self.minimumComponents.day && day <= maxDay) {
                NSInteger row = day - self.minimumComponents.day;
                [self.pickerView selectRow:row inComponent:2 animated:animated];
            }
        }
            break;
        case PGDatePickerModeTime:
        {
            if (hour >= self.minimumComponents.hour && hour <= self.maximumComponents.hour) {
                NSInteger row = hour - self.minimumComponents.hour;
                [self.pickerView selectRow:row inComponent:0 animated:animated];
            }
            if (minute >= self.minimumComponents.minute && minute <= self.maximumComponents.minute) {
                NSInteger row = minute - self.minimumComponents.minute;
                [self.pickerView selectRow:row inComponent:1 animated:animated];
            }
        }
            break;
        case PGDatePickerModeDateAndTime:
        {
            NSInteger weekDay = [self.calendar component:NSCalendarUnitWeekday fromDate:[NSDate setYear:year month:month day:day]];
            NSString *string = [NSString stringWithFormat:@"%ld月%ld日 %@ ", month, day, [self weekMappingFrom:weekDay]];
            NSInteger row = [self.dateAndTimeList indexOfObject:string];
            [self.pickerView selectRow:row inComponent:0 animated:animated];
            if (hour >= self.minimumComponents.hour) {
                NSInteger row = hour - self.minimumComponents.hour;
                [self.pickerView selectRow:row inComponent:1 animated:animated];
            }
            if (minute >= self.minimumComponents.minute) {
                NSInteger row = minute - self.minimumComponents.minute;
                [self.pickerView selectRow:row inComponent:2 animated:animated];
            }
        }
            break;
        default:
            break;
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
        case PGDatePickerModeTime:
        {
            if (component == 1) {
                return self.minuteList.count;
            }
            return self.hourList.count;
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

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    _setDate = date;
    _setDateAnimation = animated;
    NSDateComponents *components = [self.calendar components:self.unitFlags fromDate:date];
    [self selectYear:components.year month:components.month day:components.day hour:components.hour minute:components.minute animated:animated];
}

- (void)setDayListForMonthDays:(NSInteger)day {
    if (!_maxDate) {
        [self.maximumComponents setDay:1];
    }
    NSMutableArray *days = [NSMutableArray arrayWithCapacity:day];
    NSInteger minDay = self.minimumComponents.day, maxDay = self.maximumComponents.day;
    if (maxDay == 1) {
        maxDay = day;
        [self.maximumComponents setDay:day];
    }else {
        _maxDate = true;
    }
    NSInteger index = maxDay - minDay;
    if (index < 0) {
        //        NSLog(@"minimumDate can not greater than maximumDate");
        minDay = 1;
        maxDay = day;
        [self.maximumComponents setDay:day];
    }
    for (NSUInteger i = minDay; i <= maxDay; i++) {
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
            return @"周日";
        case 2:
            return @"周一";
        case 3:
            return @"周二";
        case 4:
            return @"周三";
        case 5:
            return @"周四";
        case 6:
            return @"周五";
        case 7:
            return @"周六";
        default:
            break;
    }
    return nil;
}

- (NSInteger)weekDayMappingFrom:(NSString *)weekString {
    if ([weekString isEqualToString:@"周日"]) {
        return 1;
    }
    if ([weekString isEqualToString:@"周一"]) {
        return 2;
    }
    if ([weekString isEqualToString:@"周二"]) {
        return 3;
    }
    if ([weekString isEqualToString:@"周三"]) {
        return 4;
    }
    if ([weekString isEqualToString:@"周四"]) {
        return 5;
    }
    if ([weekString isEqualToString:@"周五"]) {
        return 6;
    }
    if ([weekString isEqualToString:@"周六"]) {
        return 7;
    }
    return 0;
}

- (void)setDayListLogic:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents {
    if (component != 2) {
        NSInteger row = [pickerView selectedRowInComponent:0];
        if (dateComponents.month == 0) {
            dateComponents.month = self.minimumComponents.month;
        }
        if (component == 1) {
            NSInteger row = [pickerView selectedRowInComponent:1];
            NSString *str = [[pickerView titleForSelectedRow:row inComponent:1] componentsSeparatedByString:@"月"].firstObject;
            dateComponents.month = [str integerValue];
        }
        
        NSString *yearString = [pickerView titleForSelectedRow:row inComponent:0];
        yearString = [yearString stringByReplacingOccurrencesOfString:@"年" withString:@""];
        NSString *monthString = [pickerView titleForSelectedRow:row inComponent:1];
        monthString = [monthString stringByReplacingOccurrencesOfString:@"月" withString:@""];
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
            NSMutableArray *days = [NSMutableArray arrayWithCapacity:day];
            for (NSUInteger i = 1; i <= day; i++) {
                [days addObject:[@(i) stringValue]];
            }
            self.dayList = days;
        }
        [self.pickerView reloadComponent:2];
    }
}

- (void)setMinuteListLogic:(PGPickerView *)pickerView component:(NSInteger)component dateComponents:(NSDateComponents *)dateComponents {
    if (component != 2) {
        if (dateComponents.hour == 0) {
            dateComponents.hour = self.minimumComponents.hour;
        }
        if (component == 1) {
            NSInteger row = [pickerView selectedRowInComponent:1];
            NSString *str = [[pickerView titleForSelectedRow:row inComponent:1] componentsSeparatedByString:@"时"].firstObject;
            dateComponents.hour = [str integerValue];
        }
        NSInteger length = 59;
        if (self.minimumComponents.month == dateComponents.month && self.minimumComponents.day == dateComponents.day && self.minimumComponents.hour == dateComponents.hour) {
            NSInteger index = length - self.minimumComponents.minute;
            NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
            for (NSUInteger i = self.minimumComponents.minute; i <= length; i++) {
                [minutes addObject:[@(i) stringValue]];
            }
            self.minuteList = minutes;
        }else if (self.maximumComponents.month == dateComponents.month && self.maximumComponents.day == dateComponents.day && self.maximumComponents.hour == dateComponents.hour) {
            NSInteger index = self.maximumComponents.minute;
            NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
            for (NSUInteger i = 0; i <= self.maximumComponents.minute; i++) {
                [minutes addObject:[@(i) stringValue]];
            }
            self.minuteList = minutes;
        }else{
            NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:length];
            for (NSUInteger i = 0; i <= length; i++) {
                [minutes addObject:[@(i) stringValue]];
            }
            self.minuteList = minutes;
        }
        [self.pickerView reloadComponent:2];
    }
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
    NSDateComponents *dateComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    NSDateComponents *currentComponents = [self.calendar components:self.unitFlags fromDate:[NSDate date]];
    switch (self.datePickerMode) {
        case PGDatePickerModeYear:
        {
            NSString *str = [title componentsSeparatedByString:@"年"].firstObject;
            dateComponents.year = [str integerValue];
            if (_setDate) {
                NSDateComponents *components = [self.calendar components:self.unitFlags fromDate:_setDate];
                [self.pickerView selectRow:components.year inComponent:0 animated:_setDateAnimation];
                return;
            }
            if (_setDate && !self.isCurrent) {
                self.isCurrent = true;
                NSDateComponents *components = [self.calendar components:self.unitFlags fromDate:_setDate];
                [self.pickerView selectRow:components.year inComponent:0 animated:_setDateAnimation];
                return;
            }
            if (!self.isCurrent) {
                self.isCurrent = true;
                if (currentComponents.year >= self.minimumComponents.year) {
                    NSString *string = [NSString stringWithFormat:@"%ld", currentComponents.year];
                    NSInteger row = [self.yearList indexOfObject:string];
                    [self.pickerView selectRow:row inComponent:0 animated:false];
                }
            }
        }
            
            break;
        case PGDatePickerModeYearAndMonth:
        {
            NSString *str = [[self.pickerView currentTitleInComponent:0] componentsSeparatedByString:@"年"].firstObject;
            dateComponents.year = [str integerValue];
            if (component == 0) {
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
                    NSMutableArray *months = [NSMutableArray arrayWithCapacity:12];
                    for (NSUInteger i = 1; i <= 12; i++) {
                        [months addObject:[@(i) stringValue]];
                    }
                    self.monthList = months;
                }
                [self.pickerView reloadComponent:1];
            }
            if (_setDate && !self.isCurrent) {
                self.isCurrent = true;
                NSDateComponents *components = [self.calendar components:self.unitFlags fromDate:_setDate];
                [self.pickerView selectRow:components.year-1 inComponent:0 animated:_setDateAnimation];
                [self.pickerView selectRow:components.month-1 inComponent:1 animated:_setDateAnimation];
                return;
            }
            if (!self.isCurrent) {
                self.isCurrent = true;
                if (currentComponents.year >= self.minimumComponents.year) {
                    NSString *string = [NSString stringWithFormat:@"%ld", currentComponents.year];
                    NSInteger row = [self.yearList indexOfObject:string];
                    [self.pickerView selectRow:row inComponent:0 animated:false];
                    {
                        NSString *string = [NSString stringWithFormat:@"%ld", currentComponents.month];
                        NSInteger row = [self.monthList indexOfObject:string];
                        [self.pickerView selectRow:row inComponent:1 animated:false];
                    }
                }
            }
        }
            break;
        case PGDatePickerModeDate:
        {
            NSString *str = [[self.pickerView currentTitleInComponent:0] componentsSeparatedByString:@"年"].firstObject;
            dateComponents.year = [str integerValue];
            if (component != 1) {
                NSString *str = [[self.pickerView currentTitleInComponent:1] componentsSeparatedByString:@"月"].firstObject;
                dateComponents.month = [str integerValue];
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
                    NSMutableArray *months = [NSMutableArray arrayWithCapacity:12];
                    for (NSUInteger i = 1; i <= 12; i++) {
                        [months addObject:[@(i) stringValue]];
                    }
                    self.monthList = months;
                }
                [self.pickerView reloadComponent:1 currentRow:^(NSInteger row) {
                    if (row == 0) {
                        dateComponents.month = row;
                    }else {
                        dateComponents.month = row + 1;
                    }
                }];
            }
            [self setDayListLogic:pickerView component:component dateComponents:dateComponents];
            if (_setDate && !self.isCurrent) {
                self.isCurrent = true;
                NSDateComponents *components = [self.calendar components:self.unitFlags fromDate:_setDate];
                [self.pickerView selectRow:components.year inComponent:0 animated:_setDateAnimation];
                [self.pickerView selectRow:components.month-1 inComponent:1 animated:_setDateAnimation];
                [self.pickerView selectRow:components.day-1 inComponent:2 animated:_setDateAnimation];
                return;
            }
            if (!self.isCurrent) {
                self.isCurrent = true;
                if (currentComponents.year >= self.minimumComponents.year) {
                    NSString *string = [NSString stringWithFormat:@"%ld", currentComponents.year];
                    NSInteger row = [self.yearList indexOfObject:string];
                    [self.pickerView selectRow:row inComponent:0 animated:false];
                    {
                        NSString *string = [NSString stringWithFormat:@"%ld", currentComponents.month];
                        NSInteger row = [self.monthList indexOfObject:string];
                        [self.pickerView selectRow:row inComponent:1 animated:false];
                    }
                    {
                        NSString *string = [NSString stringWithFormat:@"%ld", currentComponents.day];
                        NSInteger row = [self.dayList indexOfObject:string];
                        [self.pickerView selectRow:row inComponent:2 animated:false];
                    }
                }
            }
        }
            break;
        case PGDatePickerModeTime:
        {
            NSString *str = [[self.pickerView currentTitleInComponent:0] componentsSeparatedByString:@"时"].firstObject;
            dateComponents.hour = [str integerValue];
            if (component == 0) {
                NSUInteger length = 59;
                if (self.minimumComponents.hour == dateComponents.hour) {
                    NSInteger index = length - self.minimumComponents.minute;
                    NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
                    for (NSUInteger i = self.minimumComponents.minute; i <= length; i++) {
                        [minutes addObject:[@(i) stringValue]];
                    }
                    self.minuteList = minutes;
                }else if (self.maximumComponents.hour == dateComponents.hour) {
                    NSInteger index = self.maximumComponents.minute;
                    NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
                    for (NSUInteger i = 0; i <= self.maximumComponents.minute; i++) {
                        [minutes addObject:[@(i) stringValue]];
                    }
                    self.minuteList = minutes;
                }else{
                    NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:length];
                    for (NSUInteger i = 0; i <= length; i++) {
                        [minutes addObject:[@(i) stringValue]];
                    }
                    self.minuteList = minutes;
                }
                [self.pickerView reloadComponent:1];
            }
            if (_setDate && !self.isCurrent) {
                self.isCurrent = true;
                NSDateComponents *components = [self.calendar components:self.unitFlags fromDate:_setDate];
                [self.pickerView selectRow:components.hour inComponent:0 animated:_setDateAnimation];
                [self.pickerView selectRow:components.minute inComponent:1 animated:_setDateAnimation];
                return;
            }
            if (!self.isCurrent) {
                self.isCurrent = true;
                if (currentComponents.hour >= self.minimumComponents.hour) {
                    NSString *string = [NSString stringWithFormat:@"%ld", currentComponents.hour];
                    NSInteger row = [self.hourList indexOfObject:string];
                    [self.pickerView selectRow:row inComponent:0 animated:false];
                    {
                        NSString *string = [NSString stringWithFormat:@"%ld", currentComponents.minute];
                        NSInteger row = [self.minuteList indexOfObject:string];
                        [self.pickerView selectRow:row inComponent:1 animated:false];
                    }
                }
            }
        }
            break;
        case PGDatePickerModeDateAndTime:
        {
            NSString *string = [self.pickerView currentTitleInComponent:0];
            NSString *str = [string componentsSeparatedByString:@"月"].firstObject;
            dateComponents.month = [str integerValue];
            NSString *str2 = [string componentsSeparatedByString:@"月"].lastObject;
            NSString *str3 = [str2 componentsSeparatedByString:@"日"].firstObject;
            dateComponents.day = [str3 integerValue];
            NSString *str4 = [str2 componentsSeparatedByString:@"日"].lastObject;
            str4 = [str4 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            dateComponents.weekday = [self weekDayMappingFrom:str4];
            if (component != 1) {
                NSInteger row = [pickerView selectedRowInComponent:1];
                NSString *str = [[pickerView titleForSelectedRow:row inComponent:1] componentsSeparatedByString:@"时"].firstObject;
                dateComponents.hour = [str integerValue];
                NSInteger length = 23;
                if (self.minimumComponents.month == dateComponents.month && self.minimumComponents.day == dateComponents.day) {
                    NSInteger index = length - self.minimumComponents.hour;
                    NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
                    for (NSUInteger i = self.minimumComponents.hour; i <= length; i++) {
                        [hours addObject:[@(i) stringValue]];
                    }
                    self.hourList = hours;
                }else if (self.maximumComponents.month == dateComponents.month && self.maximumComponents.day == dateComponents.day) {
                    NSInteger index = self.maximumComponents.hour;
                    NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
                    for (NSUInteger i = 0; i <= self.maximumComponents.hour; i++) {
                        [hours addObject:[@(i) stringValue]];
                    }
                    self.hourList = hours;
                }else{
                    NSMutableArray *hours = [NSMutableArray arrayWithCapacity:length];
                    for (NSUInteger i = 0; i <= length; i++) {
                        [hours addObject:[@(i) stringValue]];
                    }
                    self.hourList = hours;
                }
                [self.pickerView reloadComponent:1 currentRow:^(NSInteger row) {
                    if (row == 0) {
                        dateComponents.hour = row;
                    }else {
                        dateComponents.hour = row + 1;
                    }
                }];
            }
            [self setMinuteListLogic:pickerView component:component dateComponents:dateComponents];
            if (_setDate && !self.isCurrent) {
                self.isCurrent = true;
                NSDateComponents *components = [self.calendar components:self.unitFlags fromDate:_setDate];
                NSString *string = [NSString stringWithFormat:@"%ld月%ld日 %@ ", components.month, components.day, [self weekMappingFrom:components.weekday]];
                NSInteger row = [self.dateAndTimeList indexOfObject:string];
                [self.pickerView selectRow:row inComponent:0 animated:_setDateAnimation];
                [self.pickerView selectRow:components.hour inComponent:1 animated:_setDateAnimation];
                [self.pickerView selectRow:components.minute inComponent:2 animated:_setDateAnimation];
                return;
            }
            if (!self.isCurrent) {
                self.isCurrent = true;
                NSString *string = [NSString stringWithFormat:@"%ld月%ld日 %@ ", currentComponents.month, currentComponents.day, [self weekMappingFrom:currentComponents.weekday]];
                NSInteger row = [self.dateAndTimeList indexOfObject:string];
                [self.pickerView selectRow:row inComponent:0 animated:false];
                {
                    NSString *string = [NSString stringWithFormat:@"%ld", currentComponents.hour];
                    NSInteger row = [self.hourList indexOfObject:string];
                    [self.pickerView selectRow:row inComponent:1 animated:false];
                }
                {
                    NSString *string = [NSString stringWithFormat:@"%ld", currentComponents.minute];
                    NSInteger row = [self.minuteList indexOfObject:string];
                    [self.pickerView selectRow:row inComponent:2 animated:false];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (NSString *)pickerView:(PGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (self.datePickerMode) {
        case PGDatePickerModeYear:
            return [self.yearList[row] stringByAppendingString:@"年"];
        case PGDatePickerModeYearAndMonth:
        {
            if (component == 1) {
                return [self.monthList[row] stringByAppendingString:@"月"];
            }
            return [self.yearList[row] stringByAppendingString:@"年"];
        }
        case PGDatePickerModeDate:
        {
            if (component == 1) {
                return [self.monthList[row] stringByAppendingString:@"月"];
            }
            if (component == 2) {
                return [self.dayList[row] stringByAppendingString:@"日"];
            }
            return [self.yearList[row] stringByAppendingString:@"年"];
        }
        case PGDatePickerModeTime:
        {
            if (component == 1) {
                return [self.minuteList[row] stringByAppendingString:@"分"];
            }
            return [self.hourList[row] stringByAppendingString:@"时"];
        }
        case PGDatePickerModeDateAndTime:
        {
            if (component == 1) {
                return [self.hourList[row] stringByAppendingString:@"时"];
            }
            if (component == 2) {
                return [self.minuteList[row] stringByAppendingString:@"分"];
            }
            return self.dateAndTimeList[row];
        }
        default:
            break;
    }
    return @"";
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
    }
    return _minimumComponents;
}

- (NSDateComponents *)maximumComponents {
    if (self.maximumDate) {
        _maximumComponents = [self.calendar components:self.unitFlags fromDate:self.maximumDate];
    }else {
        _maximumComponents = [self.calendar components:self.unitFlags fromDate:[NSDate distantFuture]];
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
        NSInteger index = 12;
        NSMutableArray *months = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 1; i <= index; i++) {
            [months addObject:[@(i) stringValue]];
        }
        _monthList = months;
    }
    return _monthList;
}

- (NSArray *)hourList {
    if (!_hourList) {
        NSInteger index = 24;
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i < index; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        _hourList = hours;
    }
    return _hourList;
}

- (NSArray *)minuteList {
    if (!_minuteList) {
        NSInteger index = 60;
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i < index; i++) {
            [minutes addObject:[@(i) stringValue]];
        }
        _minuteList = minutes;
    }
    return _minuteList;
}

- (NSArray *)secondList {
    if (!_secondList) {
        NSInteger index = 60;
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = 0; i < index; i++) {
            [seconds addObject:[@(i) stringValue]];
        }
        _secondList = seconds;
    }
    return _secondList;
}

- (NSArray *)dateAndTimeList {
    if (!_dateAndTimeList) {
        NSMutableArray *array = [NSMutableArray array];
        [self.monthList enumerateObjectsUsingBlock:^(NSString*  _Nonnull month, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger day = [self howManyDaysWithMonthInThisYear:self.currentComponents.year withMonth:[month integerValue]];
            {
                NSMutableArray *days = [NSMutableArray arrayWithCapacity:day];
                NSInteger minDay = 1, maxDay = day;
                for (NSUInteger i = minDay; i <= maxDay; i++) {
                    [days addObject:[@(i) stringValue]];
                }
                self.dayList = days;
            }
            [self.dayList enumerateObjectsUsingBlock:^(NSString*  _Nonnull day, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger weekDay = [self.calendar component:NSCalendarUnitWeekday fromDate:[NSDate setYear:self.currentComponents.year month:[month integerValue] day:[day integerValue]]];
                NSString *string = [NSString stringWithFormat:@"%@月%@日 %@ ", month, day, [self weekMappingFrom:weekDay]];
                [array addObject:string];
            }];
        }];
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
        case PGDatePickerModeTime:
            return 2;
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

- (UIColor *)titleColorForOtherRow {
    if (!_titleColorForOtherRow) {
        _titleColorForOtherRow = [UIColor grayColor];
    }
    return _titleColorForOtherRow;
}

- (UIColor *)titleColorForSelectedRow {
    if (!_titleColorForSelectedRow) {
        _titleColorForSelectedRow = [UIColor colorWithHexString:@"#69BDFF"];
    }
    return _titleColorForSelectedRow;
}

- (UIFont *)cancelButtonFont {
    if (!_cancelButtonFont) {
        _cancelButtonFont = [UIFont systemFontOfSize:17];
    }
    return _cancelButtonFont;
}

- (NSString *)cancelButtonText {
    if (!_cancelButtonText) {
        _cancelButtonText = @"取消";
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
        _confirmButtonText = @"确定";
    }
    return _confirmButtonText;
}

- (UIColor *)confirmButtonTextColor {
    if (!_confirmButtonTextColor) {
        _confirmButtonTextColor = [UIColor colorWithHexString:@"#69BDFF"];
    }
    return _confirmButtonTextColor;
}

@end

