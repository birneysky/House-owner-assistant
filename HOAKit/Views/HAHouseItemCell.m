//
//  HAHouseItemCell.m
//  HOAKit
//
//  Created by birneysky on 16/8/14.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseItemCell.h"

@interface HAHouseItemCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *rentTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *houseImageView;
@end

@implementation HAHouseItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)commentsBtnClicked:(id)sender {
}


- (IBAction)priceBtnClicked:(id)sender {
}


- (void)setAddress:(NSString*)text
{
    self.addressLabel.text = text;
}

- (void)setCheckStatus:(NSInteger)status
{
    
}

- (void)setPrice:(float)price
{
    NSString* priceString = [NSString stringWithFormat:@"%.1f",price];
    self.priceLabel.text = priceString;
}

- (void)setRentType:(NSInteger)type roomCount:(NSInteger)count
{
    switch (type) {
        case 1:
            
            break;
            
        default:
            break;
    }
}

@end
