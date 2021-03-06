//
//  HAPosition.h
//  HOAKit
//
//  Created by zhangguang on 16/8/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAJSONModel.h"
#import "HAGeneralPosition.h"

@interface HAPosition : HAJSONModel <HAGeneralPosition>

@property (nonatomic,assign) NSInteger cityId;
@property (nonatomic,assign) NSInteger enable;
@property (nonatomic,copy)   NSString* firstChar;
@property (nonatomic,assign) NSInteger positionId;
@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lng;

@property (nonatomic,copy)   NSString* pinyin;
@property (nonatomic,assign) NSInteger sort;
@property (nonatomic,assign) NSInteger typeId;

@property (nonatomic,readonly) NSArray<id<HAGeneralPosition>>* subItems;

- (void)setName:(NSString *)name;

- (NSString*)name;

@end
