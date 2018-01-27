//
//  PGDatePickManagerHeaderView.m
//
//  Created by piggybear on 2018/1/7.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGDatePickManagerHeaderView.h"
#import "NSBundle+PGDatePicker.h"
#import "UIColor+PGHex.h"

@interface PGDatePickManagerHeaderView()
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIView *middleLineView;
@property (nonatomic, assign) CGSize titleLabelSize;
@end

@implementation PGDatePickManagerHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupButton];
    }
    return self;
}

- (void)dealloc {
    if (self.titleLabel) {
        [self.titleLabel removeObserver:self forKeyPath:@"text"];
    }
}

- (void)layoutSubviews {
    self.titleLabel.frame = CGRectMake((self.bounds.size.width - self.titleLabelSize.width) / 2,
                                       0,
                                       self.titleLabelSize.width,
                                       self.bounds.size.height);
    if (self.style == PGDatePickManagerStyle1) {
        self.lineView.hidden = true;
        [self setyle1];
    }else if (self.style == PGDatePickManagerStyle2) {
        [self setyle1];
    }else if (self.style == PGDatePickManagerStyle3) {
        [self setyle2];
    }
}

- (void)setyle1 {
    CGFloat lineViewHeight = 0.5;
    self.lineView.frame = CGRectMake(0,
                                     self.bounds.size.height - lineViewHeight,
                                     self.bounds.size.width,
                                     lineViewHeight);
    CGFloat buttonWidth = 80;
    CGFloat buttonHeight = 30;
    CGFloat space = 15;
    self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.cancelButton.frame = CGRectMake(space,
                                         (self.bounds.size.height - buttonHeight) / 2,
                                         buttonWidth,
                                         buttonHeight);
    self.confirmButton.frame = CGRectMake(self.bounds.size.width - buttonWidth - space,
                                          (self.bounds.size.height - buttonHeight) / 2,
                                          buttonWidth,
                                          buttonHeight);
}

- (void)setyle2 {
    CGFloat lineViewHeight = 0.5;
    self.lineView.frame = CGRectMake(0,
                                     0,
                                     self.bounds.size.width,
                                     lineViewHeight);
    CGFloat buttonWidth = self.bounds.size.width / 2;
    CGFloat buttonHeight = 30;
    self.cancelButton.frame = CGRectMake(0,
                                         (self.bounds.size.height - buttonHeight) / 2,
                                         buttonWidth,
                                         buttonHeight);
    self.confirmButton.frame = CGRectMake(self.bounds.size.width / 2,
                                          (self.bounds.size.height - buttonHeight) / 2,
                                          buttonWidth,
                                          buttonHeight);
    self.middleLineView.frame = CGRectMake(self.bounds.size.width / 2, 5, 0.5, self.bounds.size.height - 10);
}

- (void)setupButton {
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    NSString *cancelButtonText = [NSBundle localizedStringForKey:@"cancelButtonText"];
    [self.cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.cancelButton setTitle:cancelButtonText forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    NSString *confirmButtonText = [NSBundle localizedStringForKey:@"confirmButtonText"];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"#69BDFF"] forState:UIControlStateNormal];
    [self.confirmButton setTitle:confirmButtonText forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonHandler) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancelButtonHandler {
    if (self.cancelButtonHandlerBlock) {
        self.cancelButtonHandlerBlock();
    }
}

- (void)confirmButtonHandler {
    if (self.confirmButtonHandlerBlock) {
        self.confirmButtonHandlerBlock();
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    UILabel *label = object;
    NSString *newString = change[@"new"];
    CGSize size = [newString sizeWithAttributes:@{NSFontAttributeName: [label font]}];
    self.titleLabelSize = size;
}

#pragma Getter

- (UIView *)lineView {
    if (!_lineView) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
        _lineView = view;
    }
    return _lineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc]init];
        [self addSubview:label];
        label.textColor = [UIColor colorWithHexString:@"#848484"];
        label.font = [UIFont boldSystemFontOfSize:17];
        [label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIView *)middleLineView {
    if (!_middleLineView) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
        _middleLineView = view;
    }
    return _middleLineView;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        _confirmButton = button;
    }
    return _confirmButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        _cancelButton = button;
    }
    return _cancelButton;
}

@end
