//
//  HAPublishHouseInfoTableViewController.h
//  House-owner-assistant
//
//  Created by zhangguang on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HAHouseFullInfo;

@interface HAPublishHouseInfoTableViewController : UITableViewController

@property (nonatomic,assign) NSInteger houseId;

@property(nonatomic,strong) HAHouseFullInfo* houseFullInfo;

@end
