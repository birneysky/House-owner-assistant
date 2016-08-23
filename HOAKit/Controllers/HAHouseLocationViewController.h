//
//  HAHouseLocationViewController.h
//  House-owner-assistant
//
//  Created by zhangguang on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAHouse.h"
#import "HADataExchangeDelegate.h"

typedef NS_ENUM(NSInteger,HAValueValidState) {
    HAValueValidStateNormal = 0b111,
    HAValueValidStateProvinceCity = 0b011,
    HAValueValidStateDetailAddress = 0b101,
    HAValueValidStateHouseNumber = 0b110,
};

@interface HAHouseLocationViewController : UIViewController

@property (nonatomic,strong) HAHouse* house;


@property (nonatomic,weak) id<HADataExchangeDelegate> delegate;

@end
