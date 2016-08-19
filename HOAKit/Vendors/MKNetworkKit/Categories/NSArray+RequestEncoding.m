//
//  NSArray+RequestEncoding.m
//  HOAKit
//
//  Created by zhangguang on 16/8/19.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "MKNetworkKit.h"

@implementation NSArray (RequestEncoding)

-(NSString*) jsonEncodedKeyValueString
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:0 // non-pretty printing
                                                     error:&error];
    if(error)
        DLog(@"JSON Parsing Error: %@", error);
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
