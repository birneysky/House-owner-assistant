//
//  HAHouseImage.m
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseImage.h"

@implementation HAHouseImage

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.imageId = [value integerValue];
    }
}

- (NSDictionary*) toFullDictionary
{
    NSDictionary* dic = [super toFullDictionary];
    NSMutableDictionary* mutableDic = [[NSMutableDictionary alloc] initWithDictionary:dic copyItems:NO];
    [mutableDic removeObjectForKey:@"imageId"];
    [mutableDic setObject:@(self.imageId) forKey:@"id"];
    [mutableDic removeObjectForKey:@"localPath"];
    [mutableDic removeObjectForKey:@"progress"];
    [mutableDic removeObjectForKey:@"stauts"];
    [mutableDic removeObjectForKey:@"loadType"];
    return [mutableDic copy];
}

@end
