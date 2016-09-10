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

@protocol HOAKitDelegate <NSObject>

@optional

/*
 *  查看房屋评论代理方法
 *  @param houseId  房源id
 */

- (void)reviewHouseCommentsOfHouseId:(NSInteger)houseId;

/*
 *  预览房屋信息代理方法
 *  @param houseId  房源id
 */

- (void)previewHouseInformationOfHouseId:(NSInteger)houseId;

@end


@interface HOAKit : NSObject

+ (HOAKit*)defaultInstance;

/*
 *  @property userId  房主用户id
 */

@property (nonatomic, assign)   NSInteger userId;


/*
 *  @property token  访问令牌
 */

@property (nonatomic, copy)     NSString* token;


/*
 *  @property delegate  HOAKit实例的代理
 */

@property (nonatomic, weak)    id<HOAKitDelegate> delegate;


/*
 *  @property delegate  HOAKit实例的根视图控制器
 */

@property (nonatomic, readonly) UINavigationController* rootViewController;


@end
