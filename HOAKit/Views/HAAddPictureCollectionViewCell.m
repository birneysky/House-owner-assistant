//
//  HAAddPictureCollectionViewCell.m
//  HOAKit
//
//  Created by birneysky on 16/8/9.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAAddPictureCollectionViewCell.h"

@interface HAAddPictureCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@end

@implementation HAAddPictureCollectionViewCell

- (void)setEdited:(BOOL)edited
{
    _edited = edited;
    self.deleteButton.hidden = !_edited;
}

#pragma mark - ***Target Action ***
- (IBAction)deleteButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteItemFromCell:)]) {
        [self.delegate deleteItemFromCell:self];
    }
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

@end
