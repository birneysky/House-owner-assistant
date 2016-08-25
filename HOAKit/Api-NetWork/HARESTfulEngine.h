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

#define NETWORKENGINE [HARESTfulEngine defaultEngine]


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
                      completion:(void (^)(HAHouse* house))completion
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
                                   params:(HAHouseFacility*)param
                               completion:(void (^)(HAHouseFacility* facility))completion
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

- (void) addHouseBed:(HAHouseBed*)bed
          completion:(void(^)(HAHouseBed* bed))completion
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
                               params:(HAHouse*)param
                           completion:(void(^)(HAHouse* house))completion
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
                           completion:(void (^)(NSArray<HAHousePosition*>* positions))completion
                              onError:(ErrorBlock)errorBlcok;



/**
 *  上传房源图片
 *
 *  @param path            待上传图片的本地路径
 *  @param completion      网络请求结束 block 返回 HAHouseImage 对象
 *  @param progress        上传图片进度 block   // certificate 下载会话标示 progress 现在进度
 *  @param errorBlcok      调用出错 block
 *
 */

- (MKNetworkOperation*) uploadHouseImageWithPath:(NSString*)path
                                      completion:(void (^)(HAHouseImage* obj))completion
                                        progress:(void (^)(NSString* certificate, float progress))progressBlock
                                         onError:(ErrorBlock)errorBlcok;


/**
 *  建立图片和房源的关系
 *
 *  @param imageArray      图片对象数组 HAHouseImage
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
 *  @param path            图片URL路径
 *  @param completion      图片下载完成 block  // certificate 下载会话标示  fileName 文件名
 *  @param progress        下载进度 block     // progress 现在进度
 *  @param errorBlcok      调用出错 block     //
 *
 */

- (MKNetworkOperation*) downloadHouseImageWithPath:(NSString*)path
                                        completion:(void (^)(NSString* certificate, NSString* fileName))completion
                                          progress:(void (^)(NSString* certificate, float progress))progressBlock
                                           onError:(ErrorBlock)errorBlcok;



/**
 *  删除房源图片
 *
 *  @param imgId           图片id
 *  @param completion      网络请求结束 block
 *  @param errorBlcok      调用出错 block
 *
 */

- (void) delteHouseImageWithImageId:(NSInteger)imgId
                         completion:(VoidBlock)completion
                            onError:(ErrorBlock)errorBlcok;


/**
 *  提交房源审核
 *
 *  @param houseId         房源id
 *  @param house           房源对象
 *  @param completion      网络请求结束 block
 *  @param errorBlcok      调用出错 block
 *
 */

- (void) submitHouseInfoForCheckOfHouseId:(NSInteger)houseId
                                   params:(HAHouse*)house
                               completion:(void (^) (HAHouse* house))completion
                                  onError:(ErrorBlock)errorBlcok;
@end
