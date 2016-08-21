//
//  HAPhotoCollectionViewController.m
//  HOAKit
//
//  Created by birneysky on 16/8/8.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAPhotoCollectionViewController.h"
#import "HAAddPictureCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HAPhotoItem.h"

@interface HAPhotoCollectionViewController ()<HAAddPictureCollectionViewCellDelegate>


@end

@implementation HAPhotoCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //BOOL lastOneFlag = indexPath.row == 9;
    HAAddPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HAAddPictureCell" forIndexPath:indexPath];
    // Configure the cell
    HAPhotoItem* item = self.datasource[indexPath.row];
    UIView* selectBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    selectBackgroundView.backgroundColor = [UIColor redColor];
 
    cell.image = [UIImage imageWithContentsOfFile:item.path];
    cell.selectedBackgroundView = selectBackgroundView;
    cell.edited = self.edited ? YES : NO;
    cell.delegate = self;
    cell.uploadProgress = item.progress;
    return cell;
}

#pragma mark - *** ***

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*)collectionViewLayout;
    CGRect rect = [UIScreen mainScreen].bounds;
    if (0 == indexPath.row) {
        CGFloat width = rect.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right;
       return  CGSizeMake(width, width * 0.75);
    }
    else{
        CGFloat width = (rect.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumLineSpacing * 2) / 3;
        return CGSizeMake(width, width * 0.75);
    }
    
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (void)setDatasource:(NSArray *)datasource
{
    _datasource = datasource;
}

@end
