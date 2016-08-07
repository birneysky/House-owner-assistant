//
//  HASwitchCell.h
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HASwitchCellDelegate <NSObject>

@optional
-(void)switchButtonChangedFromCell:(UITableViewCell*)cell sender:(UISwitch*)sender;

@end

@interface HASwitchCell : UITableViewCell

@property (nonatomic,readonly) UISwitch* onOff;

@property(nonatomic,weak) id<HASwitchCellDelegate> delegate;

@end
