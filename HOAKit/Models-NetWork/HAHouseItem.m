//
//  HAHouseItem.m
//  HOAKit
//
//  Created by birneysky on 16/8/14.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseItem.h"

@implementation HAHouseItem

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.itemID = [value integerValue];
    }
}

- (void) setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"platformToiletries"]) {
        self.hasConllected = 0;
    }
}

@end
