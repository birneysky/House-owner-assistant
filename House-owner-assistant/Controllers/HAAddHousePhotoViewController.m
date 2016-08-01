//
//  HAAddHousePhotoViewController.m
//  House-owner-assistant
//
//  Created by birneysky on 16/7/30.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "HAAddHousePhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CTAssetsPickerController.h"
#import <HOAKit/TestViewController.h>

@interface HAAddHousePhotoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation HAAddHousePhotoViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil)  destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照", nil),NSLocalizedString(@"从相册选择", nil), nil];
    [sheet showInView:self.view];

}

#pragma mark - *** camera  helper***

- (void) showAssetsPickerController
{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.assetsFilter         = [ALAssetsFilter allPhotos];
    picker.showsCancelButton    = YES;
    picker.delegate             = self;
    picker.selectedAssets       = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) showImagePickerController
{
    UIImagePickerController* imagepicker = [[UIImagePickerController alloc] init];
    imagepicker.delegate = self;
    imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    [self presentViewController:imagepicker animated:YES completion:^{
    }];
}

- (void)requestAccessCamera
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                //第一次用户接受
                [self showImagePickerController];
            }else{
                //string:UIApplicationOpenSettingsURLString
                UIAlertView * alart = [[UIAlertView alloc] initWithTitle:nil message:@"请您设置允许APP访问您的相机\n设置>隐私>相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alart show];
            }
        });
    }];
}


- (void)cameraAuthorization
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            NSLog(@"camera is Determined");
            [self requestAccessCamera];
            break;
        case AVAuthorizationStatusAuthorized:
            NSLog(@"camera is Authorized");
            [self showImagePickerController];
            break;
        case AVAuthorizationStatusDenied:
            NSLog(@"camera is denied");
             [self requestAccessCamera];
            break;
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}

#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self cameraAuthorization];
            break;
        case 1:
            [self showAssetsPickerController];
            break;
        case 2:
            return;
        default:
            break;
    }
}

#pragma mark - *** CTAssetsPickerControllerDelegate ***

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
//    [FileTransManager sendPhotoes:assets toGroupWithType:self.groupType ID:self.groupID remoteUserID:self.remoteUserID];
//    
//    if (self.popover) {
//        [self.popover dismissPopoverAnimated:YES];
//    }else {
        [picker dismissViewControllerAnimated:YES completion:nil];
//    }
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //[picker dismissViewControllerAnimated:YES completion:nil];
    
    CGRect rect = [[picker valueForKey:@"_cropRect"] CGRectValue];
    NSLog(@" _cropRect = %@",NSStringFromCGRect(rect));
    
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
//    ClipImageViewController* clipImgVC = [[ClipImageViewController alloc] initWithImage:image sourceType:picker.sourceType];
//    clipImgVC.delegate = self;
//    [picker pushViewController:clipImgVC animated:YES];
//    [clipImgVC release];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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

    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
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

#pragma mark - *** Test HOAKit ***

- (IBAction)test:(id)sender {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"test" bundle:nil];
    TestViewController* nav = [sb instantiateViewControllerWithIdentifier:@"test_contoller"];
    [self presentViewController:nav animated:YES completion:nil];

}

@end
