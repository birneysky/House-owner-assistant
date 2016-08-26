//
//  HASelectHousePositionViewController.h
//  HOAKit
//
//  Created by zhangguang on 16/8/26.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAGeneralPosition.h"

@protocol HASelectHousePositionDelegate <NSObject>

- (void)didSelectHousePosition:(id<HAGeneralPosition>)position;

- (void)clearSelectPostions;

@end


@interface HASelectHousePositionViewController : UIViewController

- (instancetype) initWithCityID:(NSInteger)cityID;

@property (nonatomic,assign) NSInteger positionTypeSelected;

@property (nonatomic,assign) NSInteger positionIdSelected;

@property (nonatomic,assign) NSInteger cityId;

@property (nonatomic,weak) id<HASelectHousePositionDelegate> delegate;

@end
