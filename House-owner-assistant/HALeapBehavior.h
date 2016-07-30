//
//  HALeapBehavior.h
//  House-owner-assistant
//
//  Created by birneysky on 16/7/30.
//  Copyright © 2016年 HA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HALeapBehavior : UIDynamicBehavior

-(void)addItem:(id<UIDynamicItem>) item;
-(void)removeItem:(id<UIDynamicItem>)item;

@end
