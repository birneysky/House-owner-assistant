//
//  HAHouseOrder.h
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAJSONModel.h"

@interface HAHouseOrder : HAJSONModel

@property(nonatomic,assign) NSInteger orderId;
@property(nonatomic,copy)   NSString* orderNo; // '订单号',
@property(nonatomic,assign) NSInteger userId; // '租户ID',
@property(nonatomic,assign) NSInteger houseId; // '房源ID',
@property(nonatomic,assign) NSInteger landlordId; // '房东ID',
@property(nonatomic,copy)   NSString* userName; // '租户名称',
@property(nonatomic,copy)   NSString* userIdNo; // '租户身份证号',
@property(nonatomic,copy)   NSString* userMobile; // '租户手机号',
@property(nonatomic,copy)   NSString* contactName; // '联系人名称',
@property(nonatomic,copy)   NSString* contactMobile; // '联系人手机',
@property(nonatomic,strong) NSDate* reserveTime; // '预订下单时间',
@property(nonatomic,strong) NSDate* reserveCheckinTime; // '预订入住时间',
@property(nonatomic,strong) NSDate* reserveCheckoutTime; // '预订登出时间',
@property(nonatomic,strong) NSDate* checkinTime; // '实际入住时间',
@property(nonatomic,strong) NSDate* checkoutTime; // '实际登出时间',
@property(nonatomic,assign) float reserveAmount; // '租房预订金额',
@property(nonatomic,assign) float reservePrice; // '租房预订单价',
@property(nonatomic,assign) float deposit; // '押金',
@property(nonatomic,assign) float couponDiscount; // '优惠券抵扣',
@property(nonatomic,assign) float pointsDiscount; // '积分抵扣',
@property(nonatomic,assign) float compensationAmount; // '赔偿金金额',
@property(nonatomic,assign) NSInteger compensationChecker; // '赔偿金审核人',
@property(nonatomic,strong) NSDate* compensationCheckTime; // '赔偿金审核时间',
@property(nonatomic,copy)   NSString* compensationImage; // '赔偿证明图像(|)',
@property(nonatomic,copy)   NSString* compensationDesc; // '赔偿说明',
@property(nonatomic,assign) float payAmount; // '支付总金额',
@property(nonatomic,strong) NSDate* payTime; // '支付时间',
@property(nonatomic,strong) NSDate* orderClose; // '订单关闭时间',
@property(nonatomic,assign) NSInteger cleanType; // '保洁方式 0:房东 1:第三方',
@property(nonatomic,assign) float depositRefund; // '押金退还金额',
@property(nonatomic,assign) float returnAmount; // '提前退房退款金-平台计算',
@property(nonatomic,assign) NSInteger returnChecker; // '退房退款金审核人',
@property(nonatomic,assign) NSInteger returnCheckFlag; // '退房退款金审核状态 0:待审核 1:已审核',
@property(nonatomic,copy)   NSString* returnCheckReason;	// comment '退房退款金审核说明',
@property(nonatomic,strong) NSDate* returnCheckTime; // '退房退款金审核时间',
@property(nonatomic,assign) NSInteger compensationStatus; // '赔偿状态 1:无2:待赔偿3:已赔偿',
@property(nonatomic,assign) NSInteger status; // '订单状态 1.待确认 2.待支付 3.待入住 4.入住中 5.脏房 6.已完成',
@property(nonatomic,assign) NSInteger needInvoice; // '是否需要开票 0:不开票 1:开票',
@property(nonatomic,assign) NSInteger invoiceFlag; // '开票标识 0:未开票 1:已开票',
@property(nonatomic,assign) NSInteger userInvoiceId; // '用户发票ID',
@property(nonatomic,copy)   NSString* remarks; // '备注',

@end
