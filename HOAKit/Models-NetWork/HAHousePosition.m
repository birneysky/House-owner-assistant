//
//  HAHousePosition.m
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHousePosition.h"

@implementation HAHousePosition


- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.uniqueId = [value integerValue];
    }
}

@end
