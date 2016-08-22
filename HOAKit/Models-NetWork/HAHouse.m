//
//  HAHouse.m
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouse.h"
#import <objc/runtime.h>

@implementation HAHouse


- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.houseId = [value integerValue];
    }
    
    if ([key isEqualToString:@"description"]) {
        self.houseDescription = value;
    }
}

- (void) setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"platformToiletries"]) {
        self.platformToiletries = 0;
    }
    
    if ([key isEqualToString:@"cleanType"]) {
        self.cleanType = 0;
    }
}

- (NSDictionary*) toFullDictionary
{
    NSDictionary* dic = [super toFullDictionary];
    NSMutableDictionary* mutableDic = [[NSMutableDictionary alloc] initWithDictionary:dic copyItems:NO];
    [mutableDic removeObjectForKey:@"houseId"];
    [mutableDic setObject:@(self.houseId) forKey:@"id"];
    [mutableDic removeObjectForKey:@"houseDescription"];
    [mutableDic setObject:self.houseDescription ? self.houseDescription : [NSNull null] forKey:@"description"];
    return [mutableDic copy];
}

- (BOOL) isEqualToHouse:(HAHouse*)house
{
//    unsigned count;
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    
//    for (int i = 0; i < count; i++) {
//        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
//        if ([key isEqualToString:@"description"]) {
//            continue;
//        }
//        id selfvalue = [self valueForKey:key];
//        id otherValue = [house valueForKey:key];
//        if ([selfvalue isKindOfClass:[NSString class]]) {
//            NSLog(@"%@",[selfvalue class]);
//        }
//        
//        
//    }
//    
//    free(properties);
    NSDictionary* selfDic = [self toFullDictionary];
    NSDictionary* otherDic = [house toFullDictionary];
    return [selfDic isEqualToDictionary:otherDic];
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    NSDictionary* dictory = [super toFullDictionary];
    HAHouse* copyInstance = [[HAHouse allocWithZone:zone] initWithDictionary:dictory];
//    size_t instanceSize = class_getInstanceSize([self class]);
//    memcpy((__bridge  void *)(copyInstance), (__bridge const  void *)(self), instanceSize);
    return copyInstance;
}

- (NSString*)stringValueOfChineseName:(NSString*)text
{
    NSString* value = nil;
//    if([text isEqualToString:@"线上收取押金"]){
//        value = [NSString stringWithFormat:@"%d",self.needDeposit];
//    }
//    if ([text isEqualToString:@"需要第三方保洁"]) {
//        value = [NSString stringWithFormat:@"%d",self.thirdCleaning];
//    }
//    
//    if ([text isEqualToString:@"平台提供洗漱用品"] ) {
//        value = [NSString stringWithFormat:@"%d",self.platformToiletries];
//    }
//    
//    if ([text isEqualToString:@"平台提供床品"]) {
//        
//    }
    
    if([text isEqualToString:@"日价"] ){
        value = [NSString stringWithFormat:@"%.0f",self.price];
    }
    
    if ([text isEqualToString:@"押金"]) {
        value = [NSString stringWithFormat:@"%.0f", self.depositAmount];
    }
    
    if([text isEqualToString:@"3天折扣"]){
        value = [NSString stringWithFormat:@"%.1f",self.type3Rate / 10.0f];
    }
    
    if ([text isEqualToString:@"7天折扣"]) {
        value = [NSString stringWithFormat:@"%.1f",self.type7Rate / 10.0f];
    }
    
    if ([text isEqualToString:@"15天折扣"]) {
        value = [NSString stringWithFormat:@"%.1f",self.type15Rate / 10.0f];
    }
    
    
    if ( [text isEqualToString:@"30天折扣"]) {
        value = [NSString stringWithFormat:@"%.1f",self.type30Rate / 10.0f];
    }
    
    return value;
}

- (BOOL) boolValueOfChineseName:(NSString*)text
{
    BOOL value = NO;
    if([text isEqualToString:@"线上收取押金"]){
        value = self.needDeposit;
    }
    if ([text isEqualToString:@"需要第三方保洁"]) {
        value = self.cleanType;
    }
    
    if ([text isEqualToString:@"平台提供洗漱用品"] ) {
        value = self.platformToiletries;
    }
    return value;
}

- (BOOL) setValue:(NSString*)value forChineseName:(NSString*)text
{
    //@"3天折扣",@"7天折扣",@"15天折扣",@"30天折扣"
    BOOL valid = YES;
    if ([text isEqualToString:@"3天折扣"]) {
        self.type3Rate = [value floatValue]* 10;
    }
    
    if ([text isEqualToString:@"7天折扣"]) {
        self.type7Rate = [value floatValue] * 10;
    }
    
    if ([text isEqualToString:@"15天折扣"]) {
        self.type15Rate = [value floatValue]* 10;
    }
    
    if ([text isEqualToString:@"30天折扣"]) {
        self.type30Rate = [value floatValue]* 10;
    }
    
    if([text isEqualToString:@"日价"])
    {
        self.price = [value floatValue];
    }
    
    if([text isEqualToString:@"押金"])
    {
        self.depositAmount = [value floatValue];
    }
    
    if ([text isEqualToString:@"房屋面积"]) {
        self.area = value;
    }
    
    if ([text isEqualToString:@"几位访客"]) {
        self.toliveinNumber = [value integerValue];
    }
    
    if ([self.area floatValue] > 99999) {
        valid = NO;
    }
    
    if (self.price > 99999) {
        valid = NO;
    }
    
    if (self.depositAmount > 99999) {
        valid = NO;
    }
    
    if(self.toliveinNumber > 10 )
    {
        valid = NO;
    }
    return valid;
}

@end
