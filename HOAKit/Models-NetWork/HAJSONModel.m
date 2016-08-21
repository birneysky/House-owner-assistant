//
//  JSONModel.m
//  HOAKit
//
//  Created by birneysky on 16/8/13.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAJSONModel.h"
#import <objc/runtime.h>

@implementation HAJSONModel

- (instancetype) initWithDictionary:(NSDictionary*)jsonDic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:jsonDic];
    }
    return self;
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"Undefine Key %@",key);
}

- (NSString*) toJsonString{
    NSData* data = [self toJsonData];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString*) toFullJsonString
{
    NSData* data = [self toFullJsonData];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


- (NSDictionary*) toDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([key isEqualToString:@"description"]) {
            continue;
        }
        id value = [self valueForKey:key];
        if ( [value isKindOfClass:[NSNumber class]]) {
            NSInteger num = [value integerValue];
            if (num != 0) {
                [dict setObject:value forKey:key];
            }
            
        }
        else if (value) {
            [dict setObject:value forKey:key];
        }
    }
    
    free(properties);
    return [dict copy];
}

- (NSDictionary*) toFullDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([key isEqualToString:@"description"]) {
            continue;
        }
        id value = [self valueForKey:key];
        if (value) {
            [dict setObject:value forKey:key];
        }
        else{
            [dict setObject:[NSNull null] forKey:key];
        }
        
    }
    
    free(properties);
    return [dict copy];
}


- (NSData*) toJsonData
{

    NSDictionary* dict = [self toDictionary];
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict  options:NSJSONWritingPrettyPrinted error:&error];
    return data;
}

- (NSData*) toFullJsonData
{
    NSDictionary* dict = [self toFullDictionary];
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict  options:NSJSONWritingPrettyPrinted error:&error];
    return data;
}

@end
