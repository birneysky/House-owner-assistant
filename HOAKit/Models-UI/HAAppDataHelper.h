//
//  HAAppDataHelper.h
//  HOAKit
//
//  Created by zhangguang on 16/8/15.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAPosition.h"


@interface HAAppDataHelper : NSObject

+ (NSString*)rentTypeName:(NSInteger)type;

+ (NSString*)houseTypeName:(NSInteger)type;

+ (NSString*)TextFromCheckStatus:(NSInteger)status operationStatus:(NSInteger)operStatus;

+ (NSString*)bedName:(NSInteger)type;

+ (NSInteger)typeForBedName:(NSString*)name;

+ (NSArray<HAPosition*>*) positionsFromProvince:(NSInteger)provinceId city:(NSInteger)cityId house:(NSInteger)houseId;

+ (NSString*) provincesAndCityAddress:(NSInteger)provinceId city:(NSInteger)cityId distict:(NSInteger)distictId;

@end
