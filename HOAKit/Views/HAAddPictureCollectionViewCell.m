//
//  HAAddPictureCollectionViewCell.m
//  HOAKit
//
//  Created by birneysky on 16/8/9.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAAddPictureCollectionViewCell.h"
//#import "SDProgressView.h"
#import "EVCircularProgressView.h"

@interface HAAddPictureCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet EVCircularProgressView *progressView;  //SDBallProgressView
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;

@end

@implementation HAAddPictureCollectionViewCell


- (void)awakeFromNib
{
    [self.progressView startIndeterminateAnimation];
}


- (void)setEdited:(BOOL)edited
{
    _edited = edited;
    self.deleteButton.hidden = !_edited;
    self.topButton.hidden = !_edited;
}

#pragma mark - ***Target Action ***
- (IBAction)deleteButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteItemFromCell:)]) {
        [self.delegate deleteItemFromCell:self];
    }
}

- (IBAction)topButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(placeOnTopItemFromCell:)]) {
        [self.delegate placeOnTopItemFromCell:self];
    }
}
#pragma mark - *** Api ***
- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (void)setUploadProgress:(double)uploadProgress
{
    self.progressView.progress = uploadProgress;
}

- (void) showProgressView
{
    if (self.progressView.hidden) {
        self.progressView.hidden = NO;
    }
}

- (void) hideProgressView
{
    if(!self.progressView.hidden)
    self.progressView.hidden = YES;
}

- (void) showErrorImage
{
    self.imageView.image = [UIImage imageNamed:@"HOAKit.bundle/HA_Download_Failed"];
    [self.progressView reset];
}

- (void)setMainImageIconHidden:(BOOL)mainImageIconHidden
{
    self.mainImage.hidden = mainImageIconHidden;
}

@end
