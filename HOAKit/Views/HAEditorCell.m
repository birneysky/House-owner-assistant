//
//  HAEditorCell.m
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAEditorCell.h"

@interface HAEditorCell () <UITextFieldDelegate>

@property (nonatomic,strong) UITextField* textField;

@end

@implementation HAEditorCell


#pragma mark - *** Properties ***
- (UITextField*) textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    }
    return _textField;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryView = self.textField;    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
