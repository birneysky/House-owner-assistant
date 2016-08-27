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

@end

@implementation HAAddPictureCollectionViewCell

//- (EVCircularProgressView*) progressViewTest
//{
//    if (!_progressViewTest) {
//        _progressViewTest = [[EVCircularProgressView alloc] init];
//    }
//    return _progressViewTest;
//}

- (void)awakeFromNib
{
    [self.progressView startIndeterminateAnimation];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.progressViewTest.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
//}

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

- (void)setUploadProgress:(double)uploadProgress
{
    //if (!self.progressView.hidden){
        self.progressView.progress = uploadProgress;
    //}
    

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
    //[self.progressViewTest removeFromSuperview];
}

- (void) showErrorImage
{
    self.imageView.image = [UIImage imageNamed:@"HOAKit.bundle/HA_Download_Failed"];
    [self.progressView reset];
}

@end
