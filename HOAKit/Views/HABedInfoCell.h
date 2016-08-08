//
//  BedInfoCell.h
//  HOAKit
//
//  Created by zhangguang on 16/8/8.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HABedInfoCellDelegate <NSObject>

@optional
-(void)deleteButtonClickedFromCell:(UITableViewCell*)cell sender:(UIButton*)sender;

@end

@interface HABedInfoCell : UITableViewCell

@property(nonatomic,weak) id<HABedInfoCellDelegate> delegate;

@property(nonatomic,copy) NSString* typeText;

@property(nonatomic,copy) NSString* sizeText;

@end
