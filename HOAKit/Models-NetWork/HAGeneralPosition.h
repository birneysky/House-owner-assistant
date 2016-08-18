//
//  HAGeneralPosition.h
//  HOAKit
//
//  Created by zhangguang on 16/8/18.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HAGeneralPosition <NSObject>

@required
@property (nonatomic,readonly) NSString* name;

@property (nonatomic,assign) NSInteger positionId;

//@property (nonatomic,readonly) NSInteger count;

@property (nonatomic,readonly) NSArray<id<HAGeneralPosition>>* subItems;

@end
