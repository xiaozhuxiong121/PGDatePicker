//
//  PGDatePickManager.m
//
//  Created by piggybear on 2018/1/7.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePickManager.h"
#import "PGDatePickManagerHeaderView.h"
#import "PGEnumeration.h""
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define KBOTTOM_SPACE_HEIGHT (IPHONE_X?34.0f:0.0f)

@interface PGDatePickManager ()
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) PGDatePickManagerHeaderView *headerView;
@property (nonatomic, weak) UIView *dismissView;
@end

@implementation PGDatePickManager

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.customDismissAnimation = nil;
        [self setupDismissViewTapHandler];
        [self headerViewButtonHandler];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
//    self.headerView.language = self.datePicker.language;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.headerView.style = self.style;
    self.dismissView.frame = self.view.bounds;
    self.contentView.backgroundColor = self.datePicker.backgroundColor;
    if (self.style == PGDatePickManagerStyleSheet) {
        [self setupStyleSheet];
    }else if (self.style == PGDatePickManagerStyleAlertTopButton) {
        [self setupStyleAlert];
    }else {
        [self setupStyle3];
    }
    [self.view bringSubviewToFront:self.contentView];
}

- (void)setupDismissViewTapHandler {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissViewTapMonitor)];
    [self.dismissView addGestureRecognizer:tap];
}

- (void)headerViewButtonHandler {
    __weak id weak_self = self;
    self.headerView.cancelButtonHandlerBlock = ^{
        __strong PGDatePickManager *strong_self = weak_self;
        [strong_self cancelButtonHandler];
        if (strong_self.cancelButtonMonitor) {
            strong_self.cancelButtonMonitor();
        }
    };
    self.headerView.confirmButtonHandlerBlock =^{
        __strong PGDatePickManager *strong_self = weak_self;
        [strong_self.datePicker tapSelectedHandler];
        [strong_self cancelButtonHandler];
    };
    
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:RGBAlpha(0x333333) forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:RGBAlpha(0xF8F8F8)];
    [cancelButton ug_radius:22 *KWIDTH];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = fontWeight(14, UIFontWeightRegular);
    [_alertView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.alertView.mas_left).offset(43 *KWIDTH);
        make.bottom.mas_equalTo(self.alertView.mas_bottom).offset(- (25 *KWIDTH + KBOTTOM_SPACE_HEIGHT));
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 90 *KWIDTH)/2, 44 *KWIDTH));
    }];

    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [confirmButton setTitle:@"完成" forState:UIControlStateNormal];
    [confirmButton setTitleColor:RGBAlpha(0xffffff) forState:UIControlStateNormal];
    [confirmButton setBackgroundColor:RGBAlpha(0x7B5CF3)];
    [confirmButton ug_radius:22 *KWIDTH];
    [confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font = fontWeight(14, UIFontWeightRegular);
    [_alertView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.alertView.mas_right).offset(-43 *KWIDTH);
        make.bottom.mas_equalTo(self.alertView.mas_bottom).offset(- (25 *KWIDTH + KBOTTOM_SPACE_HEIGHT));
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 90 *KWIDTH)/2, 44 *KWIDTH));
    }];
    
    
}

- (void)cancelButtonHandler {
    if (self.customDismissAnimation) {
        NSTimeInterval duration = self.customDismissAnimation(self.dismissView, self.contentView);
        if (duration && duration != NSNotFound) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:false completion:nil];
            });
        }
    } else {
        if (self.style == PGDatePickManagerStyleSheet) {
            CGRect contentViewFrame = self.contentView.frame;
            contentViewFrame.origin.y = self.view.bounds.size.height;
            [UIView animateWithDuration:0.2 animations:^{
                self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                self.contentView.frame = contentViewFrame;
            }completion:^(BOOL finished) {
                [self dismissViewControllerAnimated:false completion:nil];
            }];
        }else {
            [self dismissViewControllerAnimated:false completion:nil];
        }
    }
}

- (void)dismissViewTapMonitor {
    [self cancelButtonHandler];
    if (self.cancelButtonMonitor) {
        self.cancelButtonMonitor();
    }
}

- (void)setupStyleSheet {
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = self.view.safeAreaInsets.bottom;
    }
    CGFloat rowHeight = self.datePicker.rowHeight;
    CGFloat headerViewHeight = self.headerHeight;
    CGFloat contentViewHeight = rowHeight * 5 + headerViewHeight + 90 *([UIScreen mainScreen].bounds.size.width/375) + bottom;
    CGFloat datePickerHeight = rowHeight * 5 ;
    CGRect contentViewFrame = CGRectMake(0,
                                         self.view.bounds.size.height - contentViewHeight,
                                         self.view.bounds.size.width,
                                         contentViewHeight);
    CGRect headerViewFrame = CGRectMake(0, 0, self.view.bounds.size.width, headerViewHeight);
    CGRect datePickerFrame = CGRectMake(0,
                                        CGRectGetMaxY(headerViewFrame),
                                        self.view.bounds.size.width,
                                        datePickerHeight);
    
    self.contentView.frame = CGRectMake(0,
                                        self.view.bounds.size.height,
                                        self.view.bounds.size.width,
                                        contentViewHeight);
    self.headerView.frame = headerViewFrame;
    self.datePicker.frame = datePickerFrame;
    self.headerView.backgroundColor = self.headerViewBackgroundColor;
    [UIView animateWithDuration:.001f animations:^{
        if (self.isShadeBackground) {
            self.dismissView.backgroundColor = [UIColor colorWithWhite:0.01 alpha:0.4];

        }
        self.contentView.frame = contentViewFrame;
        self.headerView.frame = headerViewFrame;
        self.datePicker.frame = datePickerFrame;
    }];
}

