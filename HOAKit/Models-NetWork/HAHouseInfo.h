//
//  HAHouseInfo.h
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAHouseInfo : NSObject

@property(nonatomic,assign) NSInteger infoId;
@property(nonatomic,assign) NSInteger landlordId;		//房东ID
@property(nonatomic,copy) NSArray<NSString*>* houseImages; //图片列表
@property(nonatomic,copy) NSString* title;			//房源标题”
@property(nonatomic,copy) NSString* headerImage;		//房东头像
@property(nonatomic,assign) float price;  //房间日价
@property(nonatomic,assign) NSInteger cityId;  //房源所属城市
@property(nonatomic,assign) NSInteger commentCount;  //评论数量  count comments
@property(nonatomic,assign) float averageGeneralScore;  //平均的得分  average comments
//	@property(nonatomic,assign) NSInteger totalReservation; //总的预定天数  sum from house_order
@property(nonatomic,assign) NSInteger rentType; //出租方式
@property(nonatomic,assign) NSInteger roomNumber; //卧室的数量
@property(nonatomic,assign) NSInteger toliveinNumber; 	//3可住人数
@property(nonatomic,assign) BOOL hasConllected; 	//是否收藏

@end
