//
//  HAHouseInfoItem.h
//  HOAKit
//
//  Created by birneysky on 16/8/23.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseInfoBaseCell.h"

@protocol HAHouseInfoItemCellDelegate <NSObject>

@optional
-(void)changePriceButtonClickedOfCell:(UITableViewCell*)cell;

@end

@interface HAHouseInfoItemCell : HAHouseInfoBaseCell

@property (nonatomic,weak) id<HAHouseInfoItemCellDelegate> delegate;

@end
