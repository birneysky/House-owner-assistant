//
//  HOAKit.m
//  HOAKit
//
//  Created by zhangguang on 16/8/2.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HOAKit.h"

static HOAKit* defaultKitInstance = nil;

@interface HOAKit ()

@property (nonatomic,strong) UINavigationController* rootViewController;

@end

@implementation HOAKit


+ (HOAKit*)defaultInstance
{
    if (!defaultKitInstance) {
        defaultKitInstance = [[HOAKit alloc] init];
    }
    return defaultKitInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (!defaultKitInstance) {
        defaultKitInstance = [super allocWithZone:zone];
    }
    return defaultKitInstance;
}

+ (instancetype) copy{
    return defaultKitInstance;
}

- (UINavigationController*) rootViewController
{
    if (!_rootViewController) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"HOAKit" ofType:@"bundle"];
        NSBundle* bundle = [NSBundle bundleWithPath:path];
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"House-owner-assistant" bundle:bundle];
        _rootViewController = [sb instantiateViewControllerWithIdentifier:@"house_owner_assisnt_nav"];

    }
    return _rootViewController;
}



@end
