//
//  HAHouseIntroduceViewController.h
//  HOAKit
//
//  Created by zhangguang on 16/8/2.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HADataExchangeDelegate.h"

@class HAHouse;


typedef NS_ENUM(NSInteger,PRTValidState) {
    PRTValidStateNormal = 0b111111,
    PRTValidStateTitle = 0b011111,
    PRTValidStateDescription = 0b101111,
    PRTValidStatePosition = 0b110111,
    PRTValidStateTraffic = 0b111011,
    
    PRTValidStateSurroundings = 0b111101,
    PRTValidStateRemarks = 0b111110
};

@interface HAHouseIntroduceViewController : UIViewController

@property(nonatomic,strong) HAHouse* house;

@property (nonatomic,weak) id<HADataExchangeDelegate> delegate;

@end
