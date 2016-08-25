//
//  HASubWay.m
//  HOAKit
//
//  Created by zhangguang on 16/8/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HASubWay.h"

@interface HASubWay ()

@property (nonatomic,strong) NSMutableArray<HASubWay*>* stationArray;

@property (nonatomic,assign) NSInteger typeId;

@property(nonatomic,copy)  NSString* name;

@end

@implementation HASubWay

- (instancetype) initWithDictionary:(NSDictionary *)jsonDic
{
    if (self = [super initWithDictionary:jsonDic]) {
        self.typeId = 3; //3 表示是地铁
    }
    return self;
}

#pragma mark - *** Properties ***
- (NSMutableArray<HASubWay*>*) stationArray
{
    if (!_stationArray) {
        _stationArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _stationArray;
}



#pragma mark - *** Override Super ***
- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.subwayId = [value integerValue];
    }
}

#pragma mark - *** Public ***
- (void) addItem:(HASubWay*) item
{
    [self.stationArray addObject:item];
}

- (NSArray<HASubWay*>*)stations
{
    return [_stationArray copy];
}


-(NSArray<id<HAGeneralPosition>>*) subItems
{
    return [self stations];
}

- (NSInteger) positionId
{
    return self.subwayId;
}



@end
