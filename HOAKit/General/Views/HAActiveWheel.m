//
//  ActiveWheel.m
//  V2_Conference
//
//  Created by zhangguang on 14/12/10.
//  Copyright (c) 2014年 com.v2tech. All rights reserved.
//

#import "HAActiveWheel.h"
//#import "Toast+UIView.h"

//static const NSString* startLabelText = @"正在处理";
//static const NSString* timeoutText = @"处理超时";

@interface HAActiveWheel ()
@property (nonatomic) BOOL* ptimeoutFlag;
@end

@implementation HAActiveWheel

- (id)initWithView:(UIView *)view
{
    self = [super initWithView:view];
    if (self) {
    }
    return self;
}

-(id)initWithWindow:(UIWindow *)window{
    self = [super initWithWindow:window];
    if (self) {
        
    }
    return self;
}

-(void)dealloc
{
    self.processString = nil;
}


+ (HAActiveWheel*)showHUDAddedTo:(UIView *)view
{
    HAActiveWheel* hud = [[HAActiveWheel alloc] initWithView:view];
    hud.contentColor = [UIColor whiteColor];
    [view addSubview:hud];
    [hud show:YES];
    return hud;
}

+ (HAActiveWheel *)showHUDAddedToWindow:(UIWindow *)window{
    HAActiveWheel* hud = [[HAActiveWheel alloc] initWithWindow:window];
    hud.contentColor = [UIColor whiteColor];
    [window addSubview:hud];
    [hud show:YES];
    return hud;
}



+(void)dismissForView:(UIView*)view
{
    NSArray *huds = [super allHUDsForView:view];
    for (HAActiveWheel *hud in huds) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
    }

}

+ (void)dismissViewDelay:(NSTimeInterval)interval forView:(UIView*)view warningText:(NSString*)text;
{
    NSArray *huds = [super allHUDsForView:view];
    HAActiveWheel* wheel = huds.firstObject;
    [wheel performSelector:@selector(setWarningString:) withObject:text afterDelay:0];
    [HAActiveWheel performSelector:@selector(dismissForView:) withObject:view afterDelay:interval];
}

- (void)setProcessString:(NSString *)processString
{
    //self.labelColor = [UIColor colorWithRed:219/255.0f green:78/255.0f blue:32/255.0f alpha:1];
    self.labelText = processString;
}

- (void)setWarningString:(NSString *)warningString
{
    self.labelColor = [UIColor redColor];
    self.labelText = warningString;
}

@end
