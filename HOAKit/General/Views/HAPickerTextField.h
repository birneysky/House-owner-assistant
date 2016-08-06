//
//  HAPickerTextField.h
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HAPickerTextField;

@protocol HAPickerTextFieldDelegate <NSObject>

- (void)selectedObjectDoneForPickerTextField:(HAPickerTextField*)pickerTF;

@optional

- (void)selectedObjectCancelForPickTextField:(HAPickerTextField*)pickerTF;

@end


@interface HAPickerTextField : UITextField

@property (nonatomic,weak) id<HAPickerTextFieldDelegate> pickerDelegate;

@property (nonatomic,readonly) UIPickerView* pickerView;

@property (nonatomic,assign) BOOL showToolbar;

@end
