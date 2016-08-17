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

@end
