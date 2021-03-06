//
//  HAAddPictureCollectionViewCell.h
//  HOAKit
//
//  Created by birneysky on 16/8/9.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HAAddPictureCollectionViewCellDelegate <NSObject>

@optional
- (void)deleteItemFromCell:(UICollectionViewCell*)cell;

- (void)placeOnTopItemFromCell:(UICollectionViewCell*)cell;

@end

@interface HAAddPictureCollectionViewCell : UICollectionViewCell

@property(nonatomic,weak) id<HAAddPictureCollectionViewCellDelegate> delegate;

@property (nonatomic,assign) BOOL edited;

@property (nonatomic,strong) UIImage* image;

@property (nonatomic,assign) double uploadProgress;

@property (nonatomic,assign) BOOL mainImageIconHidden;


- (void) showProgressView;

- (void) hideProgressView;

- (void) showErrorImage;

@end
