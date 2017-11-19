//
//  PGPickerView.h
//  PGPickerView
//
//  Created by piggybear on 2017/7/26.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PGPickerViewType) {
    PGPickerViewType1,
    PGPickerViewType2,
    PGPickerViewType3,
};

@protocol PGPickerViewDataSource, PGPickerViewDelegate;
@interface PGPickerView : UIView
@property(nonatomic, assign) PGPickerViewType type;
@property(nonatomic,weak) id<PGPickerViewDataSource> dataSource;    // default is nil. weak reference
@property(nonatomic,weak) id<PGPickerViewDelegate>   delegate;      // default is nil. weak reference

@property(nonatomic, strong) UIColor *lineBackgroundColor;          // default is [UIColor grayColor]
@property (nonatomic, assign) CGFloat lineHeight;                   // default is 0.5

@property(nonatomic, strong) UIColor *verticalLineBackgroundColor; // default is [UIColor grayColor] type3 vertical line
@property (nonatomic, assign) CGFloat verticalLineWidth; // default is 0.5

@property (nonatomic, strong)UIColor *textColorOfSelectedRow;     // [UIColor blackColor]
@property(nonatomic, strong) UIFont *textFontOfSelectedRow;

@property (nonatomic, strong)UIColor *textColorOfOtherRow;        // default is [UIColor grayColor]
@property(nonatomic, strong) UIFont *textFontOfOtherRow;

// info that was fetched and cached from the data source and delegate
@property(nonatomic,readonly) NSInteger numberOfComponents;

@property (nonatomic) CGFloat rowHeight;             // default is 44

@property(nonatomic, assign) BOOL isHiddenMiddleText; // default is true  true -> hidden
@property(nonatomic, strong) UIColor *middleTextColor;
@property(nonatomic, strong) UIFont *middleTextFont;

- (NSInteger)numberOfRowsInComponent:(NSInteger)component;

// selection. in this case, it means showing the appropriate row in the middle
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;// scrolls the specified row to center.

- (NSInteger)selectedRowInComponent:(NSInteger)component;// returns selected row. -1 if nothing selected
- (NSString *)textOfSelectedRowInComponent:(NSInteger)component;
// Reloading whole view or single component
- (void)reloadAllComponents;
- (void)reloadComponent:(NSInteger)component;
- (void)reloadComponent:(NSInteger)component refresh:(BOOL)refresh;
@end

@protocol PGPickerViewDataSource<NSObject>
@required
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(PGPickerView *)pickerView;

// returns the # of rows in each component..
- (NSInteger)pickerView:(PGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
@end

@protocol PGPickerViewDelegate<NSObject>
@optional
// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(PGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (NSAttributedString *)pickerView:(PGPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component; // attributed title is favored if both methods are implemented
- (UIColor *)pickerView:(PGPickerView *)pickerView viewBackgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component;

- (void)pickerView:(PGPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)pickerView:(PGPickerView *)pickerView title:(NSString *)title didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

- (CGFloat)rowHeightInPickerView:(PGPickerView *)pickerView forComponent:(NSInteger)component;

- (NSString *)pickerView:(PGPickerView *)pickerView middleTextForcomponent:(NSInteger)component;
- (CGFloat)pickerView:(PGPickerView *)pickerView middleTextSpaceForcomponent:(NSInteger)component;

// type is PGPickerViewType3 vertical line
- (UIColor *)pickerView:(PGPickerView *)pickerView verticalLineBackgroundColorForComponent:(NSInteger)component;
- (CGFloat)pickerView:(PGPickerView *)pickerView verticalLineWidthForComponent:(NSInteger)component;

- (UIColor *)pickerView:(PGPickerView *)pickerView upLineBackgroundColorForComponent:(NSInteger)component;
- (UIColor *)pickerView:(PGPickerView *)pickerView downLineBackgroundColorForComponent:(NSInteger)component;

- (CGFloat)pickerView:(PGPickerView *)pickerView upLineHeightForComponent:(NSInteger)component;
- (CGFloat)pickerView:(PGPickerView *)pickerView downLineHeightForComponent:(NSInteger)component;

- (UIFont *)pickerView:(PGPickerView *)pickerView textFontOfSelectedRowInComponent:(NSInteger)component;
- (UIFont *)pickerView:(PGPickerView *)pickerView textFontOfOtherRowInComponent:(NSInteger)component;

- (UIColor *)pickerView:(PGPickerView *)pickerView textColorOfSelectedRowInComponent:(NSInteger)component;
- (UIColor *)pickerView:(PGPickerView *)pickerView textColorOfOtherRowInComponent:(NSInteger)component;

- (UIFont *)pickerView:(PGPickerView *)pickerView textFontOfOtherRow:(NSInteger)row InComponent:(NSInteger)component;
- (UIColor *)pickerView:(PGPickerView *)pickerView textColorOfOtherRow:(NSInteger)row InComponent:(NSInteger)component;
@end
