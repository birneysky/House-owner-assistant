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
#import "HAPhotoCollectionViewController.h"
#import "HARESTfulEngine.h"
#import "HAPhotoItem.h"


@interface HAAddHousePhotoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet HAPhotoCollectionViewController *photoCollectionViewController;
@property (nonatomic,strong) NSMutableArray* selectedPhotoPathes;

@property (nonatomic,strong) NSMutableDictionary* netOperationDic;

@property (nonatomic,strong) NSMutableArray <HAHouseImage*>* photosArray;

@end


NSString* gen_uuid()
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    
    CFRelease(uuid_string_ref);
    
    return uuid;
    
}

@implementation HAAddHousePhotoViewController


- (NSMutableArray*) selectedPhotoPathes
{
    if (!_selectedPhotoPathes) {
        _selectedPhotoPathes = [[NSMutableArray alloc] init];
    }
    return _selectedPhotoPathes;
}

- (NSMutableDictionary*)netOperationDic
{
    if (!_netOperationDic) {
        _netOperationDic = [[NSMutableDictionary alloc] init];
    }
    return _netOperationDic;
}

- (NSMutableArray*) photosArray
{
    if (!_photosArray) {
        _photosArray = [[NSMutableArray alloc] init];
    }
    return _photosArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    // Do any additional setup after loading the view.
    self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.photoCollectionViewController.datasource = self.selectedPhotoPathes;
    //NSInteger count = self.photoCollectionViewController.datasource.count;
    
    if (self.photoes.count > 0) {
        [self.photosArray addObjectsFromArray:self.photoes];
    }
    NSString* basePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImagesNet"];
    //检测图片是否存在
    [self.photosArray enumerateObjectsUsingBlock:^(HAHouseImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HAPhotoItem* item = [[HAPhotoItem alloc] init];
        item.imageId = obj.imageId;
        NSString* path = [basePath stringByAppendingPathComponent:[obj.imagePath lastPathComponent]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            obj.localPath = path;
            item.path = path;
        }
        [self.selectedPhotoPathes addObject:item];
    }];
    
    [self.collectionView reloadData];
    //检测图片在不在，不在开始下载，暂时先直接开下
    
    [self.photosArray enumerateObjectsUsingBlock:^(HAHouseImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //NSLog(@"imagePath %@",obj.imagePath);
        if(obj.localPath.length <= 0){
//            MKNetworkOperation* op = [[HARESTfulEngine defaultEngine] downloadHouseImageWithPath:obj.imagePath completion:^(NSString *certificate, NSString *fileName) {
//                NSInteger index = [self.netOperationDic[certificate] integerValue];
//                HAPhotoItem* item = self.selectedPhotoPathes[index];
//                item.path = [basePath stringByAppendingPathComponent:fileName];
//                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
//                
//            } progress:^(NSString *certificate, float progress) {
//                NSInteger index = [self.netOperationDic[certificate] integerValue];
//                HAPhotoItem* item = self.selectedPhotoPathes[index];
//                item.progress = progress;
//                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
//            } onError:^(NSError *engineError) {
//                
//            }];
//            
//            [self.netOperationDic setObject:@(idx) forKey:op.clientCertificate];
        }

    }];
    

}

- (void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];

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

