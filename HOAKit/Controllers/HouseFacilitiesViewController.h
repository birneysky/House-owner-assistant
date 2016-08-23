//
//  HouseFacilitiesViewController.h
//  HOAKit
//
//  Created by zhangguang on 16/8/11.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HADataExchangeDelegate.h"

@class HAHouseFacility;


@interface HouseFacilitiesViewController : UITableViewController

@property (nonatomic,strong) HAHouseFacility* factilities;

@property (nonatomic,assign) NSInteger houseId;

@property (nonatomic,weak) id<HADataExchangeDelegate> delegate;

@end
