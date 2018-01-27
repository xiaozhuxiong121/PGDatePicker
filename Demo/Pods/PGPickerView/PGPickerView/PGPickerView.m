//
//  PGPickerView.m
//  PGPickerView
//
//  Created by piggybear on 2017/7/26.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "PGPickerView.h"
#import "PGPickerColumnView.h"

@interface PGPickerView()<PGPickerColumnViewDelegate> {
    BOOL _isSubViewLayout;
    BOOL _isSelected;
}

@property (nonatomic, strong) NSMutableArray<NSNumber *> *animationOfSelectedRowList;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *numberOfSelectedRowList;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *numberOfSelectedComponentList;

@property (nonatomic, strong) NSArray<UIView *> *upLines;
@property (nonatomic, strong) NSArray<UIView *> *downLines;
@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, strong) NSArray<PGPickerColumnView *> *columnViewList;
@end

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height
@implementation PGPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_isSubViewLayout) {
        return;
    }
    _isSubViewLayout = true;
    [self setupColumnView];
    [self setupView];
    [self.upLines enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self bringSubviewToFront:obj];
        [self bringSubviewToFront:self.downLines[idx]];
    }];
    
    if (_isSelected) {
        [self.numberOfSelectedRowList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger component = [self.numberOfSelectedComponentList[idx] integerValue];
            BOOL isAnimation = [self.animationOfSelectedRowList[idx] boolValue];
            [self selectRow:[obj integerValue] inComponent:component animated:isAnimation];
        }];
    }
}

- (void)setup {
    self.lineBackgroundColor = [UIColor lightGrayColor];
    self.textColorOfSelectedRow = [UIColor blackColor];
    self.textColorOfOtherRow = [UIColor lightGrayColor];
    self.isHiddenMiddleText = true;
    self.lineHeight = 0.5;
    self.verticalLineWidth = 0.5;
    self.verticalLineBackgroundColor = self.lineBackgroundColor;
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
        CGFloat rowHeight = [self rowHeightInComponent:component];
        CGFloat upLineHeight = [self upLineHeightForComponent:component];
        CGFloat downLineHeight = [self downLineHeightForComponent:component];
        view = [[PGPickerColumnView alloc]initWithFrame:CGRectMake(component * width, 0, width, kHeight) rowHeight: rowHeight upLineHeight:upLineHeight downLineHeight:downLineHeight];
        view.delegate = self;
        [self addSubview:view];
    }
    view.refresh = refresh;
    view.viewBackgroundColors = colors;
    view.textFontOfSelectedRow = [self textFontOfSelectedRowInComponent:component];
    view.textFontOfOtherRow = [self textFontOfOtherRowInComponent:component];
    view.component = component;
    view.datas = datas;
    view.textColorOfSelectedRow = [self textColorOfSelectedRowInComponent:component];
    view.textColorOfOtherRow = [self textColorOfOtherRowInComponent:component];
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
    if (!self.isHiddenMiddleText) {
        [self setupMiddleTextLogic];
    }
    switch (self.type) {
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
    NSMutableArray *upLines = [NSMutableArray arrayWithCapacity:_numberOfComponents];
    NSMutableArray *downLines = [NSMutableArray arrayWithCapacity:_numberOfComponents];
    CGFloat lineWidth = (kWidth / _numberOfComponents);
    for (int i = 0; i < _numberOfComponents; i++) {
        CGFloat rowHeight = [self rowHeightInComponent:i];
        CGFloat upLineHeight = [self upLineHeightForComponent:i];
        CGFloat upLinePosY = kHeight / 2 - rowHeight / 2 - upLineHeight;
        UIView *upLine = [[UIView alloc]initWithFrame:CGRectMake(i * lineWidth, upLinePosY, lineWidth, upLineHeight)];
        upLine.backgroundColor = self.lineBackgroundColor;
        [self addSubview:upLine];
        [upLines addObject:upLine];
        
        CGFloat downLineHeight = [self downLineHeightForComponent:i];
        CGFloat downLinePosY = CGRectGetMaxY(upLine.frame) + rowHeight;
        UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(i * lineWidth, downLinePosY, lineWidth, downLineHeight)];
        downLine.backgroundColor = self.lineBackgroundColor;
        [self addSubview:downLine];
        [downLines addObject:downLine];
    }
    self.upLines = upLines;
    self.downLines = downLines;
}

