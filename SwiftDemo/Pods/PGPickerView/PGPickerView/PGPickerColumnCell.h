//
//  PGPickerColumnCell.h
//  PGPickerView
//
//  Created by piggybear on 2017/7/26.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGPickerColumnCell : UITableViewCell
@property (nonatomic, weak) UILabel *label;

- (void)transformWith:(CGFloat)angle scale:(CGFloat)scale;

@end
