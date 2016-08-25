//
//  ActiveWheel.h
//  V2_Conference
//
//  Created by zhangguang on 14/12/10.
//  Copyright (c) 2014年 com.v2tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HAActiveWheel : MBProgressHUD

@property(nonatomic,copy) NSString* processString;
@property(nonatomic,copy) NSString* toastString;
@property(nonatomic,copy) NSString* warningString;

+ (HAActiveWheel*)showHUDAddedTo:(UIView *)view;
+ (HAActiveWheel*)showHUDAddedToWindow:(UIWindow *)window;
+ (void)dismissForView:(UIView*)view;

+ (void)dismissForView:(UIView *)view delay:(NSTimeInterval)interval;

+ (void)dismissViewDelay:(NSTimeInterval)interval forView:(UIView*)view warningText:(NSString*)text;


@end
