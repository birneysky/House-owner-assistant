//
//  HAHouseBedViewController.h
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HADataExchangeDelegate.h"

@class HAHouseBed;


@interface HAHouseBedViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray<HAHouseBed*>* beds;

@property (nonatomic,assign) NSInteger houseId;

@property (nonatomic,weak) id<HADataExchangeDelegate> delegate;

@end
