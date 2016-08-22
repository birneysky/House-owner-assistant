//
//  HAHouseFullInfo.h
//  HOAKit
//
//  Created by zhangguang on 16/8/15.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAHouseBed.h"
#import "HAHouseComment.h"
#import "HAHouseFacility.h"
#import "HAHouse.h"
#import "HAHousePosition.h"
#import "HAHouseImage.h"

@interface HAHouseFullInfo : NSObject

@property (nonatomic,copy) NSArray<HAHouseBed*>* beds;

@property (nonatomic,copy) NSArray<HAHouseComment*>* comments;

@property (nonatomic,strong) HAHouseFacility* facility;

@property (nonatomic,assign) NSInteger hasConllection;

@property (nonatomic,strong) HAHouse* house;

@property (nonatomic,copy) NSArray<HAHouseImage*>* images;

@property (nonatomic,copy) NSArray<HAHousePosition*>* positions;

@end
