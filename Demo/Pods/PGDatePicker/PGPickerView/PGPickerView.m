//
//  PGPickerView.m
//  PGPickerView
//
//  Created by piggybear on 2017/7/26.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "PGPickerView.h"
#import "PGPickerViewMacros.h"
#import "PGPickerColumnView.h"

@interface PGPickerView()<PGPickerColumnViewDelegate> {
    NSInteger _tableViewHeightForRow;
}
@property (nonatomic, weak) UIView *upLine;
@property (nonatomic, weak) UIView *downLine;
@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, strong) NSArray<PGPickerColumnView *> *columnViewList;
@end

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height
@implementation PGPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.lineBackgroundColor = [UIColor grayColor];
        self.titleColorForSelectedRow = [UIColor blackColor];
        self.titleColorForOtherRow = [UIColor grayColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.lineBackgroundColor = [UIColor grayColor];
        self.titleColorForSelectedRow = [UIColor blackColor];
        self.titleColorForOtherRow = [UIColor grayColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self bringSubviewToFront:self.downLine];
    [self bringSubviewToFront:self.upLine];
}

- (PGPickerColumnView *)createColumnViewAtComponent:(NSUInteger)component refresh:(BOOL)refresh {
    CGFloat width = kWidth / _numberOfComponents;
    NSUInteger row = [self.dataSource pickerView:self numberOfRowsInComponent:component];
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:row];
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:row];
    for (int j = 0; j < row; j++) {
        BOOL tf = true;
        NSAttributedString *attriStr = [[NSAttributedString alloc]initWithString:@"?"];
        UIColor *color = [UIColor clearColor];
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(pickerView:attributedTitleForRow:forComponent:)]) {
                attriStr = [self.delegate pickerView:self attributedTitleForRow:j forComponent:component];
                if (!attriStr) {
                    tf = false;
                }
            }else {
                tf = false;
            }
            if (!tf && [self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
                NSString *title = [self.delegate pickerView:self titleForRow:j forComponent:component];
                title = title ? title : @"?";
                attriStr = [[NSAttributedString alloc]initWithString:title];
            }
            
            if ([self.delegate respondsToSelector:@selector(pickerView:viewBackgroundColorForRow:forComponent:)]) {
                UIColor *temp = [self.delegate pickerView:self viewBackgroundColorForRow:j forComponent:component];
                if (temp) {
                    color = temp;
                }
            }
        }
        [colors addObject:color];
        [datas addObject:attriStr];
    }
    PGPickerColumnView *view = [self columnViewInComponent:component];
    if (!view) {
        view = [[PGPickerColumnView alloc]initWithFrame:CGRectMake(component * width, 0, width, kHeight)];
        view.delegate = self;
        [self addSubview:view];
    }
    view.viewBackgroundColors = colors;
    view.component = component;
    view.titleColorForSelectedRow = self.titleColorForSelectedRow;
    view.titleColorForOtherRow = self.titleColorForOtherRow;
    view.refresh = refresh;
    view.datas = datas;
    return view;
}

- (void)setupColumnView {
    NSMutableArray *columnViewList = [NSMutableArray arrayWithCapacity:_numberOfComponents];
    for (int i = 0; i < _numberOfComponents; i++) {
        PGPickerColumnView *view = [self createColumnViewAtComponent:i refresh:false];
        [columnViewList addObject:view];
    }
    self.columnViewList = columnViewList;
}

- (void)setupView {
    if (self.middleText) {
        [self setupTextLogic];
    }
    switch (self.pickerViewType) {
        case PGPickerViewType1:
        {
            [self setupLineView1];
            return;
        }
        case PGPickerViewType2:
        {
            [self setupLineView2];
            return;
        }
        case PGPickerViewType3:
        {
            [self setupLineView3];
            return;
        }
    }
}

- (void)setupLineView1 {
    CGFloat upLinePosY = kHeight / 2 - _tableViewHeightForRow / 2 - kLineHeight;
    CGFloat downLinePosY = kHeight / 2 + _tableViewHeightForRow / 2 - kLineHeight;
    UIView *upLine = [[UIView alloc]initWithFrame:CGRectMake(0, upLinePosY, kWidth, kLineHeight)];
    upLine.backgroundColor = self.lineBackgroundColor;
    [self addSubview:upLine];
    self.upLine = upLine;
    
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, downLinePosY, kWidth, kLineHeight)];
    downLine.backgroundColor = self.lineBackgroundColor;
    [self addSubview:downLine];
    self.downLine = downLine;
}

- (void)setupLineView2 {
    CGFloat upLinePosY = kHeight / 2 - _tableViewHeightForRow / 2 - kLineHeight;
    CGFloat downLinePosY = kHeight / 2 + _tableViewHeightForRow / 2 - kLineHeight;
    CGFloat lineWidth = (self.frame.size.width / _numberOfComponents) - 20;
    CGFloat space = (self.frame.size.width / _numberOfComponents);
    CGFloat lineHeight = 1.5;
    for (int i = 0; i < _numberOfComponents; i++) {
        UIView *upLine = [[UIView alloc]initWithFrame:CGRectMake(10 + space * i, upLinePosY, lineWidth, lineHeight)];
        upLine.backgroundColor = self.lineBackgroundColor;
        [self addSubview:upLine];
        self.upLine = upLine;
        
        UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(10 + space * i, downLinePosY, lineWidth, lineHeight)];
        downLine.backgroundColor = self.lineBackgroundColor;
        [self addSubview:downLine];
        self.downLine = downLine;
    }
}

