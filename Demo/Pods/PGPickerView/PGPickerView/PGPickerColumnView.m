//
//  PGPickerColumnView.m
//  PGPickerView
//
//  Created by piggybear on 2017/7/26.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "PGPickerColumnView.h"
#import "PGPickerColumnCell.h"
#import "PGPickerViewMacros.h"
#import "PGPickerTableView.h"
#import "PGPickerViewConfig.h"

@interface PGPickerColumnView()<UITableViewDelegate, UITableViewDataSource> {
    BOOL _beginning;
    BOOL _isSelectRow;
    BOOL _layoutedSubViews;
    BOOL _selectRowAnimation;
    NSUInteger _selectRow;
}
@property (nonatomic, weak) UIView *upView;
@property (nonatomic, weak) UIView *centerView;
@property (nonatomic, weak) UIView *downView;
@property (nonatomic, weak) PGPickerTableView *upTableView;
@property (nonatomic, weak) PGPickerTableView *centerTableView;
@property (nonatomic, weak) PGPickerTableView *downTableView;
@property (nonatomic, assign) CGPoint upTableViewOriginalOffset;
@property (nonatomic, assign) CGPoint downTableViewOriginalOffset;
@property (nonatomic, assign) NSUInteger upTableViewOffsetForRow;
@end

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height

static NSString *const cellReuseIdentifier = @"PGPickerColumnCell";

@implementation PGPickerColumnView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.datas.count > self.upTableViewOffsetForRow) {
        [self.upTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.upTableViewOffsetForRow inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:false];
        self.upTableViewOriginalOffset = self.upTableView.contentOffset;
    }
    if (self.datas.count > 1) {
        [self.downTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
        self.downTableViewOriginalOffset = self.downTableView.contentOffset;
    }
    _layoutedSubViews = true;
    if (_isSelectRow) {
        if (!_selectRowAnimation) {
            self.selectedRow = _selectedRow;
        }
        _beginning = true;
        [self.centerTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0] animated:_selectRowAnimation scrollPosition:UITableViewScrollPositionMiddle];
        _isSelectRow = false;
    }
}

- (void)setupView {
    CGFloat upViewPosY = kHeight / 2 - [PGPickerViewConfig instance].tableViewHeightForRow / 2 - kLineHeight / 2;
    CGFloat centerViewPosY = upViewPosY;
    CGFloat downViewPosY = centerViewPosY + [PGPickerViewConfig instance].tableViewHeightForRow;
    
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, upViewPosY)];
    upView.backgroundColor = [UIColor clearColor];
    [self addSubview:upView];
    self.upView = upView;
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, downViewPosY, kWidth, kHeight - downViewPosY)];
    downView.backgroundColor = [UIColor clearColor];
    [self addSubview:downView];
    self.downView = downView;
    
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, centerViewPosY, kWidth, [PGPickerViewConfig instance].tableViewHeightForRow)];
    centerView.backgroundColor = [UIColor clearColor];
    [self addSubview:centerView];
    self.centerView = centerView;
    [self setupTableView];
}

- (void)setupTableView {
    {
        PGPickerTableView *tableView = [[PGPickerTableView alloc]initWithFrame:self.upView.bounds style:UITableViewStylePlain];
        [tableView registerClass:[PGPickerColumnCell class] forCellReuseIdentifier:cellReuseIdentifier];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = false;
        tableView.showsHorizontalScrollIndicator = false;
        [self.upView addSubview:tableView];
        self.upView.clipsToBounds = true;
        self.upTableView = tableView;
    }
    {
        PGPickerTableView *tableView = [[PGPickerTableView alloc]initWithFrame:self.centerView.bounds style:UITableViewStylePlain];
        [tableView registerClass:[PGPickerColumnCell class] forCellReuseIdentifier:cellReuseIdentifier];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = false;
        tableView.showsHorizontalScrollIndicator = false;
        [self.centerView addSubview:tableView];
        self.centerTableView = tableView;
        [self bringSubviewToFront:tableView];
        self.centerView.clipsToBounds = true;
    }
    
    {
        PGPickerTableView *tableView = [[PGPickerTableView alloc]initWithFrame:self.downView.bounds style:UITableViewStylePlain];
        [tableView registerClass:[PGPickerColumnCell class] forCellReuseIdentifier:cellReuseIdentifier];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = false;
        tableView.showsHorizontalScrollIndicator = false;
        [self.downView addSubview:tableView];
        self.downView.clipsToBounds = true;
        self.downTableView = tableView;
    }
    
    CGFloat temp = (kHeight - [PGPickerViewConfig instance].tableViewHeightForRow) / 2;
    self.upTableViewOffsetForRow = floor(temp / [PGPickerViewConfig instance].tableViewHeightForRow);
    [self.upTableView layoutIfNeeded];
    [self.downTableView layoutIfNeeded];
}

