//
//  HAImagePictureCell.m
//  HOAKit
//
//  Created by zhangguang on 16/9/20.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAImagePictureCell.h"


#import "EVCircularProgressView.h"

@interface HAImagePictureCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet EVCircularProgressView *progressView;  //SDBallProgressView
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;

@end

@implementation HAImagePictureCell

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    [self.progressView startIndeterminateAnimation];
//}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)configureUI{
    
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
        [self.progressView startIndeterminateAnimation];
        self.progressView.hidden = NO;
    }
}

- (void) hideProgressView
{
    if(!self.progressView.hidden){
        self.progressView.hidden = YES;
        [self.progressView stopIndeterminateAnimation];
        [self.progressView reset];
    }
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
