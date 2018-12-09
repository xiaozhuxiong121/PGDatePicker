//
//  PGDatePickerHeader.h
//  Demo
//
//  Created by piggybear on 2018/3/18.
//  Copyright © 2018年 piggybear. All rights reserved.
//

@interface PGDatePicker()<PGPickerViewDelegate, PGPickerViewDataSource>{
    BOOL _isSubViewLayout;
    BOOL _isSetDateAnimation;
    BOOL _isDelay;
    BOOL _isSetDate;
    NSDate *_setDate;
    BOOL _isSelectedCancelButton;
}

@property (nonatomic, weak) PGPickerView *pickerView;

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

@end
