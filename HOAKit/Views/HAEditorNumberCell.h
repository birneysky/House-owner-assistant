//
//  HAEditorCell.h
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HAEditorNumberCellDelegate <NSObject>

@optional
- (void) textFieldDidEndEditing:(UITextField*)textfield
                                fromCell:(UITableViewCell*) cell;
- (void) textFieldTextDidChange:(UITextField*)textfield
                     changeText:(NSString*)text
                       fromCell:(UITableViewCell*) cell;

- (BOOL) textFieldShouldBeginEditing:(UITextField*)textField
                            fromCell:(UITableViewCell*)cell;
@end

@interface HAEditorNumberCell : UITableViewCell

@property (nonatomic,readonly) UITextField* textField;

@property (nonatomic,weak) id<HAEditorNumberCellDelegate> delegate;

@property (nonatomic,copy) NSString* unitName;

@end
