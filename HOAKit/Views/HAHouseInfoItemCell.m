//
//  HAHouseInfoItem.m
//  HOAKit
//
//  Created by birneysky on 16/8/23.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseInfoItemCell.h"

@implementation HAHouseInfoItemCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)commentsBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(changePriceButtonClickedOfCell:)]) {
        [self.delegate changePriceButtonClickedOfCell:self];
    }
}


- (IBAction)priceBtnClicked:(id)sender {
    
}

@end
