//
//  HAHouseInfoCell.m
//  HOAKit
//
//  Created by birneysky on 16/9/23.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseInfoCell.h"

@interface HAHouseInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *accessoryLabel;

@end

@implementation HAHouseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setStatusText:(NSString *)statusText
{
    self.accessoryLabel.text = statusText;
}

@end
