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

@interface PGDatePicker()<PGPickerViewDelegate, PGPickerViewDataSource>{
    NSDate *_setDate;
    BOOL _setDateAnimation;
    BOOL _maxDate;
    BOOL _isSetDate;
}

@property (nonatomic, weak) PGPickerView *pickerView;
@property (nonatomic, strong) NSDateComponents *minimumComponents;
@property (nonatomic, strong) NSDateComponents *maximumComponents;
@property (nonatomic, strong) NSDateComponents *selectedComponents;
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
        CGFloat height1 = 40;
        [UIView animateWithDuration:0.3 animations:^{
            self.headerView.frame = CGRectMake(0, kScreenHeight - height - height1, kScreenWidth, height1);
            self.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreenWidth, height);
        }];
    }
    [self setupPickerView];
}

- (void)setupPickerView {
    NSInteger day = [self howManyDaysWithMonthInThisYear:[self.calendar currentComponents].year withMonth:[self.calendar currentComponents].month];
    [self setDayListForMonthDays:day];
    PGPickerView *pickerView = [[PGPickerView alloc]initWithFrame:self.bounds];
    pickerView.lineBackgroundColor = self.lineBackgroundColor;
    pickerView.titleColorForSelectedRow = self.titleColorForSelectedRow;
    pickerView.titleColorForOtherRow = self.titleColorForOtherRow;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self addSubview:pickerView];
    _isSetDate = true;
    self.pickerView = pickerView;
    if (_setDate) {
        [self setDate:_setDate animated:_setDateAnimation];
    }else {
        [self selectCurrentDate];
    }
}

- (void)show {
    self.lineBackgroundColor = [UIColor colorWithHexString:@"#69BDFF"];
    self.titleColorForSelectedRow = [UIColor colorWithHexString:@"#69BDFF"];
    self.titleColorForOtherRow = [UIColor grayColor];
    CGFloat height = kTableViewHeight;
    CGFloat height1 = 40;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, height1)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F1EDF6"];
    [window addSubview:view];
    self.headerView = view;
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY (view.frame), kScreenWidth, height);
    self.frame = frame;
    self.backgroundColor = [UIColor whiteColor];
    [window addSubview:self];
    
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    label.textColor = [UIColor colorWithHexString:@"#848484"];
    label.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel = label;
    [self.titleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, height1)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancel];
    self.cancelButton = cancel;
    
    UIButton *confirm = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 60, 0, 50, height1)];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor colorWithHexString:@"#69BDFF"] forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirmButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirm];
    self.confirmButton = confirm;
    
    UIView *dismissView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - height - height1)];
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
    self.titleLabel.frame = CGRectMake(kScreenWidth / 2 - size.width / 2, 0, size.width, 40);
}

- (void)cancelButtonHandler {
    self.dismissView.hidden = true;
    CGFloat height = kTableViewHeight;
    CGFloat height1 = 40;
    [UIView animateWithDuration:0.3 animations:^{
        self.headerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, height1);
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
            if (hour >= self.minimumComponents.hour && hour <= self.maximumComponents.hour) {
                NSInteger row = hour - self.minimumComponents.hour;
                [self.pickerView selectRow:row inComponent:1 animated:animated];
            }
            if (minute >= self.minimumComponents.minute && minute <= self.maximumComponents.minute) {
                NSInteger row = minute - self.minimumComponents.minute;
                [self.pickerView selectRow:row inComponent:2 animated:animated];
            }
        }
            break;
        default:
            break;
    }
}

