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
            name = @"上线中";
            break;
        case 2:
            name = @"已通过";
            break;
        case 3:
            name = @"被拒绝";
            break;
        case 4:
            name = @"待完善";
            break;
    }
    return name;
}

+ (NSString*)bedName:(NSInteger)type
{
    NSArray* array = @[@"双人床",@"单人床",@"双层床",@"榻榻米",@"其他"];
    NSString* name = nil;
    NSInteger index = type - 1;
    if (index < array.count) {
        name = array[index];
    }
    return name;
}

+ (NSInteger)typeForBedName:(NSString*)name
{
    NSArray* array = @[@"双人床",@"单人床",@"双层床",@"榻榻米",@"其他"];
    NSInteger index = [array indexOfObject:name];
    if (index >= 0) {
        return index + 1;
    }
    return index;
}

+ (NSArray<HAPosition*>*) positionsFromProvince:(NSInteger)provinceId city:(NSInteger)cityId house:(NSInteger)houseId
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"HOAKit.bundle/province" ofType:@"json"];
    
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    NSError* error;
    NSDictionary* provincialCity = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSArray<NSDictionary*>* provincesArray = provincialCity[@"child"];
    __block NSInteger provinceIndex = -1;
    [provincesArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger provinceItemId = [[obj objectForKey:@"ID"] integerValue];
        if (provinceId == provinceItemId) {
            provinceIndex = idx;
            *stop = YES;
        }
    }];
    
    NSDictionary* province = provincesArray[provinceIndex];
    NSArray<NSDictionary*>* citysArray = [province objectForKey:@"child"];
    __block NSInteger cityIndex = -1;
    [citysArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger cityItemId = [[obj objectForKey:@"ID"] integerValue];
        if (cityId == cityItemId) {
            cityIndex = idx;
        }
    }];
    
    NSDictionary* city = citysArray[cityIndex];
    NSArray<NSDictionary*>* distictsArray = city[@"child"];
    NSMutableArray<HAPosition*>* mutableDistictsArray = [[NSMutableArray alloc] initWithCapacity:100];
    [distictsArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HAPosition* position = [[HAPosition alloc] init];
        position.cityId = cityId;
        position.name = [obj objectForKey:@"Name"];
        position.positionId = [[obj objectForKey:@"ID"] integerValue];
        position.typeId = 5;
//        position.houseId = houseId;
//        position.positionId = [[obj objectForKey:@"ID"] integerValue];
//        position.positionTypeId = 5; //5 表示行政区域
        [mutableDistictsArray addObject:position];
    }];
    
    
    return [mutableDistictsArray copy];
}




+ (NSString*) provincesAndCityAddress:(NSInteger)provinceId city:(NSInteger)cityId distict:(NSInteger)distictId
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"HOAKit.bundle/province" ofType:@"json"];
    
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    NSError* error;
    NSDictionary* provincialCity = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableString* addresss = [[NSMutableString alloc] init];
    NSArray<NSDictionary*>* provincesArray = provincialCity[@"child"];
    __block NSInteger provinceIndex = -1;
    [provincesArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger provinceItemId = [[obj objectForKey:@"ID"] integerValue];
        if (provinceId == provinceItemId) {
            provinceIndex = idx;
            NSString* proviceName =  [obj objectForKey:@"Name"];
            [addresss appendString:proviceName];
            *stop = YES;
        }
        
    }];
    
    NSDictionary* province = provincesArray[provinceIndex];
    NSArray<NSDictionary*>* citysArray = [province objectForKey:@"child"];
    __block NSInteger cityIndex = -1;
    [citysArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger cityItemId = [[obj objectForKey:@"ID"] integerValue];
        if (cityId == cityItemId) {
            cityIndex = idx;
            NSString* cityName = [obj objectForKey:@"Name"];
            [addresss appendFormat:@"-%@",cityName];
            *stop = YES;
        }
    }];
    
    NSDictionary* city = citysArray[cityIndex];
    NSArray<NSDictionary*>* distictsArray = city[@"child"];
    
    [distictsArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
         NSInteger distictItemId = [[obj objectForKey:@"ID"] integerValue];
        if (distictItemId == distictId) {
            NSString* distictName =  [obj objectForKey:@"Name"];
            [addresss appendFormat:@"-%@",distictName];
            *stop = YES;
        }
    }];
    
    
    return [addresss copy];
}

@end
