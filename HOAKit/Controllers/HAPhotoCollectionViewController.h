//
//  HAPhotoCollectionViewController.h
//  HOAKit
//
//  Created by birneysky on 16/8/8.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HAPhotoCollectionViewController : UICollectionViewController

@property(nonatomic,assign) BOOL edited;

@property (nonatomic,strong) NSArray* datasource;

@end
