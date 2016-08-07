//
//  HABed.h
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@interface HABed : NSObject

@property(nonatomic,copy) NSString* type;
@property (nonatomic,assign) CGFloat length;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) NSUInteger count;

@end
