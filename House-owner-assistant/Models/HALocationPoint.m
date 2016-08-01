//
//  HALocationPoint.m
//  House-owner-assistant
//
//  Created by zhangguang on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "HALocationPoint.h"

@implementation HALocationPoint


-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init]) {
        _coordinate = coordinate;
    }
    return self;
}

@end