- (void)setupLineView2 {
    NSMutableArray *upLines = [NSMutableArray arrayWithCapacity:_numberOfComponents];
    NSMutableArray *downLines = [NSMutableArray arrayWithCapacity:_numberOfComponents];
    CGFloat lineWidth = (self.frame.size.width / _numberOfComponents) - 20;
    CGFloat space = (self.frame.size.width / _numberOfComponents);
    if (_numberOfComponents == 1) {
        CGFloat rowHeight = [self rowHeightInComponent:0];
        CGFloat upLineHeight = [self upLineHeightForComponent:0];
        upLineHeight = upLineHeight > 1.5 ? upLineHeight: 1.5;
        CGFloat upLinePosY = kHeight / 2 - rowHeight / 2 - upLineHeight;
        UIView *upLine = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 43, upLinePosY, 90, upLineHeight)];
        upLine.backgroundColor = self.lineBackgroundColor;
        [self addSubview:upLine];
        [upLines addObject:upLine];
        
        CGFloat downLineHeight = [self downLineHeightForComponent:0];
        downLineHeight = downLineHeight > 1.5 ? downLineHeight: 1.5;
        CGFloat downLinePosY = CGRectGetMaxY(upLine.frame) + rowHeight;
        UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 43, downLinePosY, 90, downLineHeight)];
        downLine.backgroundColor = self.lineBackgroundColor;
        [self addSubview:downLine];
        [downLines addObject:downLine];
        
        self.upLines = upLines;
        self.downLines = downLines;
        return;
    }
    for (int i = 0; i < _numberOfComponents; i++) {
        CGFloat rowHeight = [self rowHeightInComponent:i];
        CGFloat upLineHeight = [self upLineHeightForComponent:i];
        upLineHeight = upLineHeight > 1.5 ? upLineHeight: 1.5;
        CGFloat upLinePosY = kHeight / 2 - rowHeight / 2 - upLineHeight;
        UIView *upLine = [[UIView alloc]initWithFrame:CGRectMake(10 + space * i, upLinePosY, lineWidth, upLineHeight)];
        upLine.backgroundColor = [self upLineBackgroundColorForComponent:i];
        [self addSubview:upLine];
        [upLines addObject:upLine];
        
        CGFloat downLineHeight = [self downLineHeightForComponent:i];
        downLineHeight = downLineHeight > 1.5 ? downLineHeight: 1.5;
        CGFloat downLinePosY = CGRectGetMaxY(upLine.frame) + rowHeight;
        UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(10 + space * i, downLinePosY, lineWidth, downLineHeight)];
        downLine.backgroundColor = [self downLineBackgroundColorForComponent:i];
        [self addSubview:downLine];
        [downLines addObject:downLine];
    }
    self.upLines = upLines;
    self.downLines = downLines;
}

- (void)setupLineView3 {
    CGFloat space = (self.frame.size.width / _numberOfComponents);
    [self setupLineView2];
    for (int i = 0; i < _numberOfComponents; i++) {
        if (i != _numberOfComponents - 1) {
            CGFloat width = [self verticalLineWidthForComponent:i];
            UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(space * (i+1), 0, width, kHeight)];
            verticalLine.backgroundColor = [self verticalLineBackgroundColorForComponent:i];
            [self addSubview:verticalLine];
        }
    }
}

- (void)setupMiddleTextLogic {
    CGFloat lineWidth = (self.frame.size.width / _numberOfComponents);
    CGFloat space = 10;
    for (int i = 0; i < _numberOfComponents; i++) {
        UILabel *label = [[UILabel alloc]init];
        if ([self.delegate respondsToSelector:@selector(pickerView:middleTextSpaceForcomponent:)]) {
            space = [self.delegate pickerView:self middleTextSpaceForcomponent:i];
        }
        label.frame = CGRectMake(lineWidth / 2 + lineWidth * i + space, kHeight / 2 - 15, 30, 30);
        NSString *text = @"";
        if ([self.delegate respondsToSelector:@selector(pickerView:middleTextForcomponent:)]) {
            text = [self.delegate pickerView:self middleTextForcomponent:i];
        }
        label.text = text;
        label.textColor = self.middleTextColor;
        label.font = self.middleTextFont;
        [self addSubview:label];
    }
}

- (UIColor *)verticalLineBackgroundColorForComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:verticalLineBackgroundColorForComponent:)]) {
        return [self.delegate pickerView:self verticalLineBackgroundColorForComponent:component];
    }
    return self.verticalLineBackgroundColor;
}

- (CGFloat)verticalLineWidthForComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:verticalLineWidthForComponent:)]) {
        return [self.delegate pickerView:self verticalLineWidthForComponent:component];
    }
    return self.verticalLineWidth;
}

- (UIColor *)upLineBackgroundColorForComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:upLineBackgroundColorForComponent:)]) {
        return [self.delegate pickerView:self upLineBackgroundColorForComponent:component];
    }
    return self.lineBackgroundColor;
}

- (UIColor *)downLineBackgroundColorForComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:downLineBackgroundColorForComponent:)]) {
        return [self.delegate pickerView:self downLineBackgroundColorForComponent:component];
    }
    return self.lineBackgroundColor;
}

- (CGFloat)upLineHeightForComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:upLineHeightForComponent:)]) {
        return [self.delegate pickerView:self upLineHeightForComponent:component];
    }
    return self.lineHeight;
}

