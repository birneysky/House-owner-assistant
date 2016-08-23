//
//  HAHouseTypeTableViewController.h
//  House-owner-assistant
//
//  Created by zhangguang on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HADataExchangeDelegate.h"

@class HAHouse;


@interface HAHouseTypeTableViewController : UITableViewController

@property (nonatomic,strong) HAHouse* house;


@property (nonatomic,weak) id<HADataExchangeDelegate> delegate;

@end
