//
//  HARESTfulOperation.m
//  HOAKit
//
//  Created by birneysky on 16/8/14.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HARESTfulOperation.h"

#define kRequestErrorDomain @"HTTP_ERROR"
#define kBusinessErrorDomain @"BIZ_ERROR"

@implementation HARESTfulOperation

- (void)operationSucceeded
{
    // even when request completes without a HTTP Status code, it might be a benign error
    
    NSMutableDictionary *errorDict = [[self responseJSON] objectForKey:@"error"];
    
    if(errorDict)
    {
        self.restError = [[NSError alloc] initWithDomain:kBusinessErrorDomain
                                                      code:[[errorDict objectForKey:@"code"] intValue]
                                                  userInfo:errorDict];
        [super operationFailedWithError:self.restError];
    }
    else
    {
        [super operationSucceeded];
    }
}

-(void) operationFailedWithError:(NSError *)theError
{
    NSMutableDictionary *errorDict = [[self responseJSON] objectForKey:@"error"];
    
    if(errorDict == nil)
    {
        self.restError = [[NSError alloc] initWithDomain:kRequestErrorDomain
                                                      code:[theError code]
                                                  userInfo:[theError userInfo]];
    }
    else
    {
        self.restError = [[NSError alloc] initWithDomain:kBusinessErrorDomain
                                                      code:[[errorDict objectForKey:@"code"] intValue]
                                                  userInfo:errorDict];
    }
    
    [super operationFailedWithError:theError];
}

@end