- (void)setupStyleAlert {
    CGFloat rowHeight = self.datePicker.rowHeight;
    CGFloat datePickerHeight = rowHeight * 5;
    CGFloat headerViewHeight = self.headerHeight;
    CGFloat contentViewMarginLeft = 30;
    CGFloat contentViewWidth = self.view.bounds.size.width - contentViewMarginLeft * 2;
    CGFloat contentViewHeight = datePickerHeight  + headerViewHeight;
    self.contentView.frame = CGRectMake(contentViewMarginLeft,
                                        self.view.center.y - contentViewHeight / 2,
                                        contentViewWidth,
                                        contentViewHeight);
    self.headerView.frame = CGRectMake(0, 0, contentViewWidth, headerViewHeight);
    
    CGRect datePickerFrame = self.contentView.bounds;
    datePickerFrame.origin.y = CGRectGetMaxY(self.headerView.frame);
    datePickerFrame.size.height = datePickerHeight;
    self.contentView.layer.cornerRadius = 10;
    self.datePicker.layer.cornerRadius = 10;
    self.datePicker.frame = datePickerFrame;
    self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.05
                     animations:^{
                         if (self.isShadeBackground) {
                             self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
                         }
                         self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     }];
}

- (void)setupStyle3 {
    CGFloat rowHeight = self.datePicker.rowHeight;
    CGFloat datePickerHeight = rowHeight * 5;
    CGFloat headerViewHeight = self.headerHeight;
    CGFloat contentViewMarginLeft = 30;
    CGFloat contentViewWidth = self.view.bounds.size.width - contentViewMarginLeft * 2;
    CGFloat contentViewHeight = datePickerHeight  + headerViewHeight;
    self.contentView.frame = CGRectMake(contentViewMarginLeft,
                                        self.view.center.y - contentViewHeight / 2,
                                        contentViewWidth,
                                        contentViewHeight);
    self.headerView.frame = CGRectMake(0,
                                       self.contentView.bounds.size.height - headerViewHeight,
                                       contentViewWidth,
                                       headerViewHeight);
    CGRect datePickerFrame = self.contentView.bounds;
    datePickerFrame.size.height = datePickerHeight;
    self.datePicker.frame = datePickerFrame;
    self.contentView.layer.cornerRadius = 10;
    self.datePicker.layer.cornerRadius = 10;
    self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.05
                     animations:^{
                         if (self.isShadeBackground) {
                             self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
                         }
                         self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     }];
}

#pragma Setter

- (void)setIsShadeBackground:(BOOL)isShadeBackground {
    _isShadeBackground = isShadeBackground;
    if (isShadeBackground) {
        self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }else {
        self.dismissView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setCancelButtonFont:(UIFont *)cancelButtonFont {
    _cancelButtonFont = cancelButtonFont;
    self.headerView.cancelButtonFont = cancelButtonFont;
}

- (void)setCancelButtonText:(NSString *)cancelButtonText {
    _cancelButtonText = cancelButtonText;
    self.headerView.cancelButtonText = cancelButtonText;
}

- (void)setCancelButtonTextColor:(UIColor *)cancelButtonTextColor {
    _cancelButtonTextColor = cancelButtonTextColor;
    self.headerView.cancelButtonTextColor = cancelButtonTextColor;
}

- (void)setConfirmButtonFont:(UIFont *)confirmButtonFont {
    _confirmButtonFont = confirmButtonFont;
    self.headerView.confirmButtonFont = confirmButtonFont;
}

- (void)setConfirmButtonText:(NSString *)confirmButtonText {
    _confirmButtonText = confirmButtonText;
    self.headerView.confirmButtonText = confirmButtonText;
}

- (void)setConfirmButtonTextColor:(UIColor *)confirmButtonTextColor {
    _confirmButtonTextColor = confirmButtonTextColor;
    self.headerView.confirmButtonTextColor = confirmButtonTextColor;
}

#pragma Getter

- (UIView *)contentView {
    if (!_contentView) {
        UIView *view = [[UIView alloc]init];
        view.layer.cornerRadius = 16 *([UIScreen mainScreen].bounds.size.width/375);
        [self.view addSubview:view];
        _contentView =view;
    }
    return _contentView;
}

- (PGDatePicker *)datePicker {
    if (!_datePicker) {
        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
        datePicker.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:datePicker];
        _datePicker = datePicker;
    }
    return _datePicker;
}

- (PGDatePickManagerHeaderView *)headerView {
    if (!_headerView) {
        PGDatePickManagerHeaderView *view = [[PGDatePickManagerHeaderView alloc]init];
        [self.contentView addSubview:view];
        _headerView = view;
    }
    return _headerView;
}

- (UIColor *)headerViewBackgroundColor {
    if (!_headerViewBackgroundColor) {
        _headerViewBackgroundColor = [UIColor pg_colorWithHexString:@"#F1EDF6"];
    }
    return _headerViewBackgroundColor;
}

- (CGFloat)headerHeight {
    if (!_headerHeight) {
        _headerHeight = 50;
    }
    return _headerHeight;
}

- (UIView *)dismissView {
    if (!_dismissView) {
        UIView *view = [[UIView alloc]init];
        [self.view addSubview:view];
        _dismissView = view;
    }
    return _dismissView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = self.headerView.titleLabel;
    }
    return _titleLabel;
}

@end