- (void)setupLineView3 {
    CGFloat space = (self.frame.size.width / _numberOfComponents);
    [self setupLineView2];
    for (int i = 0; i < _numberOfComponents; i++) {
        if (i != _numberOfComponents - 1) {
            UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(space * (i+1), 0, 0.5, kHeight)];
            verticalLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
            [self addSubview:verticalLine];
        }
    }
}

- (void)setupTextLogic {
    CGFloat lineWidth = (self.frame.size.width / _numberOfComponents);
    CGFloat space = 10;
    for (int i = 0; i < _numberOfComponents; i++) {
        UILabel *label = [[UILabel alloc]init];
        if ([self.delegate respondsToSelector:@selector(pickerView:textSpaceForcomponent:)]) {
            space = [self.delegate pickerView:self textSpaceForcomponent:i];
        }
        label.frame = CGRectMake(lineWidth / 2 + lineWidth * i + space, kHeight / 2 - 15, 30, 30);
        NSString *text = @"";
        if ([self.delegate respondsToSelector:@selector(pickerView:textForcomponent:)]) {
            text = [self.delegate pickerView:self textForcomponent:i];
        }
        label.text = text;
        label.textColor = self.textColor;
        [self addSubview:label];
    }
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        return [self.dataSource pickerView:self numberOfRowsInComponent:component];
    }
    return 0;
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    PGPickerColumnView *view = [self columnViewInComponent:component];
    if (view) {
        return view.selectedRow;
    }
    return -1;
}

- (NSString *)titleForSelectedRow:(NSInteger)row inComponent:(NSInteger)component {
    PGPickerColumnView *view = [self columnViewInComponent:component];
    if (view) {
        return view.titleForSelectedRow;
    }
    return nil;
}

- (NSString *)currentTitleInComponent:(NSInteger)component {
    PGPickerColumnView *view = [self columnViewInComponent:component];
    if (view) {
        return view.currentString;
    }
    return nil;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    PGPickerColumnView *view = [self columnViewInComponent:component];
    if (view) {
        [view selectRow:row animated:false];
    }
}

- (PGPickerColumnView *)columnViewInComponent:(NSUInteger)component {
    if (!self.columnViewList || self.columnViewList.count == 0) {
        return nil;
    }
    __block PGPickerColumnView *view = nil;
    [self.columnViewList enumerateObjectsUsingBlock:^(PGPickerColumnView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.component == component) {
            view = obj;
            *stop = true;
        }
    }];
    return view;
}

- (void)reloadComponent:(NSInteger)component {
    [self createColumnViewAtComponent:component refresh:false];
}

- (void)reloadComponent:(NSInteger)component refresh:(BOOL)refresh {
    [self createColumnViewAtComponent:component refresh:refresh];
}

- (void)reloadAllComponents {
    [self setupColumnView];
}

#pragma mark - PGPickerColumnViewDelegate
- (void)pickerColumnView:(PGPickerColumnView *)pickerColumnView didSelectRow:(NSInteger)row {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:row inComponent:pickerColumnView.component];
    }
}

- (void)pickerColumnView:(PGPickerColumnView *)pickerColumnView title:(NSString *)title didSelectRow:(NSInteger)row {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:title:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self title:title didSelectRow:row inComponent:pickerColumnView.component];
    }
}

#pragma mark - Setter
- (void)setDelegate:(id<PGPickerViewDelegate>)delegate {
    _delegate = delegate;
    if (delegate && [delegate respondsToSelector:@selector(rowHeightInPickerView:)]) {
        _tableViewHeightForRow = [delegate rowHeightInPickerView:self];
    }else {
        _tableViewHeightForRow = 44;
    }
}

- (void)setDataSource:(id<PGPickerViewDataSource>)dataSource {
    _dataSource = dataSource;
    if (dataSource && [dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        _numberOfComponents = [dataSource numberOfComponentsInPickerView:self];
    }
    [self setupColumnView];
    [self setupView];
}

- (void)setLineBackgroundColor:(UIColor *)lineBackgroundColor {
    _lineBackgroundColor = lineBackgroundColor;
    self.upLine.backgroundColor = lineBackgroundColor;
    self.downLine.backgroundColor = lineBackgroundColor;
}

- (void)setTitleColorForSelectedRow:(UIColor *)titleColorForSelectedRow {
    _titleColorForSelectedRow = titleColorForSelectedRow;
    [self.columnViewList enumerateObjectsUsingBlock:^(PGPickerColumnView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleColorForSelectedRow = titleColorForSelectedRow;
    }];
}

- (void)setTitleColorForOtherRow:(UIColor *)titleColorForOtherRow {
    _titleColorForOtherRow = titleColorForOtherRow;
    [self.columnViewList enumerateObjectsUsingBlock:^(PGPickerColumnView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleColorForOtherRow = titleColorForOtherRow;
    }];
}

#pragma mark - Getter
- (NSUInteger)numberOfRows {
    if (!_numberOfRows) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
            _numberOfRows = [self.dataSource pickerView:self numberOfRowsInComponent:_numberOfComponents];
        }else {
            _numberOfRows = 0;
        }
    }
    return _numberOfRows;
}

@end
