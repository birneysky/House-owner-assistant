//
//  HAError.h
//  HOAKit
//
//  Created by zhangguang on 16/8/17.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAError : NSError

- (instancetype)initWithCode:(NSInteger)code reason:(NSString*)text;

- (NSString*) localizedDescription;

@end
