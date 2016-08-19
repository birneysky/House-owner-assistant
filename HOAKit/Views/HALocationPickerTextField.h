//
//  HALocationPickerTextField.h
//  House-owner-assistant
//
//  Created by zhangguang on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAPickerTextField.h"

@class HALocationPickerTextField;

@protocol HALocationPickerTextFieldDelegate <NSObject>

//- (void)selectedObjectID:(NSManagedObjectID*)objectID changedForPickerTF:(CoreDataPickerTF*)pickerTF;

- (void)selectedObjectChangedForPickerTextField:(HALocationPickerTextField*)pickerTF address:(NSString*)address province:(NSInteger)pid city:(NSInteger)cid distict:(NSInteger)did;

@optional

//- (void)selectedObjectClearedForPickerTF:(CoreDataPickerTF*)pickerTF;

- (void)selectedObjectClearForPickTextField:(HALocationPickerTextField*)pickerTF;


@end


@interface HALocationPickerTextField : HAPickerTextField

@property (nonatomic,weak) id<HALocationPickerTextFieldDelegate> locationPickerDelegate;

@property (nonatomic,readonly) UIPickerView* picker;


@end
