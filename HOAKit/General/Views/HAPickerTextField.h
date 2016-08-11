//
//  HAPickerTextField.h
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HATextField.h"

@class HAPickerTextField;

@protocol HAPickerTextFieldDelegate <NSObject>

- (void)selectedObjectDoneForPickerTextField:(HAPickerTextField*)pickerTF;

@optional

- (void)selectedObjectCancelForPickTextField:(HAPickerTextField*)pickerTF;

@end


@interface HAPickerTextField : HATextField

@property (nonatomic,weak) id<HAPickerTextFieldDelegate> pickerDelegate;

@property (nonatomic,readonly) UIPickerView* pickerView;

@property (nonatomic,assign) BOOL showToolbar;

- (void) setDefultText:(NSString*)text;

@end
