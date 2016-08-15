//
//  HARESTfulEngine.h
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "HAJSONModel.h"
#import "HAHouseFullInfo.h"


/*单例类*/

typedef void (^VoidBlock)(void);
typedef void (^ModelBlock)(HAJSONModel* object);
typedef void (^ArrayBlock)(NSArray<HAJSONModel*>* objects);
typedef void (^HAHouseFullInfoBlock)(HAHouseFullInfo* info);
typedef void (^ObjectBlock)(NSObject* object);
typedef void (^ErrorBlock)(NSError* engineError);


@interface HARESTfulEngine : MKNetworkEngine

+ (HARESTfulEngine*) defaultEngine;

//获取房源列表
- (void) fetchHouseItemsWithHouseOwnerID:(NSInteger) hoid
                             onSucceeded:(ArrayBlock) succeededBlock
                                 onError:(ErrorBlock) errorBlock;
//获取房源信息
- (void) fetchHouseInfoWithHouseID:(NSInteger) houseId
                      onSucceeded:(HAHouseFullInfoBlock) succeededBlock
                          onError:(ErrorBlock) errorBlock;

//创建新房源
- (void) createNewHouseWithModel:(HAJSONModel*) model
                           onSucceeded:(ModelBlock)sBlock
                               onError:(ErrorBlock)errBlock;


//修改房源设施
- (void) modifyHouseFacilitiesWithHouseID:(NSInteger)houseId
                                   params:(HAJSONModel*)param
                              onSucceeded:(ModelBlock)sBlock
                                  onError:(ErrorBlock)errBlock;


@end