- (void)selectCurrentDate {
    NSInteger currentYear = [self.calendar currentComponents].year;
    NSInteger currentMonth = [self.calendar currentComponents].month;
    NSInteger currentDay = [self.calendar currentComponents].day;
    NSInteger currentHour = [self.calendar currentComponents].hour;
    NSInteger currentMinute = [self.calendar currentComponents].minute;
    [self selectYear:currentYear month:currentMonth day:currentDay hour:currentHour minute:currentMinute animated:false];
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
    [self.pickerView reloadAllComponents];
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
            NSInteger index = day - self.minimumComponents.day;
            if (index < 0) {
//                NSAssert(index < 0, @"minimumDate can not greater than maximumDate");
            }
            NSMutableArray *days = [NSMutableArray arrayWithCapacity:index];
            for (NSUInteger i = self.minimumComponents.day; i <= day; i++) {
                [days addObject:[@(i) stringValue]];
            }
            self.dayList = days;
        }else if (self.maximumComponents.year == dateComponents.year && self.maximumComponents.month == dateComponents.month) {
            NSInteger index = self.maximumComponents.day;
            NSMutableArray *days = [NSMutableArray arrayWithCapacity:index];
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
        }
            
            break;
        case PGDatePickerModeYearAndMonth:
        {
            {
                NSInteger row = [pickerView selectedRowInComponent:0];
                NSString *str = [[pickerView titleForSelectedRow:row inComponent:0] componentsSeparatedByString:@"年"].firstObject;
                dateComponents.year = [str integerValue];
            }
            {
                NSInteger row = [pickerView selectedRowInComponent:1];
                NSString *str = [[pickerView titleForSelectedRow:row inComponent:1] componentsSeparatedByString:@"月"].firstObject;
                dateComponents.month = [str integerValue];
            }
            if (_isSetDate) {
                if (component != 0) {
                    return;
                }else {
                    _isSetDate = false;
                }
            }
            if (component == 0) {
                if (self.minimumComponents.year == dateComponents.year) {
                    NSInteger index = 12 - self.minimumComponents.month;
                    if (index < 0) {
//                        NSAssert(index < 0, @"minimumDate can not greater than maximumDate");
                    }
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
                if (!self.isCurrent && currentComponents.year == dateComponents.year) {
                    self.isCurrent = true;
                    [self.pickerView selectRow:currentComponents.month - 1 inComponent:1 animated:false];
                }
            }
        }
            break;
        case PGDatePickerModeDate:
        {
            {
                NSInteger row = [pickerView selectedRowInComponent:0];
                NSString *str = [[pickerView titleForSelectedRow:row inComponent:0] componentsSeparatedByString:@"年"].firstObject;
                dateComponents.year = [str integerValue];
            }
            if (component != 1) {
                NSInteger row = [pickerView selectedRowInComponent:1];
                NSString *str = [[pickerView titleForSelectedRow:row inComponent:1] componentsSeparatedByString:@"月"].firstObject;
                dateComponents.month = [str integerValue];
                if (self.minimumComponents.year == dateComponents.year) {
                    NSInteger index = 12 - self.minimumComponents.month;
                    if (index < 0) {
//                        NSAssert(index < 0, @"minimumDate can not greater than maximumDate");
                    }
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
                if (!self.isCurrent) {
                    self.isCurrent = true;
                    [self.pickerView selectRow:currentComponents.month - 1 inComponent:1 animated:false];
                    [self.pickerView selectRow:currentComponents.day - 1 inComponent:2 animated:false];
                }
            }
            {
                NSInteger row = [pickerView selectedRowInComponent:2];
                NSString *str = [[pickerView titleForSelectedRow:row inComponent:2] componentsSeparatedByString:@"日"].firstObject;
                dateComponents.day = [str integerValue];
            }
            [self setDayListLogic:pickerView component:component dateComponents:dateComponents];
            if (_isSetDate) {
                if (component != 0) {
                    return;
                }else {
                    _isSetDate = false;
                }
            }
        }
            break;
        case PGDatePickerModeTime:
        {
            {
                NSInteger row = [pickerView selectedRowInComponent:0];
                NSString *str = [[pickerView titleForSelectedRow:row inComponent:0] componentsSeparatedByString:@"时"].firstObject;
                dateComponents.hour = [str integerValue];
            }
            {
                NSInteger row = [pickerView selectedRowInComponent:1];
                NSString *str = [[pickerView titleForSelectedRow:row inComponent:1] componentsSeparatedByString:@"分"].firstObject;
                dateComponents.minute = [str integerValue];
            }
            if (_isSetDate) {
                if (component != 0) {
                    return;
                }else {
                    _isSetDate = false;
                }
            }
        }
            break;
        case PGDatePickerModeDateAndTime:
        {
            NSInteger row = [pickerView selectedRowInComponent:0];
            NSString *str = [[pickerView titleForSelectedRow:row inComponent:0] componentsSeparatedByString:@"月"].firstObject;
            dateComponents.month = [str integerValue];
            NSString *str2 = [[pickerView titleForSelectedRow:row inComponent:0] componentsSeparatedByString:@"月"].lastObject;
            NSString *str3 = [str2 componentsSeparatedByString:@"日"].firstObject;
            dateComponents.day = [str3 integerValue];
            NSString *str4 = [str2 componentsSeparatedByString:@"日"].lastObject;
            str4 = [str4 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            dateComponents.weekday = [self weekDayMappingFrom:str4];
        }
        {
            NSInteger row = [pickerView selectedRowInComponent:1];
            NSString *str = [[pickerView titleForSelectedRow:row inComponent:1] componentsSeparatedByString:@"时"].firstObject;
            dateComponents.hour = [str integerValue];
        }
        {
            NSInteger row = [pickerView selectedRowInComponent:2];
            NSString *str = [[pickerView titleForSelectedRow:row inComponent:2] componentsSeparatedByString:@"分"].firstObject;
            dateComponents.minute = [str integerValue];
        }
            if (_isSetDate) {
                if (component != 0) {
                    return;
                }else {
                    _isSetDate = false;
                }
            }
            break;
        default:
            break;
    }
    
    self.selectedComponents = dateComponents;
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
        [_minimumComponents setMonth:1];
        [_minimumComponents setDay:1];
        [_minimumComponents setHour:0];
        [_minimumComponents setMinute:0];
        [_minimumComponents setSecond:0];
    }
    return _minimumComponents;
}

