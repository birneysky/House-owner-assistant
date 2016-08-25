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
    [hud showAnimated:YES];
    return hud;
}

+ (HAActiveWheel *)showHUDAddedToWindow:(UIWindow *)window{
    HAActiveWheel* hud = [[HAActiveWheel alloc] initWithView:window];
    hud.contentColor = [UIColor whiteColor];
    [window addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}



+(void)dismissForView:(UIView*)view
{
    MBProgressHUD* hud = [super HUDForView:view];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES];


}

+ (void)dismissViewDelay:(NSTimeInterval)interval forView:(UIView*)view warningText:(NSString*)text;
{

    HAActiveWheel* wheel = (HAActiveWheel*)[super HUDForView:view];;
    [wheel performSelector:@selector(setWarningString:) withObject:text afterDelay:0];
    [HAActiveWheel performSelector:@selector(dismissForView:) withObject:view afterDelay:interval];
}

+ (void)dismissForView:(UIView *)view delay:(NSTimeInterval)interval
{
       [HAActiveWheel performSelector:@selector(dismissForView:) withObject:view afterDelay:interval];
}

- (void)setProcessString:(NSString *)processString
{
    //self.labelColor = [UIColor colorWithRed:219/255.0f green:78/255.0f blue:32/255.0f alpha:1];
    self.label.text = processString;
}

- (void)setWarningString:(NSString *)warningString
{
    self.label.textColor = [UIColor redColor];
    self.label.text = warningString;
}

@end
