//
//  HAAppDataHelper.h
//  HOAKit
//
//  Created by zhangguang on 16/8/15.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAAppDataHelper : NSObject

+ (NSString*)rentTypeName:(NSInteger)type;

+ (NSString*)houseTypeName:(NSInteger)type;

+ (NSString*)checkStatusText:(NSInteger)status;

+ (NSString*)bedName:(NSInteger)type;

+ (NSInteger)typeForBedName:(NSString*)name;

@end