- (CGFloat)downLineHeightForComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:downLineHeightForComponent:)]) {
        return [self.delegate pickerView:self downLineHeightForComponent:component];
    }
    return self.lineHeight;
}

- (UIColor *)textColorOfSelectedRowInComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:textColorOfSelectedRowInComponent:)]) {
        return [self.delegate pickerView:self textColorOfSelectedRowInComponent:component];
    }
    return self.textColorOfSelectedRow;
}

- (UIColor *)textColorOfOtherRowInComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:textColorOfOtherRowInComponent:)]) {
        return [self.delegate pickerView:self textColorOfOtherRowInComponent:component];
    }
    return self.textColorOfOtherRow;
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

- (NSString *)textOfSelectedRowInComponent:(NSInteger)component {
    PGPickerColumnView *view = [self columnViewInComponent:component];
    if (view) {
        return view.textOfSelectedRow;
    }
    return nil;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    if (_isSubViewLayout) {
        PGPickerColumnView *view = [self columnViewInComponent:component];
        [view selectRow:row animated:animated];
        return;
    }
    if (!_isSubViewLayout) {
        [self.numberOfSelectedComponentList addObject:@(component)];
        [self.numberOfSelectedRowList addObject:@(row)];
        [self.animationOfSelectedRowList addObject:@(animated)];
    }
    _isSelected = true;
}

- (CGFloat)rowHeightInComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rowHeightInPickerView:forComponent:)]) {
        return [self.delegate rowHeightInPickerView:self forComponent: component];
    }else if (self.rowHeight != 0) {
        return self.rowHeight;
    }
    self.rowHeight = 44;
    return self.rowHeight;
}

- (UIFont *)textFontOfSelectedRowInComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:textFontOfSelectedRowInComponent:)]) {
        return [self.delegate pickerView:self textFontOfSelectedRowInComponent:component];
    }
    return self.textFontOfSelectedRow;
}

- (UIFont *)textFontOfOtherRowInComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:textFontOfOtherRowInComponent:)]) {
        return [self.delegate pickerView:self textFontOfOtherRowInComponent:component];
    }
    return self.textFontOfOtherRow;
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

- (UIFont *)pickerColumnView:(PGPickerColumnView *)pickerColumnView textFontOfOtherRow:(NSInteger)row InComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:textFontOfOtherRow:InComponent:)]) {
        return [self.delegate pickerView:self textFontOfOtherRow:row InComponent:component];
    }
    return self.textFontOfOtherRow;
}

- (UIColor *)pickerColumnView:(PGPickerColumnView *)pickerColumnView textColorOfOtherRow:(NSInteger)row InComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:textColorOfOtherRow:InComponent:)]) {
        return [self.delegate pickerView:self textColorOfOtherRow:row InComponent:component];
    }
    return self.textColorOfOtherRow;
}

#pragma mark - Setter
- (void)setDataSource:(id<PGPickerViewDataSource>)dataSource {
    _dataSource = dataSource;
    if (dataSource && [dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        _numberOfComponents = [dataSource numberOfComponentsInPickerView:self];
    }
}

- (void)setTextColorOfSelectedRow:(UIColor *)textColorOfSelectedRow {
    _textColorOfSelectedRow = textColorOfSelectedRow;
    [self.columnViewList enumerateObjectsUsingBlock:^(PGPickerColumnView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textColorOfSelectedRow = textColorOfSelectedRow;
    }];
}

- (void)setTextColorOfOtherRow:(UIColor *)textColorOfOtherRow {
    _textColorOfOtherRow = textColorOfOtherRow;
    [self.columnViewList enumerateObjectsUsingBlock:^(PGPickerColumnView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textColorOfOtherRow = textColorOfOtherRow;
    }];
}

- (void)setLineBackgroundColor:(UIColor *)lineBackgroundColor {
    _lineBackgroundColor = lineBackgroundColor;
    [self.upLines enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = lineBackgroundColor;
        self.downLines[idx].backgroundColor = lineBackgroundColor;
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

- (NSMutableArray<NSNumber *> *)animationOfSelectedRowList {
    if (!_animationOfSelectedRowList) {
        _animationOfSelectedRowList = [NSMutableArray array];
    }
    return _animationOfSelectedRowList;
}

- (NSMutableArray<NSNumber *> *)numberOfSelectedRowList {
    if (!_numberOfSelectedRowList) {
        _numberOfSelectedRowList = [NSMutableArray array];
    }
    return _numberOfSelectedRowList;
}

- (NSMutableArray<NSNumber *> *)numberOfSelectedComponentList {
    if (!_numberOfSelectedComponentList) {
        _numberOfSelectedComponentList = [NSMutableArray array];
    }
    return _numberOfSelectedComponentList;
}

@end
