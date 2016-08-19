//
//  HADiscountPickerTextField.m
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HADiscountPickerTextField.h"
#import "HAEditPickerDelegate.h"
#import "HADiscountDataSourceDelegate.h"

@interface HADiscountPickerTextField () <HAEditPickerDelegate,HAPickerTextFieldDelegate>

@property (nonatomic,strong) HADiscountDataSourceDelegate* dataSourceDelegate;

@end

@implementation HADiscountPickerTextField

#pragma mark - *** Properties ***
- (HADiscountDataSourceDelegate*) dataSourceDelegate
{
    if (!_dataSourceDelegate) {
        _dataSourceDelegate = [[HADiscountDataSourceDelegate alloc] init];
    }
    return _dataSourceDelegate;
}

#pragma mark - *** Init ***

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self config];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

- (instancetype) init
{
    if (self = [super init]) {
        [self config];
    }
    return self;
}

- (void)config{
    self.pickerDelegate = self;
    self.pickerView.dataSource = self.dataSourceDelegate;
    self.pickerView.delegate = self.dataSourceDelegate;
    self.dataSourceDelegate.resultDelegate = self;
}

#pragma mark - *** HAPickerTextFieldDelegate ***
- (void)selectedObjectDoneForPickerTextField:(HAPickerTextField*)pickerTF
{

}


#pragma mark - ***PickerViewDidSelectResultDelegate ***
- (void)pickerView:(UIPickerView *)pickerView didSelectResultText:(NSString*)text
{
    self.text = text;
}


@end
