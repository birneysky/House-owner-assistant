//
//  HASubWay.h
//  HOAKit
//
//  Created by zhangguang on 16/8/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAJSONModel.h"
#import "HAGeneralPosition.h"

@interface HASubWay : HAJSONModel <HAGeneralPosition>

/*
 levelType 1 表示地铁线路
 levelType 2 表示地铁站
 */

@property(nonatomic,assign) NSInteger cityId;
@property(nonatomic,copy) NSString* firstChar;
@property(nonatomic,assign) NSInteger subwayId;
@property(nonatomic,assign) NSInteger levelType;
@property(nonatomic,assign) NSInteger lineType;
@property(nonatomic,readonly)  NSString* name;
@property(nonatomic,assign) NSInteger parentId;
@property(nonatomic,copy) NSString* pinyin;
@property(nonatomic,copy) NSString* transfer;


@property (nonatomic,readonly,getter=subItems) NSArray<id<HAGeneralPosition>>* stations;

- (void) addItem:(HASubWay*) item;


//- (HASubWay*)subItemWithID:(NSInteger)subwayId;


/*
 
 cityId = 110100;
 firstChar = "<null>";
 id = 2;
 levelType = 1;
 lineType = 1;
 name = "2\U53f7\U7ebf";
 parentId = 0;
 pinyin = "<null>";
 transfer = "<null>";
 */

@end
