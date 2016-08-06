//
//  ProvinceDataSourceDelegate.h
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HAProvinceDataSourceDelegate : NSObject <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,readonly) NSDictionary* dataSource;

@end
