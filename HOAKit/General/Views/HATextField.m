//
//  HATextField.m
//  HOAKit
//
//  Created by zhangguang on 16/8/11.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HATextField.h"

@implementation HATextField


- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 30, bounds.size.height);
    
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 30, bounds.size.height);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 30, bounds.size.height);
}


@end
