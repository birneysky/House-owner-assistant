//
//  HAEditPickerDataSourceDelegate.h
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAEditPickerDelegate.h"

@interface HAEditPickerDataSourceDelegate : NSObject

@property(nonatomic,weak) id<HAEditPickerDelegate> resultDelegate;

@property(nonatomic,readonly) NSString* selectResult;

@end
