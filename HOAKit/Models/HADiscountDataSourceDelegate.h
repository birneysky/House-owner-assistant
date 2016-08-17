//
//  HADiscountDataSourceDelegate.h
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAEditPickerDataSourceDelegate.h"

@protocol HADiscountSelectDetailResult <NSObject>

- (void) didSelectDiscount:(float)value;

@end

@interface HADiscountDataSourceDelegate : HAEditPickerDataSourceDelegate <UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic,weak) id<HADiscountSelectDetailResult> detailResultDelegate;

@end
