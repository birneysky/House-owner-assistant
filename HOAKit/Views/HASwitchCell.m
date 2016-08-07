//
//  HASwitchCell.m
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HASwitchCell.h"

@interface HASwitchCell ()

@property (nonatomic,strong) UISwitch* onOff;

@end

@implementation HASwitchCell

#pragma mark - *** Properties ***
- (UISwitch*) onOff
{
    if (!_onOff) {
        _onOff = [[UISwitch alloc] init];
    }
    return _onOff;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.accessoryView = self.onOff;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
