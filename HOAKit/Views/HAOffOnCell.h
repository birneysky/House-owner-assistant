//
//  HAOffOnCell.h
//  HOAKit
//
//  Created by zhangguang on 16/8/8.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HAOffOnCellDelegate <NSObject>

@optional
-(void)offONButtonChangedFromCell:(UITableViewCell*)cell sender:(UIButton*)sender;

- (BOOL) offOnButtonShouldResponseEvent:(UIButton*)offOnBtn
                            fromCell:(UITableViewCell*)cell;

@end

@interface HAOffOnCell : UITableViewCell

//@property (nonatomic,readonly) UIButton* onOff;

@property(nonatomic,weak) id<HAOffOnCellDelegate> delegate;

@property(nonatomic,assign) BOOL accessoryViewSelected;

@end
