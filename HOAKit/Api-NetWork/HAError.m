//
//  HAError.m
//  HOAKit
//
//  Created by zhangguang on 16/8/17.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAError.h"

@interface HAError ()

@property(nonatomic,assign) NSInteger errorCode;
@property (nonatomic,copy) NSString* reson;

@end

@implementation HAError

- (instancetype)initWithCode:(NSInteger)code reason:(NSString*)text;
{
    if (self = [super init]) {
        self.errorCode = code;
        self.reson = text;
    }
    return self;
}

- (NSString*) localizedDescription
{
    return self.reson;
}

- (NSInteger)code{
    return self.errorCode;
}

@end
