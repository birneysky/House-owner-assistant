//
//  HAArea.h
//  HOAKit
//
//  Created by zhangguang on 16/8/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAJSONModel.h"
#import "HAGeneralPosition.h"

@interface HARegion : NSObject 

- (instancetype) initWithName:(NSString*)name;

@property (nonatomic,readonly) NSString* name;

@property (nonatomic,readonly) NSArray<id<HAGeneralPosition>>* subItems;

- (void)addSubItem:(id<HAGeneralPosition>)item;

- (void)addItems:(NSArray<id<HAGeneralPosition>>*)items;

- (id<HAGeneralPosition>)subItemWithID:(NSInteger)Id;

@end
