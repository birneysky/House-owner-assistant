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
#import "HAError.h"
#import "HOAKit.h"

NSString* const kBaseURL = @"120.76.28.47:8080/yisu";

static HARESTfulEngine* defaultEngine;

@implementation HARESTfulEngine

+ (HARESTfulEngine*)defaultEngine
{
    if (!defaultEngine) {
        defaultEngine = [[HARESTfulEngine alloc] initWithHostName:kBaseURL customHeaderFields:@{@"token":[HOAKit defaultInstance].token}];
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
                  completion:(ObjectBlock)objectBlock
                     onError:(ErrorBlock) errorBlock
{
    HARESTfulOperation* op = (HARESTfulOperation*) [self operationWithPath:path];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSMutableDictionary* responseDictionary = [completedOperation responseJSON];
        NSInteger code = [[responseDictionary objectForKey:@"code"] integerValue];
        if (code == 0) {
            NSObject* houseItemsJson = [responseDictionary objectForKey:@"data"];
            objectBlock(houseItemsJson);
        }
        else{
            NSString* text = [responseDictionary objectForKey:@"msg"];
            HAError* error = [[HAError alloc] initWithCode:code reason:text];
            errorBlock(error);
        }
        
    }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}

- (void)httpRequestWithPath:(NSString*)path
              generalParams:(NSObject*)object
                 httpMethod:(NSString*)method
                 completion:(void (^)(NSDictionary* object))objectBlock
                    onError:(ErrorBlock) errorBlock
{
    HARESTfulOperation* op = nil;
//    NSString* realMethod;
//    if ([method isEqualToString:@"POSTS"]) {
//        realMethod = @"POST";
//    }
//    else{
//        realMethod = method;
//    }
    op = (HARESTfulOperation*) [self operationWithPath:path params:(NSDictionary*)object httpMethod:method];
    if ([object isKindOfClass:[NSArray class]]) {
         op = (HARESTfulOperation*) [self operationWithPath:path paramsArray:(NSArray*)object httpMethod:method];
    }

    if ([method isEqualToString:@"PUT"]) {
        [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSMutableDictionary* responseDictionary = [completedOperation responseJSON];
        //NSDictionary* houseJson = [responseDictionary objectForKey:@"data"];
        NSInteger code = [[responseDictionary objectForKey:@"code"] integerValue];
        if (code == 0) {
            objectBlock(responseDictionary);
        }
        else{
            NSString* text = [responseDictionary objectForKey:@"msg"];
            HAError* error = [[HAError alloc] initWithCode:code reason:text];
            errorBlock(error);
        }
    }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}

#pragma mark - *** Api-Net ***
- (void) fetchHouseItemsWithHouseOwnerID:(NSInteger) hoid
                              completion:(void (^)(NSArray<HAHouse*>* objects)) completion
                                 onError:(ErrorBlock) errorBlock
{
    NSString* path = [NSString stringWithFormat:@"api/houses?landlordId=%ld",(long)hoid];
    [self fetchRequestWithPath:path completion:^(NSObject *object) {
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray* houseItemsJson = (NSArray*)object;
            NSMutableArray* houseItems = [NSMutableArray array];
            [houseItemsJson enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [houseItems addObject:[[HAHouse alloc] initWithDictionary:obj]];
            }];
            completion([houseItems copy]);
        }
    } onError:^(NSError *engineError) {
        errorBlock(engineError);
    }];

}

