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

@property(nonatomic,weak) id<PGPickerViewDataSource> dataSource;    // default is nil. weak reference
@property(nonatomic,weak) id<PGPickerViewDelegate>   delegate;      // default is nil. weak reference
@property(nonatomic, strong) UIColor *lineBackgroundColor;          // default is [UIColor grayColor]
@property (nonatomic, strong)UIColor *titleColorForSelectedRow;     // [UIColor blackColor]
@property (nonatomic, strong)UIColor *titleColorForOtherRow;        // default is [UIColor grayColor]
// info that was fetched and cached from the data source and delegate
@property(nonatomic,readonly) NSInteger numberOfComponents;
@property(nonatomic, assign) PGPickerViewType pickerViewType;

@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) UIColor *textColor;
@property(nonatomic, assign) BOOL middleText;

- (NSInteger)numberOfRowsInComponent:(NSInteger)component;

// selection. in this case, it means showing the appropriate row in the middle
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;// scrolls the specified row to center.
- (NSInteger)selectedRowInComponent:(NSInteger)component;// returns selected row. -1 if nothing selected
- (NSString *)titleForSelectedRow:(NSInteger)row inComponent:(NSInteger)component;
- (NSString *)currentTitleInComponent:(NSInteger)component;
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
- (CGFloat)rowHeightInPickerView:(PGPickerView *)pickerView;

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(PGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (NSString *)pickerView:(PGPickerView *)pickerView textForcomponent:(NSInteger)component;
- (CGFloat)pickerView:(PGPickerView *)pickerView textSpaceForcomponent:(NSInteger)component;
- (NSAttributedString *)pickerView:(PGPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component; // attributed title is favored if both methods are implemented
- (UIColor *)pickerView:(PGPickerView *)pickerView viewBackgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component;

- (void)pickerView:(PGPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)pickerView:(PGPickerView *)pickerView title:(NSString *)title didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end
