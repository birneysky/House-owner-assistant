//
//  HAAppDataHelper.m
//  HOAKit
//
//  Created by zhangguang on 16/8/15.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAAppDataHelper.h"

@implementation HAAppDataHelper

+ (NSString*)rentTypeName:(NSInteger)type
{
    NSString* name = nil;
    switch (type) {
        case 1:
            name = @"整套出租";
            break;
        case 2:
            name = @"单间出租";
            break;
    }
    return name;
}

+ (NSString*)houseTypeName:(NSInteger)type
{
    NSArray* array = @[@"民居",@"公寓",@"独栋别墅",@"客栈",@"阁楼",@"四合院",@"海边小屋",@"林间小屋",@"豪宅",@"城堡",@"树屋",@"船舱",@"房车",@"冰屋"];
    NSString* name = nil;
    NSInteger index = type - 1;
    if (index < array.count) {
        name = array[index];
    }
    return name;
}

+ (NSString*)checkStatusText:(NSInteger)status
{
    NSString* name = nil;
    switch (status) {
        case 1:
            name = @"待审核";
            break;
        case 2:
            name = @"已通过";
            break;
        case 3:
            name = @"已拒绝";
            break;
        case 4:
            name = @"补充材料";
            break;
    }
    return name;
}

+ (NSString*)bedName:(NSInteger)type
{
    NSArray* array = @[@"双人床",@"单人床",@"双层床",@"单人沙发床",@"双人沙发床",@"儿童床",@"园床",@"气垫床"];
    NSString* name = nil;
    NSInteger index = type - 1;
    if (index < array.count) {
        name = array[index];
    }
    return name;
}

+ (NSInteger)typeForBedName:(NSString*)name
{
    NSArray* array = @[@"双人床",@"单人床",@"双层床",@"单人沙发床",@"双人沙发床",@"儿童床",@"园床",@"气垫床"];
    NSInteger index = [array indexOfObject:name];
    if (index > 0) {
        return index + 1;
    }
    return index;
}

@end
