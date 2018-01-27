//
//  PGDatePickManager.m
//
//  Created by piggybear on 2018/1/7.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePickManager.h"
#import "PGDatePickManagerHeaderView.h"

@interface PGDatePickManager ()
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) PGDatePickManagerHeaderView *headerView;
@property (nonatomic, weak) UIView *dismissView;
@end

@implementation PGDatePickManager

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        [self setupDismissViewTapHandler];
        [self headerViewButtonHandler];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.headerView.style = self.style;
    self.dismissView.frame = self.view.bounds;
    if (self.style == PGDatePickManagerStyle1) {
        [self setupStyle1];
    }else if (self.style == PGDatePickManagerStyle2) {
        [self setupStyle2];
    }else {
        [self setupStyle3];
    }
    [self.view bringSubviewToFront:self.contentView];
}

- (void)setupDismissViewTapHandler {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelButtonHandler)];
    [self.dismissView addGestureRecognizer:tap];
}

- (void)headerViewButtonHandler {
    __weak id weak_self = self;
    self.headerView.cancelButtonHandlerBlock = ^{
        __strong id strong_self = weak_self;
        [strong_self cancelButtonHandler];
    };
    self.headerView.confirmButtonHandlerBlock =^{
        __strong PGDatePickManager *strong_self = weak_self;
        [strong_self.datePicker tapSelectedHandler];
        [strong_self cancelButtonHandler];
    };
}

- (void)cancelButtonHandler {
    if (self.style == PGDatePickManagerStyle1) {
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

- (void)setupStyle1 {
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = self.view.safeAreaInsets.bottom;
    }
    CGFloat rowHeight = self.datePicker.rowHeight;
    CGFloat headerViewHeight = self.headerHeight;
    CGFloat contentViewHeight = rowHeight * 5 + headerViewHeight;
    CGFloat datePickerHeight = contentViewHeight - headerViewHeight - bottom;
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
    [UIView animateWithDuration:0.2 animations:^{
        if (self.isShadeBackgroud) {
            self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        }
        self.contentView.frame = contentViewFrame;
        self.headerView.frame = headerViewFrame;
        self.datePicker.frame = datePickerFrame;
    }];
}

- (void)setupStyle2 {
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
                         if (self.isShadeBackgroud) {
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
                         if (self.isShadeBackgroud) {
                             self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
                         }
                         self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     }];
}

#pragma Setter

- (void)setIsShadeBackgroud:(BOOL)isShadeBackgroud {
    _isShadeBackgroud = isShadeBackgroud;
    if (isShadeBackgroud) {
        self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }else {
        self.dismissView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setCancelButtonFont:(UIFont *)cancelButtonFont {
    _cancelButtonFont = cancelButtonFont;
    self.headerView.cancelButton.titleLabel.font = cancelButtonFont;
}

- (void)setCancelButtonText:(NSString *)cancelButtonText {
    _cancelButtonText = cancelButtonText;
    [self.headerView.cancelButton setTitle:cancelButtonText forState:UIControlStateNormal];
}

- (void)setCancelButtonTextColor:(UIColor *)cancelButtonTextColor {
    _cancelButtonTextColor = cancelButtonTextColor;
    [self.headerView.cancelButton setTitleColor:cancelButtonTextColor forState:UIControlStateNormal];
}

- (void)setConfirmButtonFont:(UIFont *)confirmButtonFont {
    _confirmButtonFont = confirmButtonFont;
    self.headerView.confirmButton.titleLabel.font = confirmButtonFont;
}

- (void)setConfirmButtonText:(NSString *)confirmButtonText {
    _confirmButtonText = confirmButtonText;
    [self.headerView.confirmButton setTitle:confirmButtonText forState:UIControlStateNormal];
}

- (void)setConfirmButtonTextColor:(UIColor *)confirmButtonTextColor {
    _confirmButtonTextColor = confirmButtonTextColor;
    [self.headerView.confirmButton setTitleColor:confirmButtonTextColor forState:UIControlStateNormal];
}

#pragma Getter

- (UIView *)contentView {
    if (!_contentView) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
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
        _headerViewBackgroundColor = [UIColor colorWithHexString:@"#F1EDF6"];
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
