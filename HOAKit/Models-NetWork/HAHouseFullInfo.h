//
//  HAHouseFullInfo.h
//  HOAKit
//
//  Created by zhangguang on 16/8/15.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HAHouseBed;
@class HAHouseComment;
@class HAHouseFacilitiy;
@class HAHouse;
@class HAHousePosition;

@interface HAHouseFullInfo : NSObject

@property (nonatomic,strong) NSArray<HAHouseBed*>* beds;

@property (nonatomic,strong) NSArray<HAHouseComment*>* comments;

@property (nonatomic,strong) HAHouseFacilitiy* facility;

@property (nonatomic,assign) NSInteger hasConllection;

@property (nonatomic,strong) HAHouse* house;

@property (nonatomic,strong) NSArray<NSString*>* images;

@property (nonatomic,strong) NSArray<HAHousePosition*>* positions;

@end
