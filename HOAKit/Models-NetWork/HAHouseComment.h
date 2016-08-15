//
//  HAHouseComment.h
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAJSONModel.h"

@interface HAHouseComment : HAJSONModel

@property(nonatomic,assign) NSInteger CommentId;
@property(nonatomic,assign) NSInteger houseId;		// '房源ID',
@property(nonatomic,assign) NSInteger userId;		// '租客ID',
@property(nonatomic,assign) NSInteger orderId;		// '订单ID',
@property(nonatomic,assign) NSInteger generalScore;		// '0:未评价;1-5:五星级别',
@property(nonatomic,assign) NSInteger positionScore;		// '0:未评价;1-5:五星级别',
@property(nonatomic,assign) NSInteger serviceScore;		// '服务评价 0:未评价;1-5:五星级别',
@property(nonatomic,assign) NSInteger cleanScore;		// '清洁评价 0:未评价;1-5:五星级别',
@property(nonatomic,assign) NSInteger comfortScore;		// '舒适度评价 0:未评价;1-5:五星级别',
@property(nonatomic,assign) NSInteger facilityScore;		// '设施评价 0:未评价;1-5:五星级别',
@property(nonatomic,assign) NSInteger cateringScore;		// '餐饮评价 0:未评价;1-5:五星级别',
@property(nonatomic,assign) NSInteger commentTime;		//
@property(nonatomic,assign) NSInteger status;		// '状态 0:初始化 1:删除',
@property(nonatomic,assign) NSInteger comments;		// '评价内容',
@property(nonatomic,copy) NSString* reply;

@end
