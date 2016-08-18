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



@end

@implementation HASubWay

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
