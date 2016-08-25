//
//  HABathroomDataSourceDelegate.h
//  HOAKit
//
//  Created by zhangguang on 16/8/8.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAEditPickerDataSourceDelegate.h"


@protocol HAHouseBathrommSelectDetailResult <NSObject>

- (void) didSelectPublicBathroom:(NSInteger) pubNum privateBathroom:(NSInteger)privateNum;

@end

@interface HABathroomDataSourceDelegate : HAEditPickerDataSourceDelegate

@property(nonatomic,weak) id<HAHouseBathrommSelectDetailResult> detailResultDelegate;

@end
