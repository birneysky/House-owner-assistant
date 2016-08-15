//
//  HouseFacilitiesViewController.h
//  HOAKit
//
//  Created by zhangguang on 16/8/11.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HAHouseFacility;

@interface HouseFacilitiesViewController : UITableViewController

@property (nonatomic,strong) HAHouseFacility* factilities;

@property (nonatomic,assign) NSInteger houseId;

@end
