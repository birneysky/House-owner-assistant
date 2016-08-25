//
//  HAHouseTypeDataSouceDelegate.h
//  HOAKit
//
//  Created by zhangguang on 16/8/8.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAEditPickerDataSourceDelegate.h"

@protocol HAHouseTypeSelectDetailResult <NSObject>

- (void) didSelectRoom:(NSInteger)rNum hall:(NSInteger)hallNum cookroom:(NSInteger)cookNum balcony:(NSInteger)bNum;

@end


@interface HAHouseTypeDataSouceDelegate : HAEditPickerDataSourceDelegate

@property (nonatomic,weak) id<HAHouseTypeSelectDetailResult> detailResultDelegate;

@end
