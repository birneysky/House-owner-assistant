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
                 completion:(ObjectBlock)objectBlock
                     onError:(ErrorBlock) errorBlock
{
    HARESTfulOperation* op = nil;
    op = (HARESTfulOperation*) [self operationWithPath:path params:object httpMethod:method];
    if ([object isKindOfClass:[NSArray class]]) {
         op = (HARESTfulOperation*) [self operationWithPath:path paramsArray:object httpMethod:method];
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
                             completion:(ArrayBlock) completion
                                 onError:(ErrorBlock) errorBlock
{
    NSString* path = [NSString stringWithFormat:@"api/houses?landlordId=%d",hoid];
    [self fetchRequestWithPath:path completion:^(NSObject *object) {
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray* houseItemsJson = object;
            NSMutableArray* houseItems = [NSMutableArray array];
            [houseItemsJson enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [houseItems addObject:[[HAHouse alloc] initWithDictionary:obj]];
            }];
            completion([houseItems copy]);
        }
    } onError:^(NSError *engineError) {
        
    }];

}

- (void)fetchHouseInfoWithHouseID:(NSInteger) houseId
                      completion:(HAHouseFullInfoBlock) completion
                          onError:(ErrorBlock) errorBlock
{
    NSString* path = [NSString stringWithFormat:@"api/houses/%d",houseId];
    [self fetchRequestWithPath:path completion:^(NSObject *object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary* houseInfoFull = object;
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
        
    }];
}


- (void) createNewHouseWithModel:(HAJSONModel*) model
                           completion:(ModelBlock)completion
                               onError:(ErrorBlock)errorBlcok
{
    NSLog(@" model %@",[model toJsonString]);
    [self httpRequestWithPath:@"api/houses" generalParams:[model toDictionary] httpMethod:@"POST" completion:^(NSObject *info) {
        if ([info isKindOfClass:[NSDictionary class]]) {
            NSDictionary* houseJson = [(NSDictionary*)info objectForKey:@"data"];
            HAHouse* houseObj = [[HAHouse alloc] initWithDictionary:houseJson];
            completion(houseObj);
        }
    } onError:^(NSError *engineError) {
        
    }];
}

- (void) modifyHouseFacilitiesWithHouseID:(NSInteger)houseId
                                   params:(HAJSONModel*)param
                               completion:(ModelBlock)completion
                                  onError:(ErrorBlock)errorBlcok
{
     NSLog(@" model %@",[param toFullJsonString]);
     NSString* path = [NSString stringWithFormat:@"api/house_facilities/%d",houseId];
     [self httpRequestWithPath:path generalParams:[param toFullDictionary] httpMethod:@"PUT" completion:^(NSObject *object) {
         NSDictionary* dic = [(NSDictionary*)object objectForKey:@"data"];
         HAHouseFacility* facitility = [[HAHouseFacility alloc] initWithDictionary:dic];
         completion(facitility);
     } onError:^(NSError *engineError) {
         
     }];
}

- (void) fetchPositionInfoWithCityID:(NSInteger)cityId
                          completion:(void (^)(NSArray<HAPosition*>* postions,NSArray<HASubWay*>* subways))completion
                             onError:(ErrorBlock)errorBlock;
{
    NSString* path = [NSString stringWithFormat:@"api/public/positions?cityId=%d",cityId];
    [self fetchRequestWithPath:path completion:^(NSObject *object) {
        NSDictionary* responseDic = [[NSDictionary alloc] initWithDictionary:object];
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
        
    }];
}

- (void) addHouseBed:(HAJSONModel*)bed
          completion:(ModelBlock)completion
             onError:(ErrorBlock)errBlock
{
    NSLog(@" model %@",[bed toFullJsonString]);
    [self httpRequestWithPath:@"api/house_beds" generalParams:[bed toFullDictionary] httpMethod:@"POST" completion:^(NSObject *object) {
        NSDictionary* dic = [(NSDictionary*)object objectForKey:@"data"];
        HAHouseBed* bedresult = [[HAHouseBed alloc] initWithDictionary:dic];
        completion(bedresult);
        
    } onError:^(NSError *engineError) {
        
    }];
}

- (void) removeHouseBedWithID:(NSInteger)bedId
                   completion:(ModelBlock)completion
                      onError:(ErrorBlock)errBlock
{
    NSString* path = [NSString stringWithFormat:@"api/house_beds/%d",bedId];
    [self httpRequestWithPath:path generalParams:nil httpMethod:@"DELETE" completion:^(NSObject *object) {
        completion(nil);
    } onError:^(NSError *engineError) {
        
    }];
}


- (void) modifyHouseGeneralInfoWithID:(NSInteger)houseId
                               params:(HAJSONModel*)param
                           completion:(VoidBlock)completion
                              onError:(ErrorBlock)errorBlcok
{
     NSString* path = [NSString stringWithFormat:@"api/houses/%d",houseId];
     NSLog(@" model %@",[param toFullJsonString]);
    [self httpRequestWithPath:path generalParams:[param toFullDictionary] httpMethod:@"PUT" completion:^(NSObject *object) {
        completion();
    } onError:^(NSError *engineError) {
        
    }];
}

