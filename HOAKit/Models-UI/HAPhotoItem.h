//
//  HAPhotoItem.h
//  HOAKit
//
//  Created by birneysky on 16/8/21.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAPhotoItem : NSObject

@property (nonatomic,assign) NSInteger imageId;

@property (copy,nonatomic) NSString* path;

@property (assign,nonatomic) float progress;

@end
