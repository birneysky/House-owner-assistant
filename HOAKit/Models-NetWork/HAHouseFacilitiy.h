//
//  HAHouseFacilitiy.h
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAJSONModel.h"

@interface HAHouseFacilitiy : HAJSONModel

@property(nonatomic,assign) NSInteger facilitiyId;
@property(nonatomic,assign) NSInteger hotShower;
@property(nonatomic,assign) NSInteger sofa;
@property(nonatomic,assign) NSInteger showerGel;
@property(nonatomic,assign) NSInteger tv;
@property(nonatomic,assign) NSInteger microwaveOven;
@property(nonatomic,assign) NSInteger computer;
@property(nonatomic,assign) NSInteger airCondition;
@property(nonatomic,assign) NSInteger drinkingFountain;
@property(nonatomic,assign) NSInteger refrigerator;
@property(nonatomic,assign) NSInteger washer;
@property(nonatomic,assign) NSInteger wifi;
@property(nonatomic,assign) NSInteger wiredNetwork;
@property(nonatomic,assign) NSInteger parkingSpace;
@property(nonatomic,assign) NSInteger smokingAllowed;
@property(nonatomic,assign) NSInteger cookAllowed;
@property(nonatomic,assign) NSInteger petsAllowed;
@property(nonatomic,assign) NSInteger partyAllowed;

@end
