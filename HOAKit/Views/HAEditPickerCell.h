//
//  HAEditPickerCell.h
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAEditPickerDataSourceDelegate.h"
#import "HAPickerTextField.h"

@protocol HAEditPickerCellDelegate <NSObject>

- (void)selectItemDoneForPickerTextField:(UITextField*)textfield
                                fromCell:(UITableViewCell*) cell;

- (BOOL) textFieldShouldBeginEditing:(UITextField*)textField
                            fromCell:(UITableViewCell*)cell;
@end



@interface HAEditPickerCell : UITableViewCell

@property (nonatomic,readonly) HAPickerTextField* textField;

@property (nonatomic,weak) HAEditPickerDataSourceDelegate* pickerDataSouce;

@property (nonatomic,weak) id<HAEditPickerCellDelegate> delegate;


@end
