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

//转轮消失前，需保证TimeoutFlag指针是有效的
+ (HAActiveWheel*)showHUDAddedTo:(UIView *)view Timeout:(NSTimeInterval)time TimeoutFlag:(BOOL*)flag;

+ (HAActiveWheel*)showHUDAddedTo:(UIView *)view;
+ (HAActiveWheel*)showHUDAddedToWindow:(UIWindow *)window;
+ (void)dismissForView:(UIView*)view;

+ (void)dismissViewDelay:(NSTimeInterval)interval forView:(UIView*)view warningText:(NSString*)text;


@end