- (void) modifyHousePositionWithArray:(NSArray<HAHousePosition*>*)array
                           completion:(VoidBlock)completion
                              onError:(ErrorBlock)errorBlcok
{
    NSMutableArray* mutableArray = [[NSMutableArray alloc] initWithCapacity:50];
    [array enumerateObjectsUsingBlock:^(HAHousePosition * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mutableArray addObject:[obj toFullDictionary]];
    }];
    [self httpRequestWithPath:@"api/houses_positions" generalParams:[mutableArray copy] httpMethod:@"PUT" completion:^(NSObject *object) {
        completion();
    } onError:^(NSError *engineError) {
        
    }];
}


- (MKNetworkOperation*) uploadHouseImageWithPath:(NSString*)path
                       completion:(void (^)(HAHouseImage* obj))completion
                         progress:(void (^)(NSString* certificate, float progress))progressBlock
                          onError:(ErrorBlock)errorBlcok
{
    HARESTfulOperation* op = (HARESTfulOperation*) [self operationWithPath:@"api/houses/images/"  params:nil httpMethod:@"POST"];

    op.clientCertificate = [NSString stringWithFormat:@"%p",op];
    [op addFile:path forKey:@"file" mimeType:@"image/jpg"];
    
    [op setFreezable:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
        
        NSMutableDictionary* responseDictionary = [completedOperation responseJSON];

        NSInteger code = [[responseDictionary objectForKey:@"code"] integerValue];
        if (code != 0){
            NSString* text = [responseDictionary objectForKey:@"msg"];
            HAError* error = [[HAError alloc] initWithCode:code reason:text];
            errorBlcok(error);
        }
        NSDictionary* data = [responseDictionary objectForKey:@"data"];
        HAHouseImage* houseImage = [[HAHouseImage alloc] initWithDictionary:data];
        
        completion(houseImage);
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err){
        
        NSLog(@"Upload file error: %@", err);
        
    }];
    
    [self enqueueOperation:op];
    
    [op onUploadProgressChanged:^(double progress) {
        progressBlock(op.clientCertificate,progress);
       // DLog(@"Upload file progress: %.2f", progress*100.0);
    }];
    return op;
}


- (void) relationshipBetweenHousesAndPictures:(NSArray<HAHouseImage*>*)imageArray
                                   completion:(VoidBlock)completion
                                      onError:(ErrorBlock)errorBlcok
{
    __block HAHouseImage* houseImage = imageArray.firstObject;
    NSMutableArray* mutableArray = [[NSMutableArray alloc] init];
    [imageArray enumerateObjectsUsingBlock:^(HAHouseImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (idx >0)
//            houseImage.imagePath = [houseImage.imagePath stringByAppendingFormat:@";%@",obj.imagePath];
        [mutableArray addObject:[obj toFullDictionary]];
    }];

    
    [self httpRequestWithPath:@"api/house_images/relation" generalParams:[mutableArray copy ] httpMethod:@"PUT" completion:^(NSObject *object) {
        completion();
    } onError:^(NSError *engineError) {
        errorBlcok(engineError);
    }];
}



- (MKNetworkOperation*) downloadHouseImageWithPath:(NSString*)path
                                        completion:(void (^)(NSString* certificate, NSString* fileName))completion
                                          progress:(void (^)(NSString* certificate, float progress))progressBlock
                                           onError:(ErrorBlock)errorBlcok
{
    HARESTfulOperation* op = (HARESTfulOperation*) [self operationWithPath:path];
    
    op.clientCertificate = [NSString stringWithFormat:@"%p",op];
    
    NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImagesNet"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager]  createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* targetFilePath = [filePath stringByAppendingPathComponent:[path lastPathComponent]];
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:targetFilePath append:YES]];
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
        
        NSMutableDictionary* responseDictionary = [completedOperation responseJSON];
        completion(op.clientCertificate,[path lastPathComponent]);
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err){
        (errorBlcok);
    }];
    
    [self enqueueOperation:op];
    
    [op onDownloadProgressChanged:^(double progress) {
        progressBlock(op.clientCertificate,progress);
        // DLog(@"Upload file progress: %.2f", progress*100.0);
    }];

    return op;
}


- (void) delteHouseImageWithImageId:(NSInteger)imgId
                                        completion:(VoidBlock)completion
                                           onError:(ErrorBlock)errorBlcok
{
    NSString* path = [NSString stringWithFormat:@"api/house_images/%d",imgId];
     //HARESTfulOperation* op = (HARESTfulOperation*) [self operationWithPath:path params:nil httpMethod:@"DELETE"];
    [self httpRequestWithPath:path generalParams:@{@"id":@(imgId)} httpMethod:@"DELETE" completion:^(NSObject *object) {
        completion();
    } onError:^(NSError *engineError) {
        errorBlcok(engineError);
    }];
}

@end