- (void)selectRow:(NSInteger)row animated:(BOOL)animated {
    if (self.datas.count == 0 || self.datas.count == 1 || self.datas.count <= row) {
        return;
    }
    _selectedRow = row;
    _isSelectRow = !_layoutedSubViews;
    _selectRowAnimation = animated;
    if (_layoutedSubViews) {
        if (!animated) {
            self.selectedRow = row;
        }
        _beginning = true;
        [self.centerTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:animated scrollPosition:UITableViewScrollPositionMiddle];
    }
}

#pragma mark - row logic
- (NSUInteger)numberOfRowsInTableView:(UITableView *)tableView {
    if (tableView == self.centerTableView) {
        return self.datas.count;
    }
    if (self.datas.count == 1) {
        return 0;
    }
    return self.datas.count + self.upTableViewOffsetForRow + 1;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UITableView *)tableView {
    _beginning = true;
}

- (void)scrollViewDidScroll:(UITableView *)tableView {
    CGPoint offset = tableView.contentOffset;
    if (!_beginning || self.datas.count == 1) {
        return;
    }
    if (self.centerTableView == tableView) {
        self.upTableView.contentOffset = CGPointMake(0, self.upTableViewOriginalOffset.y + offset.y);
        self.downTableView.contentOffset = CGPointMake(0, self.downTableViewOriginalOffset.y + offset.y);
        return;
    }
    if (tableView == self.downTableView) {
        self.centerTableView.contentOffset = CGPointMake(0, offset.y - self.downTableViewOriginalOffset.y);
        return;
    }
    if (tableView == self.upTableView) {
        self.centerTableView.contentOffset = CGPointMake(0, offset.y - self.upTableViewOriginalOffset.y);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) return;
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.datas.count != 0) {
        NSUInteger row = [self.centerTableView indexPathsForVisibleRows].lastObject.row;
        self.selectedRow = row;
    }
}

