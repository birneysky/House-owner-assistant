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

@interface HAHouseFullInfo : NSObject

@property (nonatomic,strong) NSArray<HAHouseBed*>* beds;

@property (nonatomic,strong) NSArray<HAHouseComment*>* comments;

@property (nonatomic,strong) HAHouseFacility* facility;

@property (nonatomic,assign) NSInteger hasConllection;

@property (nonatomic,strong) HAHouse* house;

@property (nonatomic,strong) NSArray<NSString*>* images;

@property (nonatomic,strong) NSArray<HAHousePosition*>* positions;

@end
