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
#import "HASubWay.h"
#import "HAPosition.h"
#import "HAHousePosition.h"
#import "HAHouseImage.h"

/*单例类*/

typedef void (^VoidBlock)(void);
typedef void (^ModelBlock)(HAJSONModel* object);
typedef void (^ArrayBlock)(NSArray<HAJSONModel*>* objects);
typedef void (^HAHouseFullInfoBlock)(HAHouseFullInfo* info);
typedef void (^ObjectBlock)(NSObject* object);
typedef void (^ErrorBlock)(NSError* engineError);


@interface HARESTfulEngine : MKNetworkEngine

+ (HARESTfulEngine*) defaultEngine;

/**
 *  获取房源列表
 *
 *  @param hoid           房主id
 *  @param completion     网络请求结束 block
 *  @param errorBlcok     调用出错 block
 *
 */

- (void) fetchHouseItemsWithHouseOwnerID:(NSInteger) hoid
                             completion:(ArrayBlock) completion
                                 onError:(ErrorBlock) errorBlock;


/**
 *  获取房源信息
 *
 *  @param houseId        房源id
 *  @param completion     网络请求结束 block
 *  @param errorBlcok     调用出错 block
 *
 */

- (void) fetchHouseInfoWithHouseID:(NSInteger) houseId
                      completion:(HAHouseFullInfoBlock) completion
                          onError:(ErrorBlock) errorBlock;

/**
 *  创建新房源
 *
 *  @param model          房源对象
 *  @param completion     网络请求结束 block
 *  @param errorBlcok     调用出错 block
 *
 */

- (void) createNewHouseWithModel:(HAJSONModel*) model
                           completion:(ModelBlock)completion
                               onError:(ErrorBlock)errorBlcok;


/**
 *  修改房源设施
 *
 *  @param houseId        房源id
 *  @param param          房源设施对象
 *  @param completion     网络请求结束 block
 *  @param errorBlcok     调用出错 block
 *
 */


- (void) modifyHouseFacilitiesWithHouseID:(NSInteger)houseId
                                   params:(HAJSONModel*)param
                              completion:(ModelBlock)completion
                                  onError:(ErrorBlock)errorBlcok;



/**
 *  获取城市位置区域信息
 *
 *  @param cityId         所在城市的id
 *  @param completion     网络请求结束 block  返回地铁信息，位置信息
 *  @param errorBlcok     调用出错 block
 *
 */

- (void) fetchPositionInfoWithCityID:(NSInteger)cityId
                          completion:(void (^)(NSArray<HAPosition*>* postions,NSArray<HASubWay*>* subways))completion
                             onError:(ErrorBlock)errorBlock;


/**
 *  添加床铺信息
 *
 *  @param bed            床铺对象
 *  @param completion     网络请求结束 block
 *  @param errorBlcok     调用出错 block
 *
 */

- (void) addHouseBed:(HAJSONModel*)bed
          completion:(ModelBlock)completion
             onError:(ErrorBlock)errBlock;


/**
 *  删除床铺信息
 *
 *  @param bedId          床铺id
 *  @param completion     网络请求结束 block
 *  @param errorBlcok     调用出错 block
 *
 */

- (void) removeHouseBedWithID:(NSInteger)bedId
                   completion:(ModelBlock)completion
                      onError:(ErrorBlock)errBlock;


/**
 *  修改房源基本信息
 *
 *  @param houseId        房源id
 *  @param param          房源对象
 *  @param completion     网络请求结束 block
 *  @param errorBlcok     调用出错 block
 *
 */

- (void) modifyHouseGeneralInfoWithID:(NSInteger)houseId
                               params:(HAJSONModel*)param
                           completion:(VoidBlock)completion
                              onError:(ErrorBlock)errorBlcok;


/**
 *  修改房源位置信息
 *
 *  @param array           位置对象数组 HAHousePosition
 *  @param completion      网络请求结束 block
 *  @param errorBlcok      调用出错 block
 *
 */

- (void) modifyHousePositionWithArray:(NSArray<HAHousePosition*>*)array
                           completion:(VoidBlock)completion
                              onError:(ErrorBlock)errorBlcok;


//http://120.76.28.47:8080/yisu/images/house/1471779370324.jpg

/**
 *  上传房源图片
 *
 *  @param array           位置对象数组 HAHousePosition
 *  @param completion      网络请求结束 block
 *  @param errorBlcok      调用出错 block
 *
 */

- (MKNetworkOperation*) uploadHouseImageWithPath:(NSString*)path
                       completion:(void (^)(HAHouseImage* obj))completion
                         progress:(void (^)(NSString* certificate, float progress))progressBlock
                          onError:(ErrorBlock)errorBlcok;


/**
 *  上传房源图片
 *
 *  @param array           位置对象数组 HAHousePosition
 *  @param completion      网络请求结束 block
 *  @param errorBlcok      调用出错 block
 *
 */

- (void) relationshipBetweenHousesAndPictures:(NSArray<HAHouseImage*>*)imageArray
                                   completion:(VoidBlock)completion
                                      onError:(ErrorBlock)errorBlcok;



/**
 *  下载房源图片
 *
 *  @param array           位置对象数组 HAHousePosition
 *  @param completion      网络请求结束 block
 *  @param errorBlcok      调用出错 block
 *
 */

- (MKNetworkOperation*) downloadHouseImageWithPath:(NSString*)path
                                      completion:(void (^)(NSString* certificate, NSString* fileName))completion
                                        progress:(void (^)(NSString* certificate, float progress))progressBlock
                                         onError:(ErrorBlock)errorBlcok;



/**
 *  删除房源图片
 *
 *  @param array           位置对象数组 HAHousePosition
 *  @param completion      网络请求结束 block
 *  @param errorBlcok      调用出错 block
 *
 */

- (void) delteHouseImageWithImageId:(NSInteger)imgId
                                        completion:(VoidBlock)completion
                                           onError:(ErrorBlock)errorBlcok;
@end
