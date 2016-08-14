//
//  HARESTfulEngine.h
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "HAJSONModel.h"


/*单例类*/

typedef void (^VoidBlock)(void);
typedef void (^ModelBlock)(HAJSONModel* aModelBaseObject);
typedef void (^ArrayBlock)(NSArray* listOfModelBaseObjects);
typedef void (^ErrorBlock)(NSError* engineError);


@interface HARESTfulEngine : MKNetworkEngine

+ (HARESTfulEngine*) defaultEngine;

- (void) fetchHouseItemsWithHouseOwnerID:(NSInteger) hoid
                             onSucceeded:(ArrayBlock) succeededBlock
                                 onError:(ErrorBlock) errorBlock;

- (void) fetchHouseInfoWithHouseID:(NSInteger) houseId
                      onSucceeded:(ModelBlock) succeededBlock
                          onError:(ErrorBlock) errorBlock;

- (void) createNewHouseWithHAJSONModel:(HAJSONModel*) model
                           onSucceeded:(ModelBlock)sBlock
                               onError:(ErrorBlock)errBlock;

@end
