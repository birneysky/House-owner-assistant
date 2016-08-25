//
//  FloatingButton.m
//  House-owner-assistant
//
//  Created by birneysky on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "HAFloatingButton.h"

@interface HAFloatingButton ()

@property (nonatomic,assign) BOOL firstTouch;

@property (nonatomic,assign) CGPoint beginPoint;

@end

@implementation HAFloatingButton

#pragma mark - *** Init ***
- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

#pragma mark - *** Gesture Selector ***
- (void)changePostion:(UIPanGestureRecognizer *)pan
{
    const CGFloat SCREENWIDTH = [UIScreen mainScreen].bounds.size.width;
    const CGFloat SCREENHEIGHT = [UIScreen mainScreen].bounds.size.height;
    if (!_firstTouch) {
        _beginPoint = [pan locationInView:self];
        _firstTouch = YES;
    }
    
    CGPoint nowPoint = [pan locationInView:self];
    float winWidth = self.frame.size.width;
    float winHeight = self.frame.size.height;
    float offsetX = nowPoint.x - _beginPoint.x;
    float offsetY = nowPoint.y - _beginPoint.y;
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
    
    if(centerY < (64 + (winHeight / 2)))
    {
        centerY = 64 + (winHeight / 2);
    }
    else if(centerY > SCREENHEIGHT - winHeight / 2)
    {
        centerY = SCREENHEIGHT - winHeight / 2;
    }
    
    self.center = CGPointMake(centerX, centerY);
}

@end
