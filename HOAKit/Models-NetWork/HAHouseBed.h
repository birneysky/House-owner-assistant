//
//  HAHouseBed.h
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAJSONModel.h"

@interface HAHouseBed : HAJSONModel

@property(nonatomic,assign) NSInteger bedId;
@property(nonatomic,assign) NSInteger bedTypeId;
@property (nonatomic,assign) NSInteger houseId;
@property (nonatomic,assign) float length;
@property (nonatomic,assign) float width;
@property (nonatomic,assign) NSInteger number;

@end


//@property(nonatomic,assign) NSInteger doubleBedBig;
//@property(nonatomic,assign) NSInteger doubleBedMedium;
//@property(nonatomic,assign) NSInteger doubleBedSmall;
//@property(nonatomic,assign) NSInteger singleBed;
//@property(nonatomic,assign) NSInteger doubleDecker;
//@property(nonatomic,assign) NSInteger armchair;
//@property(nonatomic,assign) NSInteger doubleSofa;
//@property(nonatomic,assign) NSInteger childrenBed;
//@property(nonatomic,assign) NSInteger infantBed;
//@property(nonatomic,assign) NSInteger tatami;
//@property(nonatomic,assign) NSInteger roundRed;
//@property(nonatomic,assign) NSInteger airBed;