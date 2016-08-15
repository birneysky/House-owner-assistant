//
//  HAHouseItemCell.h
//  HOAKit
//
//  Created by birneysky on 16/8/14.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HAHouseItemCell : UITableViewCell

- (void)setAddress:(NSString*)text;

- (void)setCheckStatus:(NSInteger)status;

- (void)setPrice:(float)price;

- (void)setHouseType:(NSInteger)type roomCount:(NSInteger)count;

@end
