//
//  HAHouseComment.m
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseComment.h"

@implementation HAHouseComment

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.CommentId = [value integerValue];
    }
}

@end
