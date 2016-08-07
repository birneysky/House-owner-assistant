//
//  HAEditHouseBenViewController.h
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HABed;

@protocol HAEditHouseBenViewControllerDelegate <NSObject>

- (void)houseBedInfoDidEndEditing:(HABed*)bed;

@end

@interface HAEditHouseBenViewController : UITableViewController

@property(nonatomic,weak) id<HAEditHouseBenViewControllerDelegate> delegate;

@property(nonatomic,strong) HABed* bed;

@end
