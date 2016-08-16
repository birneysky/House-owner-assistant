//
//  HAArea.m
//  HOAKit
//
//  Created by zhangguang on 16/8/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HARegion.h"
#import "HASubWay.h"

@interface HARegion ()

@property (nonatomic,strong) NSMutableArray<HAJSONModel*>* items;

@property (nonatomic,copy) NSString* name;


@property (nonatomic,strong) NSMutableDictionary<NSString*,NSNumber*>* indexDic;

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


- (NSMutableDictionary<NSString*,NSNumber*>*) indexDic
{
    if (!_indexDic) {
        _indexDic = [[NSMutableDictionary alloc] init];
    }
    return _indexDic;
}

- (void)addSubItem:(HAJSONModel *)item
{
    if([item respondsToSelector:@selector(subwayId)])
    {
        [self.indexDic setObject:@(self.items.count) forKey:[NSString stringWithFormat:@"%d",[(HASubWay*)item subwayId]]];
    }
    
    [self.items addObject:item];
}

- (NSArray<HAJSONModel*>*) subItems
{
    return [self.items copy];
}

- (HAJSONModel*)subItemWithID:(NSInteger)Id
{
    NSString* strId = [NSString stringWithFormat:@"%d",Id];
    NSNumber* index = self.indexDic[strId];
    
    if (index) {
        return self.items[[index integerValue]];
    }
    return nil;
}

@end
