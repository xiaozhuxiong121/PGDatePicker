//
//  PGDatePickManagerHeaderView.h
//
//  Created by piggybear on 2018/1/7.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGEnumeration.h"

typedef void(^handlerBlock)();

@interface PGDatePickManagerHeaderView : UIView

@property (nonatomic, assign) PGDatePickManagerStyle style;

@property (nonatomic, copy)  handlerBlock cancelButtonHandlerBlock;
@property (nonatomic, copy)  handlerBlock confirmButtonHandlerBlock;

@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UIButton *confirmButton;
@property (nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, copy) NSString *language;

@property (nonatomic, copy) NSString *cancelButtonText;
@property (nonatomic, copy) UIFont *cancelButtonFont;
@property (nonatomic, copy) UIColor *cancelButtonTextColor;

@property (nonatomic, copy) NSString *confirmButtonText;
@property (nonatomic, copy) UIFont *confirmButtonFont;
@property (nonatomic, copy) UIColor *confirmButtonTextColor;
@end
