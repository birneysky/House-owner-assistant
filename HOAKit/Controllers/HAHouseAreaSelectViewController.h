//
//  HAHouseAreaSelectViewController.h
//  HOAKit
//
//  Created by birneysky on 16/8/11.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HADataExchangeDelegate.h"

@class HAHouse;
@class HAHousePosition;

@interface HAHouseAreaSelectViewController : UIViewController

@property (nonatomic,strong) HAHouse* house;

@property (nonatomic,strong) NSArray<HAHousePosition*>* positionArray;

@property (nonatomic,weak) id<HADataExchangeDelegate> delegate;

@end
