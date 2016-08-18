//
//  HAPosition.m
//  HOAKit
//
//  Created by zhangguang on 16/8/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAPosition.h"

@implementation HAPosition


- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.positionId = [value integerValue];
    }
}


- (void) setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"lat"]) {
        self.lat = 0;
    }
    
    if ([key isEqualToString:@"lng"]) {
        self.lng = 0;
    }
}

-(NSArray<id<HAGeneralPosition>>*) subItems
{
    return nil;
}

@end
