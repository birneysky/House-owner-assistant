//
//  HARESTfulEngine.m
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HARESTfulEngine.h"

NSString* const kBaseURL = @"http://120.76.28.47:8080/yisu";

static HARESTfulEngine* defaultEngine;

@implementation HARESTfulEngine

+ (HARESTfulEngine*)defaultEngine
{
    if (!defaultEngine) {
        defaultEngine = [[HARESTfulEngine alloc] initWithHostName:kBaseURL];
    }
    return defaultEngine;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (!defaultEngine) {
        defaultEngine = [super allocWithZone:zone];
    }
    return defaultEngine;
}

+ (instancetype) copy{
    return defaultEngine;
}

@end
