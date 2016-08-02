//
//  HALocationPickerTextField.h
//  House-owner-assistant
//
//  Created by zhangguang on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HALocationPickerTextField;

@protocol HALocationPickerTextFieldDelegate <NSObject>

//- (void)selectedObjectID:(NSManagedObjectID*)objectID changedForPickerTF:(CoreDataPickerTF*)pickerTF;

- (void)selectedObjectChangedForPickerTextField:(HALocationPickerTextField*)pickerTF address:(NSString*)address latitude:(double)lat longitude:(double)lng;

@optional

//- (void)selectedObjectClearedForPickerTF:(CoreDataPickerTF*)pickerTF;

- (void)selectedObjectClearForPickTextField:(HALocationPickerTextField*)pickerTF;


@end


@interface HALocationPickerTextField : UITextField

@property (nonatomic,weak) id<HALocationPickerTextFieldDelegate> pickerDelegate;

@property (nonatomic,assign) BOOL showToolbar;

@end
