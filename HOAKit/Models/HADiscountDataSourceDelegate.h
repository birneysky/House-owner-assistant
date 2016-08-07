//
//  HADiscountDataSourceDelegate.h
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewDidSelectResultDelegate;

@interface HADiscountDataSourceDelegate : NSObject <UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,weak) id<PickerViewDidSelectResultDelegate> resultDelegate;

@end
