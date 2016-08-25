//
//  HADiscountEditorCell.m
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HADiscountEditorCell.h"
#import "HAPickerTextField.h"
#import "HADiscountDataSourceDelegate.h"

@interface HADiscountEditorCell ()<HAEditPickerDelegate,HAPickerTextFieldDelegate,UITextFieldDelegate>

@property (nonatomic,strong) HAPickerTextField* textField;

@property (nonatomic,strong) HADiscountDataSourceDelegate* dataSourceDelegate;

@end

@implementation HADiscountEditorCell

#pragma mark - *** Properties ***
- (HAPickerTextField*)textField
{
    if (!_textField) {
        _textField = [[HAPickerTextField alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
        _textField.font = [UIFont systemFontOfSize:14.0f];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

- (HADiscountDataSourceDelegate*) dataSourceDelegate
{
    if (!_dataSourceDelegate) {
        _dataSourceDelegate = [[HADiscountDataSourceDelegate alloc] init];
        _dataSourceDelegate.resultDelegate = self;
    }
    return _dataSourceDelegate;
}


#pragma mark - *** Init ***
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textLabel.font = [UIFont systemFontOfSize:15.0f];
    self.textField.pickerDelegate = self;
    self.textField.pickerView.dataSource = self.dataSourceDelegate;
    self.textField.pickerView.delegate = self.dataSourceDelegate;
    self.dataSourceDelegate.resultDelegate = self;
    self.textField.delegate = self;
    self.accessoryView = self.textField;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUnitName:(NSString *)unitName
{
    _unitName = [unitName copy];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 21)];
    label.text = unitName;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12.0f];
    self.textField.rightView = label;
}


#pragma mark - *** HAPickerTextFieldDelegate ***
- (void)selectedObjectDoneForPickerTextField:(HAPickerTextField*)pickerTF
{
    self.textField.text = self.dataSourceDelegate.selectResult;
    if ([self.delegate respondsToSelector:@selector(selectItemDoneForPickerTextField:fromCell:)]) {
        [self.delegate selectItemDoneForPickerTextField:self.textField fromCell:self];
    }
}


#pragma mark - ***PickerViewDidSelectResultDelegate ***
- (void)pickerView:(UIPickerView *)pickerView didSelectResultText:(NSString*)text
{
    self.textField.text = text;
}


#pragma mark - *** UITextFieldDelegate ***

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:fromCell:)]) {
        return [self.delegate textFieldShouldBeginEditing:textField fromCell:self];
    }
    return YES;
}
@end
