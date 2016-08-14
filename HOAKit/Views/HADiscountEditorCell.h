//
//  HADiscountEditorCell.h
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HAPickerTextField;

@protocol HADiscountEditorCellDelegate <NSObject>

- (void)selectItemDoneForPickerTextField:(UITextField*)textfield
                                fromCell:(UITableViewCell*) cell;
@end




@interface HADiscountEditorCell : UITableViewCell

//@property (nonatomic,readonly) HAPickerTextField* textField;

@property (nonatomic,weak) id<HADiscountEditorCellDelegate> delegate;

@property (nonatomic,copy) NSString* unitName;


@end
