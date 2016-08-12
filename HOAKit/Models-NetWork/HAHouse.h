//
//  HAHouse.h
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAHouse : NSObject

- (instancetype) initWithDictionary:(NSDictionary*)dic;

@property(nonatomic,assign) NSInteger houseId;
@property(nonatomic,assign) NSInteger landlordId;		// '房东ID',
@property(nonatomic,copy)   NSString* title;		// '房屋名称',
@property(nonatomic,copy)   NSString* area;		// '房屋面积',
@property(nonatomic,assign) NSInteger  roomNumber;		// '室的数量',
@property(nonatomic,assign) NSInteger  hallNumber;		// '厅的数量',
@property(nonatomic,assign) NSInteger  kitchenNumber;		// '厨的数量',
@property(nonatomic,assign) NSInteger  balconyNumber;		// '阳台的数量',
@property(nonatomic,assign) NSInteger  toiletNumber;		// '独立卫生间数量',
@property(nonatomic,assign) NSInteger  publicToiletNumber;		// '公共卫生间数量',
@property(nonatomic,assign) NSInteger  hasBasement;		// '是否有地下室',
@property(nonatomic,assign) NSInteger  toliveinNumber;		// '可住人数',
@property(nonatomic,assign) NSInteger  province;		// '省份',
@property(nonatomic,assign) NSInteger  city;		// '地市',
@property(nonatomic,assign) NSInteger  distict;		// '区县',
@property(nonatomic,copy)   NSString*  address;		//
@property(nonatomic,copy)   NSString*  houseNumber;		// '门牌号',
@property(nonatomic,assign) double lng;		//'经度',
@property(nonatomic,assign) double lat;		// '纬度',
@property(nonatomic,copy)   NSString*   houseType;		// '房源类型',
@property(nonatomic,assign) NSInteger   rentType;		//
@property(nonatomic,copy)   NSString*   description;		// '描述',
@property(nonatomic,copy)   NSString*   position;		// '地理位置描述',
@property(nonatomic,copy)   NSString*   traffic;		// '交通描述',
@property(nonatomic,copy)   NSString*   surroundings;		// '周边生活',
@property(nonatomic,assign) float     price;		// '日价',
@property(nonatomic,assign) NSInteger   toForeigner;		// '是否接待境外人士',
@property(nonatomic,copy)   NSString*   checkinTime;		// '入住时间',
@property(nonatomic,copy)   NSString*   checkoutTime;		// '退房时间',
@property(nonatomic,copy)   NSString*   receptionTime;		// '接待时间',
@property(nonatomic,assign) NSInteger   atLeastDays;		//
@property(nonatomic,assign) NSInteger   inMostDays;		//
@property(nonatomic,assign) NSInteger   needDeposit;		// '是否需要押金',
@property(nonatomic,assign) float     depositAmount;		// '押金金额',
@property(nonatomic,assign) NSInteger   thirdCleaning;		// '是否需要第三方保洁？',
@property(nonatomic,assign) NSInteger   platformToiletries;		// '平台提供洗漱用品？',
@property(nonatomic,assign) NSInteger   platformBedding;		// '平台提供床品？',
@property(nonatomic,assign) NSInteger   platformRecommend;		// '平台推荐',
@property(nonatomic,assign) NSInteger   adminLock;		//
@property(nonatomic,assign) NSInteger   type7Rate;		// '连住7天折扣率',
@property(nonatomic,assign) NSInteger   type3Rate;		// '连住3天折扣率',
@property(nonatomic,assign) NSInteger   type15Rate;		// '连住15天折扣率',
@property(nonatomic,assign) NSInteger   type30Rate;		// '连住30天折扣率',
@property(nonatomic,assign) NSInteger   checkStatus;// '资料审核状态0 待审核 1 审核待完善  2 审核不通过 3 审核通过',
@property(nonatomic,assign) NSInteger   operationStatus;		// '运营状态 0 正常 1 房东下线 2 平台锁定',
@property(nonatomic,copy)   NSString*   remark;		// '备注'

@end