- (void)fetchHouseInfoWithHouseID:(NSInteger) houseId
                       completion:(void(^)(HAHouseFullInfo* info)) completion
                          onError:(ErrorBlock) errorBlock
{
    NSString* path = [NSString stringWithFormat:@"api/houses/%ld",(long)houseId];
    [self fetchRequestWithPath:path completion:^(NSObject *object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary* houseInfoFull = (NSDictionary*)object;
            NSArray* houseBeds = [houseInfoFull objectForKey:@"beds"];
            NSArray* houseComments = [houseInfoFull objectForKey:@"comments"];
            NSDictionary* house = [houseInfoFull objectForKey:@"house"];
            NSArray* housePositions = [houseInfoFull objectForKey:@"positions"];
            NSArray* houseImages = [houseInfoFull objectForKey:@"images"];
            NSDictionary* houseFacility = [houseInfoFull objectForKey:@"facility"];
            HAHouseFullInfo* fullInfo = [[HAHouseFullInfo alloc] init];
            HAHouse* houseObj = [[HAHouse alloc] initWithDictionary:house];
            fullInfo.house = houseObj;
            
            NSMutableArray* beds = [NSMutableArray array];
            if([houseBeds isKindOfClass:[NSArray class]])
            [houseBeds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HAHouseBed* bed = [[HAHouseBed alloc] initWithDictionary:obj];
                [beds addObject:bed];
            }];
            fullInfo.beds = [beds copy];
            
            NSMutableArray* comments = [NSMutableArray array];
             if([houseComments isKindOfClass:[NSArray class]])
            [houseComments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HAHouseComment* commnet  = [[HAHouseComment alloc] initWithDictionary:obj];
                [comments addObject:commnet];
            }];
            fullInfo.comments = [comments copy];
            
            NSMutableArray* images = [NSMutableArray array];
             if([houseImages isKindOfClass:[NSArray class]])
            [houseImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HAHouseImage* image = [[HAHouseImage alloc] initWithDictionary:obj];
                image.houseId = houseObj.houseId;
                if ([image.imagePath isEqualToString:houseObj.firstImage]) {
                    image.isFirstImage = YES;
                }
                [images addObject: image];
            }];
            fullInfo.images = [images copy];
            
            NSMutableArray* positions = [NSMutableArray array];
            if([housePositions isKindOfClass:[NSArray class]])
            [housePositions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HAHousePosition* postion = [[HAHousePosition alloc] initWithDictionary:obj];
                [positions addObject:postion];
            }];
            fullInfo.positions = [positions copy];
            
            if([houseFacility isKindOfClass:[NSDictionary class]])
            fullInfo.facility = [[HAHouseFacility alloc] initWithDictionary:houseFacility];
            
            
            completion(fullInfo);
        }
    } onError:^(NSError *engineError) {
        errorBlock(engineError);
    }];
}


- (void) createNewHouseWithModel:(HAJSONModel*) model
                      completion:(void (^)(HAHouse* house))completion
                         onError:(ErrorBlock)errorBlcok
{
    [self httpRequestWithPath:@"api/houses" generalParams:[model toDictionary] httpMethod:@"POST" completion:^(NSDictionary *info) {
            NSDictionary* houseJson = [info objectForKey:@"data"];
            HAHouse* houseObj = [[HAHouse alloc] initWithDictionary:houseJson];
            completion(houseObj);
    } onError:^(NSError *engineError) {
        errorBlcok(engineError);
    }];
}

- (void) modifyHouseFacilitiesWithHouseID:(NSInteger)houseId
                                   params:(HAHouseFacility*)param
                               completion:(void (^)(HAHouseFacility* facility))completion
                                  onError:(ErrorBlock)errorBlcok
{
     NSString* path = [NSString stringWithFormat:@"api/house_facilities/%ld",(long)houseId];
     [self httpRequestWithPath:path generalParams:[param toFullDictionary] httpMethod:@"PUT" completion:^(NSDictionary *object) {
         NSDictionary* dic = [(NSDictionary*)object objectForKey:@"data"];
         HAHouseFacility* facitility = [[HAHouseFacility alloc] initWithDictionary:dic];
         completion(facitility);
     } onError:^(NSError *engineError) {
         errorBlcok(engineError);
     }];
}

- (void) fetchPositionInfoWithCityID:(NSInteger)cityId
                          completion:(void (^)(NSArray<HAPosition*>* postions,NSArray<HASubWay*>* subways))completion
                             onError:(ErrorBlock)errorBlock;
{
    NSString* path = [NSString stringWithFormat:@"api/public/positions?cityId=%ld",(long)cityId];
    [self fetchRequestWithPath:path completion:^(NSObject *object) {
        NSDictionary* responseDic = [[NSDictionary alloc] initWithDictionary:(NSDictionary*)object];
        NSArray* positions = [responseDic objectForKey:@"positions"];
        NSArray* subways = [responseDic objectForKey:@"subways"];
        
        NSMutableArray* mutablePostions = [[NSMutableArray alloc] initWithCapacity:1000];
        [positions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HAPosition* postion = [[HAPosition alloc] initWithDictionary:obj];
            [mutablePostions addObject:postion];
        }];
        
        NSMutableArray* mutableSubways = [[NSMutableArray alloc] initWithCapacity:100];
        [subways enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HASubWay* subway = [[HASubWay alloc] initWithDictionary:obj];
            [mutableSubways addObject:subway];
        }];
        
        completion([mutablePostions copy],[mutableSubways copy]);
        
    } onError:^(NSError *engineError) {
        errorBlock(engineError);
    }];
}

