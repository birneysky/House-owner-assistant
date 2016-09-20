//
//  HAImagePictureCell.h
//  HOAKit
//
//  Created by zhangguang on 16/9/20.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HAImagePictureCellDelegate <NSObject>

@optional
- (void)deleteItemFromCell:(UICollectionViewCell*)cell;

- (void)placeOnTopItemFromCell:(UICollectionViewCell*)cell;

@end

@interface HAImagePictureCell : UICollectionViewCell

@property(nonatomic,weak) id<HAImagePictureCellDelegate> delegate;

@property (nonatomic,assign) BOOL edited;

@property (nonatomic,strong) UIImage* image;

@property (nonatomic,assign) double uploadProgress;

@property (nonatomic,assign) BOOL mainImageIconHidden;


- (void) showProgressView;

- (void) hideProgressView;

- (void) showErrorImage;

@end
