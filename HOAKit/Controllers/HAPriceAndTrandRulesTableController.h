//
//  HAPriceAndTrandRulesTableController.h
//  HOAKit
//
//  Created by zhangguang on 16/8/2.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HADataExchangeDelegate.h"

@class HAHouse;


@interface HAPriceAndTrandRulesTableController : UITableViewController

@property (nonatomic,strong) HAHouse* house;

@property (nonatomic,assign) BOOL changePrice;

@property (nonatomic,weak) id<HADataExchangeDelegate> delegate;

@end
