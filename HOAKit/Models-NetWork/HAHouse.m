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
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    id copyInstance = [[[self class] allocWithZone:zone] init];
    size_t instanceSize = class_getInstanceSize([self class]);
    memcpy((__bridge  void *)(copyInstance), (__bridge const  void *)(self), instanceSize);
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
        value = [NSString stringWithFormat:@"%.1f",self.type3Rate];
    }
    
    if ([text isEqualToString:@"7天折扣"]) {
        value = [NSString stringWithFormat:@"%.1f",self.type7Rate];
    }
    
    if ([text isEqualToString:@"15天折扣"]) {
        value = [NSString stringWithFormat:@"%.1f",self.type15Rate];
    }
    
    
    if ( [text isEqualToString:@"30天折扣"]) {
        value = [NSString stringWithFormat:@"%.1f",self.type30Rate];
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
        value = self.thirdCleaning;
    }
    
    if ([text isEqualToString:@"平台提供洗漱用品"] ) {
        value = self.platformToiletries;
    }
    return value;
}

@end
