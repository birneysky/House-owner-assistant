//
//  BedInfoCell.m
//  HOAKit
//
//  Created by zhangguang on 16/8/8.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HABedInfoCell.h"

@interface HABedInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeLable;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@end

@implementation HABedInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteButtonClickedFromCell:sender:)]) {
        [self.delegate deleteButtonClickedFromCell:self sender:sender];
    }
}


- (void)setTypeText:(NSString *)typeText
{
    _typeText = [typeText copy];
    self.typeLable.text = _typeText;
}

- (void)setSizeText:(NSString *)sizeText
{
    _sizeText = [sizeText copy];
    self.sizeLabel.text = _sizeText;
}

@end