- (void)scrollViewDidEndDecelerating:(UITableView *)tableView {
    if (self.datas.count == 1) {
        self.selectedRow = 1;
        return;
    }
    NSUInteger tableViewRows = [self numberOfRowsInTableView:tableView];
    if (self.upTableView == tableView) {
        if (tableView.contentOffset.y <= 0) {
            NSUInteger row = self.upTableViewOffsetForRow;
            if (tableViewRows > row) {
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
            }
        }else if (tableView.contentOffset.y >= [PGPickerViewConfig instance].tableViewHeightForRow * self.datas.count + self.upTableViewOriginalOffset.y - [PGPickerViewConfig instance].tableViewHeightForRow / 2)  {
            NSUInteger row = self.upTableViewOffsetForRow + self.datas.count - 1;
            if (tableViewRows > row) {
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
            }
        }else {
            NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:CGPointMake(tableView.contentOffset.x, tableView.contentOffset.y + [PGPickerViewConfig instance].tableViewHeightForRow * self.upTableViewOffsetForRow - self.upTableViewOriginalOffset.y + [PGPickerViewConfig instance].tableViewHeightForRow / 2)];
            if (tableViewRows > indexPath.row) {
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:true];
            }
        }
        return;
    }
    if (tableView == self.downTableView) {
        if (tableView.contentOffset.y <= [PGPickerViewConfig instance].tableViewHeightForRow / 2) {
            NSUInteger row = 1;
            if (tableViewRows > row) {
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
            }
        }else if (tableView.contentOffset.y >= [PGPickerViewConfig instance].tableViewHeightForRow * (self.datas.count + 1) - self.downTableViewOriginalOffset.y)  {
            NSUInteger row = self.upTableViewOffsetForRow + self.datas.count - self.upTableViewOffsetForRow;
            if (tableViewRows > row) {
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
            }
        }else {
            NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:CGPointMake(tableView.contentOffset.x, tableView.contentOffset.y + [PGPickerViewConfig instance].tableViewHeightForRow / 2)];
            if (tableViewRows > indexPath.row) {
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
            }
        }
        return;
    }
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:CGPointMake(tableView.contentOffset.x, tableView.contentOffset.y + [PGPickerViewConfig instance].tableViewHeightForRow / 2)];
    if (tableViewRows > indexPath.row) {
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSIndexPath *selectIndexPath = [tableView indexPathForSelectedRow];
    _beginning = true;
    if (tableView == self.downTableView) {
        NSUInteger index = indexPath.row + 1;
        if (self.datas.count >= index) {
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0] animated:true scrollPosition:UITableViewScrollPositionTop];
        }
    }else if (tableView == self.upTableView && indexPath.row != self.upTableViewOffsetForRow) {
        if (indexPath.row > self.upTableViewOffsetForRow) {
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0] animated:true scrollPosition:UITableViewScrollPositionBottom];
        }
        if (indexPath.row == self.datas.count + self.upTableViewOffsetForRow) {
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 2 inSection:0] animated:true scrollPosition:UITableViewScrollPositionBottom];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PGPickerViewConfig instance].tableViewHeightForRow;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsInTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    PGPickerColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (self.upTableView == tableView) {
        if (indexPath.row <= self.upTableViewOffsetForRow) {
            cell.label.text = @"";
            cell.label.backgroundColor = [UIColor clearColor];
        }else {
            NSUInteger index = indexPath.row - (self.upTableViewOffsetForRow + 1);
            if (index < self.datas.count) {
                cell.label.attributedText = self.datas[index];
                cell.label.textColor = self.titleColorForOtherRow;
                UIColor *color = self.viewBackgroundColors[index];
                if (color) {
                    cell.label.backgroundColor = color;
                }
            }else {
                cell.label.text = @"";
                cell.label.backgroundColor = [UIColor clearColor];
            }
        }
        return cell;
    }
    if (self.downTableView == tableView) {
        NSUInteger index = indexPath.row;
        if (index < self.datas.count) {
            cell.label.attributedText = self.datas[index];
            cell.label.textColor = self.titleColorForOtherRow;
            UIColor *color = self.viewBackgroundColors[index];
            if (color) {
                cell.label.backgroundColor = color;
            }
        }else {
            cell.label.text = @"";
            cell.label.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }
    NSUInteger index = indexPath.row;
    if (index < self.datas.count) {
        cell.label.attributedText = self.datas[index];
        cell.label.textColor = self.titleColorForSelectedRow;
        UIColor *color = self.viewBackgroundColors[index];
        if (color) {
            cell.label.backgroundColor = color;
        }
    }else {
        cell.label.text = @"";
        cell.label.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

#pragma mark - Setter

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    [self.upTableView reloadData];
    [self.downTableView reloadData];
    [self.centerTableView reloadData];
}

- (void)setSelectedRow:(NSUInteger)selectedRow {
    _selectedRow = selectedRow;
    if (self.datas.count > selectedRow) {
        NSAttributedString *attriString = self.datas[selectedRow];
        self.titleForSelectedRow = attriString.string;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerColumnView:didSelectRow:)]) {
        [self.delegate pickerColumnView:self didSelectRow:selectedRow];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerColumnView:title:didSelectRow:)]) {
        [self.delegate pickerColumnView:self title:self.titleForSelectedRow didSelectRow:selectedRow];
    }
}

- (void)setTitleColorForSelectedRow:(UIColor *)titleColorForSelectedRow {
    _titleColorForSelectedRow = titleColorForSelectedRow;
    [self.upTableView reloadData];
    [self.downTableView reloadData];
    [self.centerTableView reloadData];
}

- (void)setTitleColorForOtherRow:(UIColor *)titleColorForOtherRow {
    _titleColorForOtherRow = titleColorForOtherRow;
    [self.upTableView reloadData];
    [self.downTableView reloadData];
    [self.centerTableView reloadData];
}

@end

