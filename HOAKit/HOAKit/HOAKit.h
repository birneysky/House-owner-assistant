//
//  HOAKit.h
//  HOAKit
//
//  Created by birneysky on 16/8/1.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HASelectHousePositionViewController.h"

//! Project version number for HOAKit.
FOUNDATION_EXPORT double HOAKitVersionNumber;

//! Project version string for HOAKit.
FOUNDATION_EXPORT const unsigned char HOAKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <HOAKit/PublicHeader.h>

@interface HOAKit : NSObject

+ (HOAKit*)defaultInstance;

@property (nonatomic, assign)   NSInteger userId;

@property (nonatomic, copy)     NSString* token;

@property (nonatomic, readonly) UINavigationController* rootViewController;


@end
