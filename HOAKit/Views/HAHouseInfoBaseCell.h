//
//  HAHouseItemCell.h
//  HOAKit
//
//  Created by birneysky on 16/8/14.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HAHouseInfoBaseCell : UITableViewCell

- (void)setAddress:(NSString*)text;

- (void)setCheckText:(NSString*)text;

- (void)setPrice:(float)price;

- (void)setHeadImage:(UIImage*)image;

- (void)setHouseType:(NSInteger)type roomCount:(NSInteger)count;

@end