- (void) addHouseBed:(HAHouseBed*)bed
          completion:(void(^)(HAHouseBed* bed))completion
             onError:(ErrorBlock)errBlock
{
    [self httpRequestWithPath:@"api/house_beds" generalParams:[bed toFullDictionary] httpMethod:@"POST" completion:^(NSDictionary *object) {
        NSDictionary* dic = [(NSDictionary*)object objectForKey:@"data"];
        HAHouseBed* bedresult = [[HAHouseBed alloc] initWithDictionary:dic];
        completion(bedresult);
        
    } onError:^(NSError *engineError) {
        errBlock(engineError);
    }];
}

- (void) modifyHouseBed:(HAHouseBed*)bed
             completion:(void(^)(HAHouseBed* bed))completion
                onError:(ErrorBlock)errBlock
{
    NSString* path = [NSString stringWithFormat:@"api/house_beds/%ld",(long)bed.houseId];
    [self httpRequestWithPath:path generalParams:[bed toFullDictionary] httpMethod:@"PUT" completion:^(NSDictionary *object) {
        NSDictionary* dic = [(NSDictionary*)object objectForKey:@"data"];
        HAHouseBed* bedresult = [[HAHouseBed alloc] initWithDictionary:dic];
        completion(bedresult);
    } onError:^(NSError *engineError) {
        errBlock(engineError);
    }];
}


- (void) removeHouseBedWithID:(NSInteger)bedId
                   completion:(void(^)(void))completion
                      onError:(ErrorBlock)errBlock
{
    NSString* path = [NSString stringWithFormat:@"api/house_beds/%ld",(long)(long)bedId];
    [self httpRequestWithPath:path generalParams:nil httpMethod:@"DELETE" completion:^(NSDictionary *object) {
        completion();
    } onError:^(NSError *engineError) {
        errBlock(engineError);
    }];
}


- (void) modifyHouseGeneralInfoWithID:(NSInteger)houseId
                               params:(HAHouse*)param
                           completion:(void(^)(HAHouse* house))completion
                              onError:(ErrorBlock)errorBlcok
{
    NSString* path = [NSString stringWithFormat:@"api/houses/%ld",(long)houseId];
    [self httpRequestWithPath:path generalParams:[param toFullDictionary] httpMethod:@"PUT" completion:^(NSDictionary *object) {
        NSDictionary* houseDic = [object objectForKey:@"data"];
        HAHouse* house = [[HAHouse alloc] initWithDictionary:houseDic];
        completion(house);
    } onError:^(NSError *engineError) {
        errorBlcok(engineError);
    }];
}

- (void) modifyHousePositionWithArray:(NSArray<HAHousePosition*>*)array
                           completion:(void (^)(NSArray<HAHousePosition*>* positions))completion
                              onError:(ErrorBlock)errorBlcok
{
    NSMutableArray* mutableArray = [[NSMutableArray alloc] initWithCapacity:50];
    [array enumerateObjectsUsingBlock:^(HAHousePosition * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mutableArray addObject:[obj toFullDictionary]];
    }];
    [self httpRequestWithPath:@"api/houses_positions" generalParams:[mutableArray copy] httpMethod:@"PUT" completion:^(NSDictionary *object) {
        NSArray* positions = [object objectForKey:@"data"];
        NSMutableArray<HAHousePosition*>* mutablArray = [[NSMutableArray alloc] initWithCapacity:30];
        [positions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HAHousePosition* position = [[HAHousePosition alloc] initWithDictionary:obj];
            [mutablArray addObject:position];
        }];
        completion([mutablArray copy]);
    } onError:^(NSError *engineError) {
        errorBlcok(engineError);
    }];
}


