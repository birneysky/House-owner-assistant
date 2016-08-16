//
//  HAPosition.h
//  HOAKit
//
//  Created by zhangguang on 16/8/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAJSONModel.h"

@interface HAPosition : HAJSONModel

@property (nonatomic,assign) NSInteger cityId;
@property (nonatomic,assign) NSInteger enable;
@property (nonatomic,copy)   NSString* firstChar;
@property (nonatomic,assign) NSInteger positionId;
@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lng;
@property (nonatomic,copy)   NSString* name;
@property (nonatomic,copy)   NSString* pinyin;
@property (nonatomic,assign) NSInteger sort;
@property (nonatomic,assign) NSInteger typeId;

@end
