//
//  HAEditPickerCell.h
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAEditPickerDataSourceDelegate.h"

@protocol HAEditPickerCellDelegate <NSObject>

- (void)selectItemDoneForPickerTextField:(UITextField*)textfield
                                fromCell:(UITableViewCell*) cell;
@end

@interface HAEditPickerCell : UITableViewCell

@property (nonatomic,weak) HAEditPickerDataSourceDelegate* pickerDataSouce;

@property (nonatomic,weak) id<HAEditPickerCellDelegate> delegate;

@end
