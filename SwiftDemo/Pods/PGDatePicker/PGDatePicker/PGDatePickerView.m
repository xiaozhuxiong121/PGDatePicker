//
//  PGDatePickerView.m
//
//  Created by piggybear on 2017/7/25.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "PGDatePickerView.h"
#import "UIColor+PGHex.h"

@interface PGDatePickerView()
@property (nonatomic, weak) UILabel *label;
@end

@implementation PGDatePickerView
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [self.content sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    self.label.frame = (CGRect){{self.contentView.bounds.size.width / 2 - size.width / 2,
        self.contentView.bounds.size.height / 2 - size.height / 2}, size};
}

#pragma Setter
- (void)setCurrentDate:(BOOL)currentDate {
    _currentDate = currentDate;
    if (currentDate) {
        self.label.textColor = [UIColor colorWithHexString:@"#FAD9A2"];
    }else {
        self.label.textColor = [UIColor colorWithHexString:@"#838383"];
    }
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.label.text = content;
}

#pragma Getter
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:label];
        _label = label;
    }
    return _label;
}

@end