- (void)showActionSheet
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil)  destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照", nil),NSLocalizedString(@"选择照片", nil), nil];
    [sheet showInView:self.view];
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
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        //[self.collectionView reloadData];
        
    }];
    
    NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImages"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager]  createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (ALAsset * asset in assets)
        {
            CGImageRef fullimg = [[asset defaultRepresentation] fullScreenImage];
            CGImageRef thumbnailImg = asset.aspectRatioThumbnail;
            NSString * fileID = gen_uuid();
            const char* guid = [fileID cStringUsingEncoding:NSUTF8StringEncoding];
            
            NSData * pngData = UIImagePNGRepresentation([UIImage imageWithCGImage:fullimg]);
            NSData* thumbnailData = UIImagePNGRepresentation([UIImage imageWithCGImage:thumbnailImg]);
            NSData* thumbnailJPGData = UIImageJPEGRepresentation([UIImage imageWithCGImage:thumbnailImg], 1);
            
            
            NSString* fullImgfilePath = [filePath stringByAppendingPathComponent:fileID];
            NSString* fileThumbnailName = [NSString stringWithFormat:@"%@_%@.jpg",fileID,@"thumbnail"];
            NSString* thumbnailImgPath = [filePath stringByAppendingPathComponent:fileThumbnailName];
            HAPhotoItem* allocItem = [[HAPhotoItem alloc] init];
            allocItem.path = thumbnailImgPath;
            allocItem.progress = 0;
            [self.selectedPhotoPathes addObject:allocItem];
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            [pngData writeToFile:fullImgfilePath atomically:YES];
            [thumbnailJPGData writeToFile:thumbnailImgPath atomically:YES];
            
            
            [self.collectionView reloadData];
            
            MKNetworkOperation* op = [[HARESTfulEngine defaultEngine] uploadHouseImageWithPath:thumbnailImgPath completion:^(HAHouseImage *obj) {
                obj.userId = self.house.landlordId;
                obj.houseId = self.house.houseId;
                [self.photosArray addObject:obj];
            } progress:^(NSString *certificate, float progress) {
                NSInteger index = [self.netOperationDic[certificate] integerValue];
                HAPhotoItem* item = self.selectedPhotoPathes[index];
                item.progress = progress;
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
            } onError:^(NSError *engineError) {
                
            }];
//            MKNetworkOperation* op = [[HARESTfulEngine defaultEngine] uploadHouseImageWithPath:thumbnailImgPath completion:(void (^)(HAHouseImage* obj)){
//                
//            } progress:^(NSString* certificate, float progress) {
//                NSInteger index = [self.netOperationDic[certificate] integerValue];
//                HAPhotoItem* item = self.selectedPhotoPathes[index];
//                item.progress = progress;
//                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
//            }];
            //NSLog(@"key %@",op.clientCertificate);
            [self.netOperationDic setObject:@(self.selectedPhotoPathes.count-1) forKey:op.clientCertificate];
            //});
            
        }
        
        
 

    });

    



}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

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

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL lastOneFlag = indexPath.row == 9;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lastOneFlag ? @"HAAddPictureCell" : @"HAPictureCell" forIndexPath:indexPath];
    
    // Configure the cell
    UIView* selectBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    selectBackgroundView.backgroundColor = [UIColor redColor];
    cell.selectedBackgroundView = selectBackgroundView;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}



// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
     BOOL lastOneFlag = indexPath.row == 9;
    if (lastOneFlag) {
        [self showActionSheet];
    }
}

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

#pragma mark - *** Target Action ***
- (IBAction)addPhotoBtnClicked:(id)sender {
    [self showActionSheet];
}

- (IBAction)saveBtnClicked:(id)sender {
    if (self.photosArray.count <= 0) {
        return;
    }
    [[HARESTfulEngine defaultEngine] relationshipBetweenHousesAndPictures:([self.photosArray copy]) completion:^{
        [self.navigationController popViewControllerAnimated:YES];
        NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImages"];
        NSError* error;
        [[NSFileManager defaultManager]  removeItemAtPath:filePath error:&error];
        [self.delegate imagesOfHouseDidChange:[self.photosArray copy]];
    } onError:^(NSError *engineError) {
        
    }];
}
#pragma mark - *** Target Action***
- (IBAction)editButtonClicked:(UIBarButtonItem*)sender {
    //[self.collectionView ];
    if ([sender.title isEqualToString:@"编辑"]) {
        sender.title = @"取消";
        self.photoCollectionViewController.edited = YES;
    }
    else{
        sender.title = @"编辑";
        self.photoCollectionViewController.edited = NO;
    }
    
    NSArray* array = [self.collectionView indexPathsForVisibleItems];
    //NSArray* arrayCell = [self.collectionView visibleCells];

    [self.collectionView reloadItemsAtIndexPaths:array];//
    
    
    //self.collectionView.indexPathsForVisibleItems;
//     [self.photoCollectionViewController.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    //[self.collectionView reloadData];
}

@end
