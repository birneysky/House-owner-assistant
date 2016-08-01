//
//  HALeapBehavior.m
//  House-owner-assistant
//
//  Created by birneysky on 16/7/30.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "HALeapBehavior.h"

@interface HALeapBehavior ()

@property(nonatomic,strong)UIGravityBehavior* gravityBehavior;
@property(nonatomic,strong)UICollisionBehavior* collisionBehavior;
@property(nonatomic,strong)UIDynamicItemBehavior* itemBehavior;
@property(nonatomic,strong)UIPushBehavior* pushBehavior;

@end

@implementation HALeapBehavior

-(UIGravityBehavior*)gravityBehavior
{
    if (!_gravityBehavior) {
        _gravityBehavior = [[UIGravityBehavior alloc] init];
        _gravityBehavior.magnitude = 2.0;
    }
    return _gravityBehavior;
}

-(UIDynamicItemBehavior*)itemBehavior
{
    if (!_itemBehavior){
        _itemBehavior = [[UIDynamicItemBehavior alloc] init];
    }
    return _itemBehavior;
}

-(UICollisionBehavior*)collisionBehavior
{
    if (!_collisionBehavior) {
        _collisionBehavior = [[UICollisionBehavior alloc] init];
        _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collisionBehavior;
}

-(UIPushBehavior*)pushBehavior
{
    if (!_pushBehavior) {
        _pushBehavior = [[UIPushBehavior alloc] initWithItems:@[] mode:UIPushBehaviorModeInstantaneous];
        
        _pushBehavior.pushDirection = CGVectorMake(0, -10);
        _pushBehavior.magnitude = 1.0;
    }
    return _pushBehavior;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildBehavior:self.gravityBehavior];
        [self addChildBehavior:self.collisionBehavior];
        [self addChildBehavior:self.itemBehavior];
        [self addChildBehavior:self.pushBehavior];
    }
    
    return self;
}

-(void)addItem:(id<UIDynamicItem>) item
{
    [self.gravityBehavior addItem:item];
    [self.collisionBehavior addItem:item];
    [self.itemBehavior addItem:item];
    [self.pushBehavior addItem:item];
}

-(void)removeItem:(id<UIDynamicItem>)item
{
    [self.gravityBehavior removeItem:item];
    [self.collisionBehavior removeItem:item];
    [self.itemBehavior removeItem:item];
    [self.pushBehavior removeItem:item];
}


@end
