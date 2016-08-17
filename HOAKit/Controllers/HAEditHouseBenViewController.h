//
//  HAEditHouseBenViewController.h
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HAHouseBed;

@protocol HAEditHouseBenViewControllerDelegate <NSObject>

- (void)houseBedInfoDidEndEditing:(HAHouseBed*)bed;

@end

@interface HAEditHouseBenViewController : UITableViewController

@property(nonatomic,weak) id<HAEditHouseBenViewControllerDelegate> delegate;

@property(nonatomic,strong) HAHouseBed* bed;

@property (nonatomic,assign) NSInteger houseId;

@end
