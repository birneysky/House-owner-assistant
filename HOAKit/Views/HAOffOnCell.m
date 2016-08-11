//
//  HAOffOnCell.m
//  HOAKit
//
//  Created by zhangguang on 16/8/8.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAOffOnCell.h"

@interface HAOffOnCell ()

@property (nonatomic,strong) UIButton* onOff;

@end

@implementation HAOffOnCell

#pragma mark - *** Properties ***
- (UIButton*) onOff
{
    if (!_onOff) {
        _onOff = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_onOff setImage:[UIImage imageNamed:@"HOAKit.bundle/HA_Unselected_Icon"] forState:UIControlStateNormal];
        [_onOff setImage:[UIImage imageNamed:@"HOAKit.bundle/HA_selected_Icon"] forState:UIControlStateSelected];
        [_onOff addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _onOff;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textLabel.font = [UIFont systemFontOfSize:15.0f];
    self.accessoryView = self.onOff;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setAccessoryViewSelected:(BOOL)accessoryViewSelected
{
    _accessoryViewSelected = accessoryViewSelected;
    self.onOff.selected = _accessoryViewSelected;
}

#pragma mark - *** Target Action ***
- (void)switchChange:(id)sender
{
    self.onOff.selected = !self.onOff.selected;
    _accessoryViewSelected = self.onOff.selected;
    if ([self.delegate respondsToSelector:@selector(offONButtonChangedFromCell:sender:)]) {
        [self.delegate offONButtonChangedFromCell:self sender:self.onOff];
    }
}


@end

