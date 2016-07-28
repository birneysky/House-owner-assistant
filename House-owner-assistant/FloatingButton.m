//
//  FloatingButton.m
//  House-owner-assistant
//
//  Created by birneysky on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "FloatingButton.h"

@implementation FloatingButton
{
    CGPoint beginPoint;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    if (!self.dragEnable) {
//        return;
//    }
    UITouch *touch = [touches anyObject];
    
    const CGFloat SCREENWIDTH = [UIScreen mainScreen].bounds.size.width;
    const CGFloat SCREENHEIGHT = [UIScreen mainScreen].bounds.size.height;
    
    CGPoint nowPoint = [touch locationInView:self];
    float winWidth = self.frame.size.width;
    float winHeight = self.frame.size.height;
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    float centerX = self.center.x + offsetX;
    float centerY = self.center.y + offsetY;
    if(centerX < winWidth / 2)
    {
        centerX = winWidth / 2;
    }
    else if( centerX > SCREENWIDTH - winWidth / 2)
    {
        centerX = SCREENWIDTH - winWidth / 2;
    }
    
    if(centerY < winHeight / 2)
    {
        centerY = winHeight / 2;
    }
    else if(centerY > SCREENHEIGHT - winHeight / 2)
    {
        centerY = SCREENHEIGHT - winHeight / 2;
    }
    
    self.center = CGPointMake(centerX, centerY);
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event
{
    NSLog(@"==>DragView touchesEnded");
    //[self automaticallyLandTheCorner];
}


@end
