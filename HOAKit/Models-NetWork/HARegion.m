//
//  HAArea.m
//  HOAKit
//
//  Created by zhangguang on 16/8/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HARegion.h"

@interface HARegion ()

@property (nonatomic,strong) NSMutableArray<HAJSONModel*>* items;

@property (nonatomic,copy) NSString* name;

@end



@implementation HARegion


- (instancetype) initWithName:(NSString*)name
{
    if (self = [super init]) {
        self.name = name;
    }
    return self;
}

- (NSMutableArray<HAJSONModel*>*) items
{
    if (!_items) {
        _items = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _items;
}


- (void)addSubItem:(HAJSONModel *)item
{
    [self.items addObject:item];
}

- (NSArray<HAJSONModel*>*) subItems
{
    return [self.items copy];
}

@end