- (NSDateComponents *)maximumComponents {
    if (self.maximumDate) {
        _maximumComponents = [self.calendar components:self.unitFlags fromDate:self.maximumDate];
    }else {
        _maximumComponents = [self.calendar components:self.unitFlags fromDate:[NSDate distantFuture]];
        [_maximumComponents setMonth:12];
        [_maximumComponents setDay:1];
        [_maximumComponents setHour:23];
        [_maximumComponents setMinute:59];
        [_maximumComponents setSecond:59];
    }
    if (_maximumComponents.month == 1) {
        [_maximumComponents setMonth:12];
    }
    return _maximumComponents;
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
        if (index < 0) {
//            NSLog(@"minimumDate can not greater than maximumDate");
            return _yearList;
        }
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
        NSInteger index = self.maximumComponents.month - self.minimumComponents.month;
        if (index < 0) {
//            NSLog(@"minimumDate can not greater than maximumDate");
            return _monthList;
        }
        NSMutableArray *months = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.month; i <= self.maximumComponents.month; i++) {
            [months addObject:[@(i) stringValue]];
        }
        _monthList = months;
    }
    return _monthList;
}

- (NSArray *)hourList {
    if (!_hourList) {
        NSInteger index = self.maximumComponents.hour - self.minimumComponents.hour;
        if (index < 0) {
//            NSLog(@"minimumDate can not greater than maximumDate");
            return _hourList;
        }
        NSMutableArray *hours = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.hour; i <= self.maximumComponents.hour; i++) {
            [hours addObject:[@(i) stringValue]];
        }
        _hourList = hours;
    }
    return _hourList;
}

- (NSArray *)minuteList {
    if (!_minuteList) {
        NSInteger index = self.maximumComponents.minute - self.minimumComponents.minute;
        if (index < 0) {
//            NSLog(@"minimumDate can not greater than maximumDate");
            return _minuteList;
        }
        NSMutableArray *minutes = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.minute; i <= self.maximumComponents.minute; i++) {
            [minutes addObject:[@(i) stringValue]];
        }
        _minuteList = minutes;
    }
    return _minuteList;
}

- (NSArray *)secondList {
    if (!_secondList) {
        NSInteger index = self.maximumComponents.second - self.minimumComponents.second;
        if (index < 0) {
//            NSLog(@"minimumDate can not greater than maximumDate");
            return _secondList;
        }
        NSMutableArray *seconds = [NSMutableArray arrayWithCapacity:index];
        for (NSUInteger i = self.minimumComponents.second; i <= self.maximumComponents.second; i++) {
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
            NSInteger day = [self howManyDaysWithMonthInThisYear:[self.calendar currentComponents].year withMonth:[month integerValue]];
            {
                NSMutableArray *days = [NSMutableArray arrayWithCapacity:day];
                NSInteger minDay = 1, maxDay = day;
                if (idx == 0) {
                    minDay = self.minimumComponents.day;
                }
                if (idx == self.monthList.count - 1) {
                    maxDay = self.maximumComponents.day;
                }else {
                    _maxDate = true;
                }
                NSInteger index = maxDay - minDay;
                if (index < 0) {
//                    NSLog(@"minimumDate can not greater than maximumDate");
                    minDay = 1;
                    maxDay = day;
                }
                for (NSUInteger i = minDay; i <= maxDay; i++) {
                    [days addObject:[@(i) stringValue]];
                }
                self.dayList = days;
            }
            [self.dayList enumerateObjectsUsingBlock:^(NSString*  _Nonnull day, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger weekDay = [self.calendar component:NSCalendarUnitWeekday fromDate:[NSDate setYear:[self.calendar currentComponents].year month:[month integerValue] day:[day integerValue]]];
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
@end

