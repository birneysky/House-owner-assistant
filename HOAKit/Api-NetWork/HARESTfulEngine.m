//
//  HARESTfulEngine.m
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HARESTfulEngine.h"
#import "HARESTfulOperation.h"
#import "HAHouse.h"
#import "HAHouseItem.h"

NSString* const kBaseURL = @"120.76.28.47:8080/yisu";

static HARESTfulEngine* defaultEngine;

@implementation HARESTfulEngine

+ (HARESTfulEngine*)defaultEngine
{
    if (!defaultEngine) {
        defaultEngine = [[HARESTfulEngine alloc] initWithHostName:kBaseURL];
    }
    return defaultEngine;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (!defaultEngine) {
        defaultEngine = [super allocWithZone:zone];
    }
    return defaultEngine;
}

+ (instancetype) copy{
    return defaultEngine;
}


- (void) fetchHouseItemsWithHouseOwnerID:(NSInteger) hoid
                             onSucceeded:(ArrayBlock) succeededBlock
                                 onError:(ErrorBlock) errorBlock
{
    NSString* path = [NSString stringWithFormat:@"api/houses?landlordId=%d",hoid];
    HARESTfulOperation* op = (HARESTfulOperation*) [self operationWithPath:path];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSMutableDictionary* responseDictionary = [completedOperation responseJSON];
        NSMutableArray* houseItemsJson = [responseDictionary objectForKey:@"data"];
        
        NSMutableArray* houseItems = [NSMutableArray array];
        
        [houseItemsJson enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [houseItems addObject:[[HAHouseItem alloc] initWithDictionary:obj]];
        }];
        
        succeededBlock([houseItems copy]);
        
    }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];


}

- (void)fetchHouseInfoWithHouseID:(NSInteger) houseId
                      onSucceeded:(ModelBlock) succeededBlock
                          onError:(ErrorBlock) errorBlock
{
    NSString* path = [NSString stringWithFormat:@"api/houses/%d",houseId];
    HARESTfulOperation* op = (HARESTfulOperation*) [self operationWithPath:path];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSMutableDictionary* responseDictionary = [completedOperation responseJSON];
        NSDictionary* houseJson = [[responseDictionary objectForKey:@"data"] objectForKey:@"house"];

        HAHouse* houseObj = [[HAHouse alloc] initWithDictionary:houseJson];
        
        succeededBlock(houseObj);
        
    }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}


- (void) createNewHouseWithHAJSONModel:(HAJSONModel*) model
                           onSucceeded:(ModelBlock)sBlock
                               onError:(ErrorBlock)errBlock
{
    HARESTfulOperation* op = (HARESTfulOperation*) [self operationWithPath:@"api/houses" params:[model toDictionary] httpMethod:@"POST"];
    //[op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    NSLog(@" model %@",[model toJsonString]);
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSMutableDictionary* responseDictionary = [completedOperation responseJSON];
        NSDictionary* houseJson = [responseDictionary objectForKey:@"data"];
//        
        HAHouse* houseObj = [[HAHouse alloc] initWithDictionary:houseJson];
        sBlock(houseObj);
        
    }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errBlock(error);
    }];
    
    [self enqueueOperation:op];
}

@end
