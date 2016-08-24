//
//  EVCircularProgressView.m
//  Test
//
//  Created by Ethan Vaughan on 8/18/13.
//  Copyright (c) 2013 Ethan James Vaughan. All rights reserved.
//

#import "EVCircularProgressView.h"

#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0

@interface EVCircularProgressViewBackgroundLayer : CALayer

@property (nonatomic, strong) UIColor *tintColor;

@end

@implementation EVCircularProgressViewBackgroundLayer

- (id)init
{
    self = [super init];
    
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;
    }
    
    return self;
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetFillColorWithColor(ctx, self.tintColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, self.tintColor.CGColor);
    
    CGRect rect = CGRectMake((self.bounds.size.width - self.bounds.size.height) / 2, 0, self.bounds.size.height, self.bounds.size.height);
    
    CGContextStrokeEllipseInRect(ctx, CGRectInset(rect, 1, 1));
    
//    CGContextFillRect(ctx, CGRectMake(CGRectGetMidX(self.bounds) - 4, CGRectGetMidY(self.bounds) - 4, 8, 8));
}

@end



@interface EVCircularProgressView ()

@property (nonatomic, strong) EVCircularProgressViewBackgroundLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UILabel* percentLabel;

@end

@implementation EVCircularProgressView {
    UIColor *_progressTintColor;
}

- (UILabel*) percentLabel
{
    if (!_percentLabel) {
        _percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 44)];
        _percentLabel.textAlignment = NSTextAlignmentCenter;
        _percentLabel.textColor = self.progressTintColor;
        _percentLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height /2);
    }
    return _percentLabel;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 128, 128)];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    NSLog(@"%@",NSStringFromCGRect(self.bounds));
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    _progressTintColor = [UIColor blackColor];
    
    // Set up the background layer
    
    EVCircularProgressViewBackgroundLayer *backgroundLayer = [[EVCircularProgressViewBackgroundLayer alloc] init];
    backgroundLayer.frame = self.bounds;
    backgroundLayer.tintColor = self.progressTintColor;
    [self.layer addSublayer:backgroundLayer];
    self.backgroundLayer = backgroundLayer;
    
    // Set up the shape layer
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = self.progressTintColor.CGColor;
    
    [self.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
    
    [self addSubview:self.percentLabel];
    
    //[self startIndeterminateAnimation];
}

//- (void)layoutSubviews
//{
//    //[super layoutSubviews];
//     CGRect rect = CGRectMake((self.bounds.size.width - self.bounds.size.height) / 2, 0, self.bounds.size.height, self.bounds.size.height);
//    self.backgroundLayer.frame = rect;
//    self.shapeLayer.frame = rect;
//}

#pragma mark - Accessors

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    _progress = progress;
    
    if (progress > 0 ) {
        BOOL startingFromIndeterminateState = [self.shapeLayer animationForKey:@"indeterminateAnimation"] != nil;
        
        [self stopIndeterminateAnimation];
        
        self.shapeLayer.lineWidth = 3;
        
        self.shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.shapeLayer.bounds), CGRectGetMidY(self.shapeLayer.bounds))
                                                              radius:self.shapeLayer.bounds.size.height/2 - 2
                                                          startAngle:3*M_PI_2
                                                            endAngle:3*M_PI_2 + 2*M_PI
                                                           clockwise:YES].CGPath;
        
        if (animated) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = (startingFromIndeterminateState) ? @0 : nil;
            animation.toValue = [NSNumber numberWithFloat:progress];
            animation.duration = 1;
            self.shapeLayer.strokeEnd = progress;
            
            [self.shapeLayer addAnimation:animation forKey:@"animation"];
        } else {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.shapeLayer.strokeEnd = progress;
            [CATransaction commit];
        }
        
        self.percentLabel.text = [NSString stringWithFormat:@"%.0f %%",progress * 100];
        
        if(progress >= 1)
        {
            // If progress is zero, then add the indeterminate animation

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if([self.shapeLayer animationForKey:@"animation"])
                    [self.shapeLayer removeAnimationForKey:@"animation"];
                self.percentLabel.text = @"0 %";
                self.hidden = YES;
            });
            
            _progress  = 0;
            [self stopIndeterminateAnimation];
            //[self startIndeterminateAnimation];
        }
    }
}

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:YES];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    if ([self respondsToSelector:@selector(setTintColor:)]) {
        self.tintColor = progressTintColor;
    } else {
        _progressTintColor = progressTintColor;
        [self tintColorDidChange];
    }
}

- (UIColor *)progressTintColor
{
    if ([self respondsToSelector:@selector(tintColor)]) {
        return self.tintColor;
    } else {
        return _progressTintColor;
    }
}

#pragma mark - UIControl overrides

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    // Ignore touches that occur before progress initiates
    
    if (self.progress > 0) {
        [super sendAction:action to:target forEvent:event];
    }
}

#pragma mark - Other methods

- (void)tintColorDidChange
{
    self.backgroundLayer.tintColor = self.progressTintColor;
    self.shapeLayer.strokeColor = self.progressTintColor.CGColor;
    self.percentLabel.textColor = self.progressTintColor;
}

- (void)startIndeterminateAnimation
{
    self.hidden = NO;
    if([self.shapeLayer animationForKey:@"indeterminateAnimation"]){
        return;
    }
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    self.backgroundLayer.hidden = YES;
    
    self.shapeLayer.lineWidth = 1;
    self.shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.shapeLayer.bounds), CGRectGetMidY(self.shapeLayer.bounds))
                                                          radius:self.shapeLayer.bounds.size.height/2 - 1
                                                      startAngle:DEGREES_TO_RADIANS(348)
                                                        endAngle:DEGREES_TO_RADIANS(12)
                                                       clockwise:NO].CGPath;
    self.shapeLayer.strokeEnd = 1;
    
    [CATransaction commit];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.shapeLayer addAnimation:rotationAnimation forKey:@"indeterminateAnimation"];
}

- (void)stopIndeterminateAnimation
{
    [self.shapeLayer removeAnimationForKey:@"indeterminateAnimation"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.backgroundLayer.hidden = NO;
    [CATransaction commit];
}

@end
