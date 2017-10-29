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

@property (nonatomic, weak) PGPickerTableView *tableView;
@property (nonatomic, assign) CGPoint upTableViewOriginalOffset;
@property (nonatomic, assign) CGPoint downTableViewOriginalOffset;
@property (nonatomic, assign) NSUInteger upTableViewOffsetForRow;
@end

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height
#define kCellHeight 44
static NSString *const cellReuseIdentifier = @"PGPickerColumnCell";

@implementation PGPickerColumnView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupTableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _layoutedSubViews = true;
    if (_isSelectRow) {
        if (!_selectRowAnimation) {
            self.selectedRow = _selectedRow;
        }
        _beginning = true;
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0] animated:_selectRowAnimation scrollPosition:UITableViewScrollPositionTop];
        _isSelectRow = false;
    }
}

- (void)setupTableView {
    PGPickerTableView *tableView = [[PGPickerTableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    [tableView registerClass:[PGPickerColumnCell class] forCellReuseIdentifier:cellReuseIdentifier];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = false;
    tableView.showsHorizontalScrollIndicator = false;
    [self addSubview:tableView];
    self.tableView = tableView;
    [self bringSubviewToFront:tableView];
}

- (void)selectRow:(NSInteger)row animated:(BOOL)animated {
    if (self.datas.count == 0 || self.datas.count == 1 || self.datas.count <= row) {
        return;
    }
    _selectedRow = row;
    _isSelectRow = !_layoutedSubViews;
    _selectRowAnimation = animated;
    if (_layoutedSubViews) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:animated scrollPosition:UITableViewScrollPositionTop];
        self.selectedRow = row;
        _beginning = true;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UITableView *)tableView {
    CGPoint offset = tableView.contentOffset;
    if (!_beginning || self.datas.count == 1) {
        return;
    }
    self.tableView.contentOffset = CGPointMake(0, offset.y);
}

- (void)scrollViewWillBeginDragging:(UITableView *)tableView {
    _beginning = true;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) return;
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.datas.count != 0) {
        NSUInteger row = [self.tableView indexPathsForVisibleRows].lastObject.row;
        self.selectedRow = row - 4;
    }
}

- (void)scrollViewDidEndDecelerating:(UITableView *)tableView {
    NSInteger index =  self.tableView.contentOffset.y / kCellHeight + 0.5;
    [self selectRow:index animated:true];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        NSIndexPath *selectIndexPath = [tableView indexPathForSelectedRow];
    [self selectRow:selectIndexPath.row - 2 animated:true];
    _beginning = true;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PGPickerViewConfig instance].tableViewHeightForRow;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    PGPickerColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    NSUInteger index = indexPath.row - 2;
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.label.text = @"";
        cell.label.backgroundColor = [UIColor clearColor];
        return cell;
    }
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

#pragma mark - Getter

- (NSString *)currentString {
    NSInteger index =  self.tableView.contentOffset.y / kCellHeight + 0.5;
    self.currentRow = index;
    NSAttributedString *attriString = self.datas[index];
    return attriString.string;
}

#pragma mark - Setter

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    [self.tableView reloadData];
    NSInteger index =  self.tableView.contentOffset.y / kCellHeight + 0.5;
    self.currentRow = index;
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
    [self.tableView reloadData];
}

- (void)setTitleColorForOtherRow:(UIColor *)titleColorForOtherRow {
    _titleColorForOtherRow = titleColorForOtherRow;
    [self.tableView reloadData];
}

@end