- (MKNetworkOperation*) uploadHouseImageWithPath:(NSString*)path
                                         houseId:(NSInteger)houseId
                                      completion:(void (^)(NSString* certificate,HAHouseImage* obj))completion
                                        progress:(void (^)(NSString* certificate, float progress))progressBlock
                                         onError:(void (^)(NSString* certificate, NSError* err))errorBlcok
{
    NSString* url = [NSString stringWithFormat:@"api/houses/%ld/images",(long)houseId];
    HARESTfulOperation* op = (HARESTfulOperation*) [self operationWithPath:url  params:nil httpMethod:@"POST"];

    op.clientCertificate = [NSString stringWithFormat:@"%p",op];
    [op addFile:path forKey:@"file" mimeType:@"image/jpg"];
    
    [op setFreezable:YES];
    __weak HARESTfulOperation* weakOp = op;
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
        
        NSMutableDictionary* responseDictionary = [completedOperation responseJSON];

        NSInteger code = [[responseDictionary objectForKey:@"code"] integerValue];
        if (code != 0){
            NSString* text = [responseDictionary objectForKey:@"msg"];
            HAError* error = [[HAError alloc] initWithCode:code reason:text];
            errorBlcok(weakOp.clientCertificate,error);
        }
        NSDictionary* data = [responseDictionary objectForKey:@"data"];
        HAHouseImage* houseImage = [[HAHouseImage alloc] initWithDictionary:data];
        
        completion(weakOp.clientCertificate,houseImage);
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err){
        errorBlcok(errorOp.clientCertificate,err);
        
    }];
    
    [self enqueueOperation:op];
    
    [op onUploadProgressChanged:^(double progress) {
        progressBlock(weakOp.clientCertificate,progress);
    }];
    return op;
}


- (void) relationshipBetweenHousesAndPictures:(NSArray<HAHouseImage*>*)imageArray
                                   completion:(VoidBlock)completion
                                      onError:(ErrorBlock)errorBlcok
{

    NSMutableArray* mutableArray = [[NSMutableArray alloc] init];
    [imageArray enumerateObjectsUsingBlock:^(HAHouseImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (idx >0)
//            houseImage.imagePath = [houseImage.imagePath stringByAppendingFormat:@";%@",obj.imagePath];
        [mutableArray addObject:[obj toFullDictionary]];
    }];

    
    [self httpRequestWithPath:@"api/house_images/relation" generalParams:[mutableArray copy] httpMethod:@"PUT" completion:^(NSDictionary *object) {
        completion();
    } onError:^(NSError *engineError) {
        errorBlcok(engineError);
    }];
}



- (MKNetworkOperation*) downloadHouseImageWithURL:(NSString*)url
                                       storagePath:(NSString*)path
                                        completion:(void (^)(NSString* certificate, NSString* fileName))completion
                                          progress:(void (^)(NSString* certificate, float progress))progressBlock
                                           onError:(void (^)(NSString* certificate,NSError* error))errorBlcok
{
    HARESTfulOperation* op = (HARESTfulOperation*) [self operationWithPath:url];
    
    op.clientCertificate = [NSString stringWithFormat:@"%p",op];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager]  createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* targetFilePath = [path stringByAppendingPathComponent:[url lastPathComponent]];
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:targetFilePath append:YES]];
    __weak HARESTfulOperation* weakOp = op;
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
        
        //NSMutableDictionary* responseDictionary = [completedOperation responseJSON];
        completion(weakOp.clientCertificate,[targetFilePath lastPathComponent]);
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err){
        errorBlcok(weakOp.clientCertificate,err);
    }];
    
    [self enqueueOperation:op];
    [op freezable];
    [op onDownloadProgressChanged:^(double progress) {
        progressBlock(weakOp.clientCertificate,progress);
        // DLog(@"Upload file progress: %.2f", progress*100.0);
    }];

    return op;
}


- (void) delteHouseImageWithImageId:(NSInteger)imgId
                         completion:(VoidBlock)completion
                            onError:(ErrorBlock)errorBlcok
{
    NSString* path = [NSString stringWithFormat:@"api/house_images/%ld",(long)imgId];
     //HARESTfulOperation* op = (HARESTfulOperation*) [self operationWithPath:path params:nil httpMethod:@"DELETE"];
    [self httpRequestWithPath:path generalParams:@{@"id":@(imgId)} httpMethod:@"DELETE" completion:^(NSDictionary *object) {
        completion();
    } onError:^(NSError *engineError) {
        errorBlcok(engineError);
    }];
}


- (void) submitHouseInfoForCheckOfHouseId:(NSInteger)houseId
                                   params:(HAHouse*)house
                               completion:(void (^) (HAHouse* house))completion
                                  onError:(ErrorBlock)errorBlcok;
{
    NSString* path = [NSString stringWithFormat:@"api/houses/%ld",(long)houseId];
    [self httpRequestWithPath:path
                generalParams:[house toFullDictionary]
                   httpMethod:@"PUT"
                   completion:^(NSDictionary *object) {
                       NSDictionary* houseDic = [object objectForKey:@"data"];
                       HAHouse* house = [[HAHouse alloc] initWithDictionary:houseDic];
                       completion(house);
                   } onError:^(NSError *engineError) {
                       errorBlcok(engineError);
    }];
}

@end


