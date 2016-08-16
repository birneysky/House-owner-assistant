//
//  HAHousePosition.h
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAJSONModel.h"

@interface HAHousePosition : HAJSONModel

@property(nonatomic,assign) NSInteger uniqueId;		// '记录唯一标识',
@property(nonatomic,assign) NSInteger houseId;		// '房屋唯一标识ID',
@property(nonatomic,assign) NSInteger positionId;		// '景点唯一ID',
@property(nonatomic,assign) NSInteger positionTypeId;		// '景点类型ID',

@end

/*
 

 */
