//
//  HAEditorCell.m
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAEditorNumberCell.h"

@interface HAEditorNumberCell () <UITextFieldDelegate>

@property (nonatomic,strong) UITextField* textField;

@end

@implementation HAEditorNumberCell


#pragma mark - *** Properties ***
- (UITextField*) textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _textField.rightViewMode = UITextFieldViewModeAlways;
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.returnKeyType = UIReturnKeyNext;
        _textField.keyboardType  = UIKeyboardTypeDecimalPad;
    }
    return _textField;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryView = self.textField;    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setUnitName:(NSString *)unitName
{
    _unitName = [unitName copy];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 21)];
    label.text = unitName;
    label.textAlignment = NSTextAlignmentCenter;
    self.textField.rightView = label;
}

@end
