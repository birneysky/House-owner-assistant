//
//  HAAddHousePictureViewController.h
//  HOAKit
//
//  Created by zhangguang on 16/9/20.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAHouse.h"
#import "HAHouseImage.h"
#import "HADataExchangeDelegate.h"

@interface HAAddHousePictureViewController : UIViewController

@property(nonatomic,strong) HAHouse* house;

@property(nonatomic,copy) NSArray<HAHouseImage*>* photoes;

@property (nonatomic,weak) id<HADataExchangeDelegate> delegate;

@end
