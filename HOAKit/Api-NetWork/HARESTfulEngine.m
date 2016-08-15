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
#import "HAHouseBed.h"
#import "HAHouseComment.h"
#import "HAHousePosition.h"
#import "HAHouseFacility.h"

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


- (void)fetchRequestWithPath:(NSString*)path
                 onSucceeded:(ObjectBlock)objectBlock
                 onError:(ErrorBlock) errorBlock
{
    HARESTfulOperation* op = (HARESTfulOperation*) [self operationWithPath:path];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSMutableDictionary* responseDictionary = [completedOperation responseJSON];
        NSObject* houseItemsJson = [responseDictionary objectForKey:@"data"];
        objectBlock(houseItemsJson);
        
    }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}

- (void)httpRequestWithPath:(NSString*)path
                     params:(NSDictionary*)dic
                  httpMethod:(NSString*)method
                 onSucceeded:(ObjectBlock)objectBlock
                     onError:(ErrorBlock) errorBlock
{
    HARESTfulOperation* op = (HARESTfulOperation*) [self operationWithPath:path params:dic httpMethod:method];
    //
    if ([method isEqualToString:@"PUT"]) {
        [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSMutableDictionary* responseDictionary = [completedOperation responseJSON];
        NSDictionary* houseJson = [responseDictionary objectForKey:@"data"];

        objectBlock(houseJson);
        
    }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}

#pragma mark - *** Api-Net ***
- (void) fetchHouseItemsWithHouseOwnerID:(NSInteger) hoid
                             onSucceeded:(ArrayBlock) succeededBlock
                                 onError:(ErrorBlock) errorBlock
{
    NSString* path = [NSString stringWithFormat:@"api/houses?landlordId=%d",hoid];
    [self fetchRequestWithPath:path onSucceeded:^(NSObject *object) {
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray* houseItemsJson = object;
            NSMutableArray* houseItems = [NSMutableArray array];
            [houseItemsJson enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [houseItems addObject:[[HAHouse alloc] initWithDictionary:obj]];
            }];
            succeededBlock([houseItems copy]);
        }
    } onError:^(NSError *engineError) {
        
    }];

}

- (void)fetchHouseInfoWithHouseID:(NSInteger) houseId
                      onSucceeded:(HAHouseFullInfoBlock) succeededBlock
                          onError:(ErrorBlock) errorBlock
{
    NSString* path = [NSString stringWithFormat:@"api/houses/%d",houseId];
    [self fetchRequestWithPath:path onSucceeded:^(NSObject *object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary* houseInfoFull = object;
            NSArray* houseBeds = [houseInfoFull objectForKey:@"beds"];
            NSArray* houseComments = [houseInfoFull objectForKey:@"comments"];
            NSDictionary* house = [houseInfoFull objectForKey:@"house"];
            NSArray* housePositions = [houseInfoFull objectForKey:@"positions"];
            NSArray* houseImages = [houseInfoFull objectForKey:@"images"];
            HAHouseFullInfo* fullInfo = [[HAHouseFullInfo alloc] init];
            HAHouse* houseObj = [[HAHouse alloc] initWithDictionary:house];
            fullInfo.house = houseObj;
            
            NSMutableArray* beds = [NSMutableArray array];
            [houseBeds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HAHouseBed* bed = [[HAHouseBed alloc] initWithDictionary:obj];
                [beds addObject:bed];
            }];
            fullInfo.beds = [beds copy];
            
            NSMutableArray* comments = [NSMutableArray array];
            [houseComments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HAHouseComment* commnet  = [[HAHouseComment alloc] initWithDictionary:obj];
                [comments addObject:commnet];
            }];
            fullInfo.comments = [comments copy];
            
            NSMutableArray* images = [NSMutableArray array];
            [houseImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //
                //[images addObject:];
            }];
            fullInfo.images = [images copy];
            
            NSMutableArray* positions = [NSMutableArray array];
            [housePositions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HAHousePosition* postion = [[HAHousePosition alloc] initWithDictionary:obj];
                [positions addObject:postion];
            }];
            fullInfo.positions = [positions copy];
            
            
            succeededBlock(fullInfo);
        }
    } onError:^(NSError *engineError) {
        
    }];
}


- (void) createNewHouseWithModel:(HAJSONModel*) model
                           onSucceeded:(ModelBlock)sBlock
                               onError:(ErrorBlock)errBlock
{
    NSLog(@" model %@",[model toJsonString]);
    [self httpRequestWithPath:@"api/houses" params:[model toDictionary] httpMethod:@"POST" onSucceeded:^(NSObject *info) {
        if ([info isKindOfClass:[NSDictionary class]]) {
            NSDictionary* houseJson = info;
            HAHouse* houseObj = [[HAHouse alloc] initWithDictionary:houseJson];
            sBlock(houseObj);
        }
    } onError:^(NSError *engineError) {
        
    }];
}

- (void) modifyHouseFacilitiesWithHouseID:(NSInteger)houseId
                                   params:(HAJSONModel*)param
                              onSucceeded:(ModelBlock)sBlock
                                  onError:(ErrorBlock)errBlock
{
     NSLog(@" model %@",[param toFullJsonString]);
     NSString* path = [NSString stringWithFormat:@"/api/house_facilities/%d",houseId];
     [self httpRequestWithPath:path params:[param toFullDictionary] httpMethod:@"PUT" onSucceeded:^(NSObject *object) {
         HAHouseFacility* facitility = [[HAHouseFacility alloc] initWithDictionary:object];
         sBlock(facitility);
     } onError:^(NSError *engineError) {
         
     }];
}

@end
