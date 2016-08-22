//
//  HAHouseBed.m
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseBed.h"

@implementation HAHouseBed


- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.bedId = [value integerValue];
    }
}


- (NSDictionary*)toFullDictionary
{
    NSDictionary* dic = [super toFullDictionary];
    NSMutableDictionary* mutableDic = [[NSMutableDictionary alloc] initWithDictionary:dic copyItems:NO];
    [mutableDic removeObjectForKey:@"bedId"];
    [mutableDic setObject:@(self.bedId) forKey:@"id"];
    return [mutableDic copy];
}

@end
