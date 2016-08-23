//
//  HAAddHousePhotoViewController.h
//  House-owner-assistant
//
//  Created by birneysky on 16/7/30.
//  Copyright © 2016年 HA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAHouse.h"
#import "HAHouseImage.h"
#import "HADataExchangeDelegate.h"

@interface HAAddHousePhotoViewController : UIViewController

@property(nonatomic,strong) HAHouse* house;

@property(nonatomic,copy) NSArray<HAHouseImage*>* photoes;

@property (nonatomic,weak) id<HADataExchangeDelegate> delegate;

@end
