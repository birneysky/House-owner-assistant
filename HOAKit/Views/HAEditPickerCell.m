//
//  HAEditPickerCell.m
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAEditPickerCell.h"
#import "HAPickerTextField.h"

@interface HAEditPickerCell ()<UITextFieldDelegate,HAPickerTextFieldDelegate,HAEditPickerDelegate>

@property (nonatomic,strong) HAPickerTextField* textField;

@end

@implementation HAEditPickerCell

#pragma mark - *** Properties ***
- (HAPickerTextField*)textField
{
    if (!_textField) {
        _textField = [[HAPickerTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.delegate = self;
    }
    return _textField;
}

//- (HADiscountDataSourceDelegate*) dataSourceDelegate
//{
//    if (!_dataSourceDelegate) {
//        _dataSourceDelegate = [[HADiscountDataSourceDelegate alloc] init];
//    }
//    return _dataSourceDelegate;
//}


#pragma mark - *** Init ***
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textLabel.font = [UIFont systemFontOfSize:15.0f];
    self.textField.pickerDelegate = self;
//    self.textField.pickerView.dataSource = self.dataSourceDelegate;
//    self.textField.pickerView.delegate = self.dataSourceDelegate;
    //self.dataSourceDelegate.resultDelegate = self;
    
    UIImageView* rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HOAKit.bundle/HA_Arrow_Right"]];
    //rect.origin.x += 5;
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    self.textField.rightView = rightView;
    self.accessoryView = self.textField;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setPickerDataSouce:(id<UIPickerViewDelegate,UIPickerViewDataSource>)pickerDataSouce
{
    _pickerDataSouce = pickerDataSouce;
    self.textField.pickerView.dataSource = _pickerDataSouce;
    self.textField.pickerView.delegate = _pickerDataSouce;
    _pickerDataSouce.resultDelegate = self;
}

#pragma mark - *** HAPickerTextFieldDelegate ***
- (void)selectedObjectDoneForPickerTextField:(HAPickerTextField*)pickerTF
{
    self.textField.text = self.pickerDataSouce.selectResult;
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
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
  
}

@end
