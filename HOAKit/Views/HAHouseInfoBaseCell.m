//
//  HAHouseItemCell.m
//  HOAKit
//
//  Created by birneysky on 16/8/14.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseInfoBaseCell.h"
#import "HAAppDataHelper.h"

@interface HAHouseInfoBaseCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *rentTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *houseImageView;
@end

@implementation HAHouseInfoBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (void)setAddress:(NSString*)text
{
    self.addressLabel.text = text;
    
}

- (void)setCheckText:(NSString*)text;
{
    self.checkStatusLabel.text = text;
}

- (void)setPrice:(float)price
{
    NSString* priceString = [NSString stringWithFormat:@"¥ %.1f",price];
    self.priceLabel.text = priceString;
}

- (void)setHeadImage:(UIImage*)image
{
    self.houseImageView.image = image;
}

- (void)setHouseType:(NSInteger)type roomCount:(NSInteger)count;
{
    NSString* typeName = [HAAppDataHelper houseTypeName:type];
    self.rentTypeLabel.text = [NSString stringWithFormat:@"%@%ld居",typeName,(long)count];
}

@end
