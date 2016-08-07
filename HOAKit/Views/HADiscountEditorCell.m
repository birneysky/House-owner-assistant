//
//  HADiscountEditorCell.m
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HADiscountEditorCell.h"
#import "HADiscountPickerTextField.h"

@interface HADiscountEditorCell ()

@property (nonatomic,strong) UITextField* textField;

@end

@implementation HADiscountEditorCell

#pragma mark - *** Properties ***
- (UITextField*)textField
{
    if (!_textField) {
        _textField = [[HADiscountPickerTextField alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
        _textField.textAlignment = NSTextAlignmentRight;
    }
    return _textField;
}


#pragma mark - *** Init ***
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.accessoryView = self.textField;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
