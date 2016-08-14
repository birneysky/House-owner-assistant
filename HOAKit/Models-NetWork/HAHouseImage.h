//
//  HAHouseImage.h
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAJSONModel.h"

@interface HAHouseImage : HAJSONModel

@property(nonatomic,assign) NSInteger imageId;
@property(nonatomic,assign) NSInteger houseId;
@property(nonatomic,copy)   NSString* imagePath;

@end
