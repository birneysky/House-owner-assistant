//
//  HAHouseInfoViewController.h
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HADataExchangeDelegate.h"

@class HAHouse;


@interface HAHouseInfoViewController : UITableViewController

@property(nonatomic,strong) HAHouse* house;

@property(nonatomic,weak) id<HADataExchangeDelegate> delegate;

@end
