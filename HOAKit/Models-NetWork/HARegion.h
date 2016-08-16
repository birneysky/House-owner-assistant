//
//  HAArea.h
//  HOAKit
//
//  Created by zhangguang on 16/8/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAJSONModel.h"

@interface HARegion : NSObject

- (instancetype) initWithName:(NSString*)name;

@property (nonatomic,readonly) NSString* name;

@property (nonatomic,readonly) NSArray<HAJSONModel*>* subItems;

- (void)addSubItem:(HAJSONModel*)item;

@end
