//
//  HABedTypeDataSourceDelegate.h
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAEditPickerDataSourceDelegate.h"


@protocol HAHouseBedTypeSelectDetailResult <NSObject>

- (void) didSelectBedType:(NSInteger)type;

@end

@interface HABedTypeDataSourceDelegate : HAEditPickerDataSourceDelegate

@property (nonatomic,weak) id<HAHouseBedTypeSelectDetailResult> detailResultDelegate;

@end
