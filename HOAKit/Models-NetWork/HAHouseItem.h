//
//  HAHouseItem.h
//  HOAKit
//
//  Created by birneysky on 16/8/14.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAJSONModel.h"

@interface HAHouseItem : HAJSONModel

/*
 "id":1,"landlordId":1,"houseImages":null,"title":"王府1号","headerImage":"/images/avatar/1.png","price":1000.0,"provinceId":110000,"cityId":110100,"distictId":110101,"address":"北京王府井1号","commentCount":2,"averageGeneralScore":4.5,"rentType":1,"roomNumber":3,"toliveinNumber":8,"hasConllected":null
 
 */

@property (nonatomic,assign) NSInteger itemID;

@property(nonatomic,assign) NSInteger landlordId;

@property (nonatomic,copy) NSString* houseImages;

@property (nonatomic,copy) NSString* title;

@property (nonatomic,copy) NSString* headerImage;

@property (nonatomic,assign) float price;

@property (nonatomic,assign) NSInteger provinceId;

@property (nonatomic,assign) NSInteger cityId;

@property (nonatomic,assign) NSInteger distictId;

@property (nonatomic,copy) NSString* address;

@property (nonatomic,assign) NSInteger commentCount;

@property (nonatomic,assign) float averageGeneralScore;

@property (nonatomic,assign) NSInteger rentType;

@property (nonatomic,assign) NSInteger roomNumber;

@property (nonatomic,assign) NSInteger toliveinNumber;

@property (nonatomic,assign) NSInteger hasConllected;

@end
