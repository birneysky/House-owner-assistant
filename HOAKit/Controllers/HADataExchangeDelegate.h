//
//  HADataExchangeDelegate.h
//  HOAKit
//
//  Created by zhangguang on 16/8/23.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HAHouse;
@class HAHouseBed;
@class HAHousePosition;
@class HAHouseFacility;
@class HAHouseImage;

@protocol HADataExchangeDelegate <NSObject>

@optional
- (void) houseDidChangned:(HAHouse*) house;

- (void) bedsOfHouseDidChange:(NSArray<HAHouseBed*>*) beds;

- (void) positionsOfHouseDidChange:(NSArray<HAHousePosition*>*) positions;

- (void) facilityOfHouseDidChange:(HAHouseFacility*) facility;

- (void) imagesOfHouseDidChange:(NSArray<HAHouseImage*>*) images;
                               
@end
