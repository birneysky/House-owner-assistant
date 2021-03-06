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
#import "HARESTfulEngine.h"
//#import "HAPhotoItem.h"
#import "HAAddPictureCollectionViewCell.h"
#import "HAActiveWheel.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"

#define PHOTO_COUNT_MAX 20

@interface HAAddHousePhotoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,HAAddPictureCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic,strong) NSMutableArray* selectedPhotoPathes;

@property (nonatomic,strong) NSMutableDictionary* netOperationDic;

@property (nonatomic,strong) NSMutableArray <HAHouseImage*>* photosArray;

@property (nonatomic,assign) BOOL edited;

@property (nonatomic,strong) dispatch_queue_t uploadQueue;

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

static NSString * const reuseIdentifier = @"HAAddPictureCell";

static  HAAddHousePhotoViewController* strongSelf = nil;

@implementation HAAddHousePhotoViewController

- (void)dealloc
{
    NSLog(@"HAAddHousePhotoViewController dealloc ~");
}
#pragma mark - *** Properties ***
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

- (NSMutableArray <HAHouseImage*>*) photosArray
{
    if (!_photosArray) {
        _photosArray = [[NSMutableArray alloc] init];
    }
    return _photosArray;
}

- (dispatch_queue_t) uploadQueue
{
    if (!_uploadQueue) {
        _uploadQueue = dispatch_queue_create("com.upload.file", DISPATCH_QUEUE_SERIAL);
    }
    return _uploadQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    // Do any additional setup after loading the view.
//   [self.collectionView registerClass:[HAAddPictureCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"HOAKit" ofType:@"bundle"];
//    NSBundle* hoaKitBundle = [NSBundle bundleWithPath:path];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"AddPictureCell" bundle:hoaKitBundle] forCellWithReuseIdentifier:reuseIdentifier];
    if (self.photoes.count > 0) {
        [self.photosArray addObjectsFromArray:self.photoes];
    }
    NSString* basePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImagesNet"];
    //检测图片是否存在
    __weak HAAddHousePhotoViewController* weakSelf = self;
    [self.photosArray enumerateObjectsUsingBlock:^(HAHouseImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.loadType = HAPhotoLoadTypeDownload;
        
        NSString* path = [basePath stringByAppendingPathComponent:[obj.imagePath lastPathComponent]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path] && HAPhotoUploadOrDownloadStateUnknown == obj.stauts) {
            obj.localPath = path;
            obj.stauts = HAPhotoUploadOrDownloadStateDownloaded;
        }
    }];
    
    [self.collectionView reloadData];
    //检测图片在不在，不在开始下载，暂时先直接开下
    __block NSInteger downloadedCount = 0;
    
    [self.photosArray enumerateObjectsUsingBlock:^(HAHouseImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.localPath.length <= 0 && HAPhotoUploadOrDownloadStateUnknown == obj.stauts){
            downloadedCount ++;
            strongSelf = weakSelf;
            MKNetworkOperation* op = [[HARESTfulEngine defaultEngine] downloadHouseImageWithURL:obj.imagePath storagePath:basePath completion:^(NSString *certificate, NSString *fileName) {
                NSInteger index = [weakSelf.netOperationDic[certificate] integerValue];
                obj.localPath = [basePath stringByAppendingPathComponent:fileName];
                obj.stauts = HAPhotoUploadOrDownloadStateFinsish;
                [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
                [weakSelf.netOperationDic removeObjectForKey:certificate];
                if (weakSelf.photosArray.count < PHOTO_COUNT_MAX && weakSelf.netOperationDic.count == 0) {
                    weakSelf.addPhotoBtn.enabled = YES;
                    weakSelf.addPhotoBtn.layer.borderColor = [UIColor colorWithRed:245/255.0f green:2/255.0f blue:63/255.0f alpha:1].CGColor;
                }
                
                if(weakSelf.netOperationDic.count == 0){
                    strongSelf = nil;
                }
            } progress:^(NSString *certificate, float progress) {
                NSInteger index = [weakSelf.netOperationDic[certificate] integerValue];
                obj.progress = progress;
                [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];

            } onError:^(NSString *certificate,NSError *engineError) {
                NSInteger index = [weakSelf.netOperationDic[certificate] integerValue];
                NSString* path = [basePath stringByAppendingPathComponent:[obj.imagePath lastPathComponent]];
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                obj.stauts = HAPhotoUploadOrDownloadStateFalied;
                [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
                [weakSelf.netOperationDic removeObjectForKey:certificate];
                if (weakSelf.photosArray.count < PHOTO_COUNT_MAX && weakSelf.netOperationDic.count == 0) {
                    weakSelf.addPhotoBtn.enabled = YES;
                    weakSelf.addPhotoBtn.layer.borderColor = [UIColor colorWithRed:245/255.0f green:2/255.0f blue:63/255.0f alpha:1].CGColor;
                }
                if(weakSelf.netOperationDic.count == 0){
                    strongSelf = nil;
                }
            }];
            
            obj.stauts = HAPhotoUploadOrDownloadStateBegin;
            [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]];
            [weakSelf.netOperationDic setObject:@(idx) forKey:op.clientCertificate];
        }
        else{
            
        }

    }];
    
    if (self.photosArray.count >= PHOTO_COUNT_MAX || downloadedCount > 0 ) {
        self.addPhotoBtn.enabled = NO;
        self.addPhotoBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;

    }else if(downloadedCount == 0){
        self.addPhotoBtn.enabled = YES;
        self.addPhotoBtn.layer.borderColor = [UIColor colorWithRed:245/255.0f green:2/255.0f blue:63/255.0f alpha:1].CGColor;
    }
    


    self.saveBtn.enabled = NO;
    self.saveBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)viewDidDisappear:(BOOL)animated
{
   [super viewDidDisappear:animated];
   [self.delegate imagesOfHouseDidChange:[self.photosArray copy]];
}



#pragma mark - *** Helper ***

- (void)uploadHouseImageWithPath:(NSString*)path
{
    NSString* downloadsBasePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImagesNet"];
    __weak HAAddHousePhotoViewController* weakSelf = self;
    strongSelf = self;
    MKNetworkOperation* op = [[HARESTfulEngine defaultEngine] uploadHouseImageWithPath:path houseId:self.house.houseId completion:^(NSString* certificate,HAHouseImage *obj) {
        NSInteger index = [weakSelf.netOperationDic[certificate] integerValue];
        HAHouseImage* houseImageObj = weakSelf.photosArray[index];
        houseImageObj.imageId = obj.imageId;
        houseImageObj.stauts = HAPhotoUploadOrDownloadStateFinsish;
        
        NSString* targetPath = [downloadsBasePath stringByAppendingPathComponent:[obj.imagePath lastPathComponent]];
        [[NSFileManager defaultManager] moveItemAtPath:path toPath:targetPath error:nil];
        houseImageObj.localPath = targetPath;
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        [weakSelf.netOperationDic removeObjectForKey:certificate];
        obj.userId = weakSelf.house.landlordId;
        obj.houseId = weakSelf.house.houseId;

        if (weakSelf.photosArray.count >= PHOTO_COUNT_MAX) {
            weakSelf.addPhotoBtn.enabled = NO;
            weakSelf.addPhotoBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
        weakSelf.saveBtn.enabled = YES;
        weakSelf.saveBtn.layer.borderColor = [UIColor colorWithRed:245/255.0f green:2/255.0f blue:63/255.0f alpha:1].CGColor;
        if (weakSelf.netOperationDic.count == 0) {
            strongSelf = nil;
        }
    } progress:^(NSString *certificate, float progress) {
        NSInteger index = [weakSelf.netOperationDic[certificate] integerValue];
        HAHouseImage* houseImageObj = weakSelf.photosArray[index];
        houseImageObj.progress = progress;
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    } onError:^(NSString *certificate,NSError *engineError) {
        NSInteger index = [weakSelf.netOperationDic[op.clientCertificate] integerValue];
        HAHouseImage* houseImageObj = weakSelf.photosArray[index];
        houseImageObj.stauts = HAPhotoUploadOrDownloadStateFalied;
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        [weakSelf.netOperationDic removeObjectForKey:certificate];
        if (weakSelf.netOperationDic.count == 0) {
            strongSelf = nil;
        }
    }];
    [weakSelf.netOperationDic setObject:@(weakSelf.photosArray.count-1) forKey:op.clientCertificate];
}

#pragma mark - *** camera  helper***

- (void) showAssetsPickerController
{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.assetsFilter         = [ALAssetsFilter allPhotos];
    picker.showsCancelButton    = YES;
    picker.delegate             = self;
    picker.selectedAssets       = [[NSMutableArray alloc] initWithCapacity:0];
    picker.totalNumberOfChoices = PHOTO_COUNT_MAX - self.photosArray.count;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) showImagePickerController
{
    UIImagePickerController* imagepicker = [[UIImagePickerController alloc] init];
    imagepicker.delegate = self;
    imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
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
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImages"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager]  createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    __weak HAAddHousePhotoViewController* weakSelf = self;
    dispatch_async(self.uploadQueue, ^{
        for (ALAsset * asset in assets)
        {
            CGImageRef thumbnailImg = asset.aspectRatioThumbnail;
            NSString * fileID = gen_uuid();
            
            NSData* thumbnailJPGData = UIImageJPEGRepresentation([UIImage imageWithCGImage:thumbnailImg], 1);

            NSString* fileThumbnailName = [NSString stringWithFormat:@"%@_%@.jpg",fileID,@"thumbnail"];
            NSString* thumbnailImgPath = [filePath stringByAppendingPathComponent:fileThumbnailName];

            [thumbnailJPGData writeToFile:thumbnailImgPath atomically:YES];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                HAHouseImage* houseImageObj = [[HAHouseImage alloc] init];
                houseImageObj.localPath = thumbnailImgPath;
                houseImageObj.progress = 0;
                houseImageObj.loadType = HAPhotoLoadTypeUpload;
                houseImageObj.stauts = HAPhotoUploadOrDownloadStateBegin;
                [weakSelf.photosArray addObject:houseImageObj];
                [weakSelf.collectionView reloadData];
            });
            
            [weakSelf uploadHouseImageWithPath:thumbnailImgPath];
        }
    });

    



}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImages"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            [[NSFileManager defaultManager]  createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData* thumbnailJPGData = UIImageJPEGRepresentation(image, 0.4);
        
        NSString * fileID = gen_uuid();
        
        NSString* fileThumbnailName = [NSString stringWithFormat:@"%@_%@.jpg",fileID,@"thumbnail"];
        NSString* thumbnailImgPath = [filePath stringByAppendingPathComponent:fileThumbnailName];
        
        [thumbnailJPGData writeToFile:thumbnailImgPath atomically:YES];

        HAHouseImage* houseImageObj = [[HAHouseImage alloc] init];
        houseImageObj.localPath = thumbnailImgPath;
        houseImageObj.progress = 0;
        houseImageObj.loadType = HAPhotoLoadTypeUpload;
        houseImageObj.stauts = HAPhotoUploadOrDownloadStateBegin;
        [self.photosArray addObject:houseImageObj];
        [self.collectionView reloadData];
        [self uploadHouseImageWithPath:thumbnailImgPath];
    }];


}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - ***Cell Layout ***

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*)collectionViewLayout;
    CGRect rect = [UIScreen mainScreen].bounds;
    if (0 == indexPath.row) {
        CGFloat width = rect.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right;
        return  CGSizeMake(width, floor(width * 0.56));
    }
    else{
        CGFloat width = (rect.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumLineSpacing * 2) / 3;
        return CGSizeMake(floor(width) , floor(width));
    }
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (!self.collectionView) {
        self.collectionView = collectionView;
        self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    }
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HAAddPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HAAddPictureCell" forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[HAAddPictureCollectionViewCell alloc] init];
//        //cell.reuseIdentifier = reuseIdentifier;
//    }
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor blueColor].CGColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    HAHouseImage* item = self.photosArray[indexPath.row];
    HAAddPictureCollectionViewCell* pictureCell = (HAAddPictureCollectionViewCell*)cell;
    pictureCell.edited = self.edited ? YES : NO;
    pictureCell.delegate = self;
    pictureCell.uploadProgress = item.progress;
    pictureCell.mainImageIconHidden = YES;
    if (0 == indexPath.row){
        pictureCell.mainImageIconHidden = NO;
    }
    if (HAPhotoUploadOrDownloadStateBegin == item.stauts) {
        pictureCell.image = nil;
        [pictureCell showProgressView];
    }
    if (HAPhotoUploadOrDownloadStateFinsish == item.stauts ||
        HAPhotoUploadOrDownloadStateDownloaded == item.stauts) {
        [pictureCell hideProgressView];
        pictureCell.image = [UIImage imageWithContentsOfFile:item.localPath];
    }
    if (HAPhotoUploadOrDownloadStateFalied == item.stauts) {
        [pictureCell hideProgressView];
        [pictureCell showErrorImage];
    }
    
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
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString* basePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImagesNet"];
    HAHouseImage* item = self.photosArray[indexPath.row];
    HAAddPictureCollectionViewCell* pictureCell = (HAAddPictureCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (HAPhotoUploadOrDownloadStateFalied == item.stauts) {
        [pictureCell showProgressView];
        pictureCell.image = nil;
        if (HAPhotoLoadTypeDownload == item.loadType) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                item.stauts = HAPhotoUploadOrDownloadStateBegin;
                [NETWORKENGINE downloadHouseImageWithURL:item.imagePath storagePath:basePath completion:^(NSString *certificate, NSString *fileName) {
                    item.localPath = [basePath stringByAppendingPathComponent:fileName];
                    item.stauts = HAPhotoUploadOrDownloadStateFinsish;
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                } progress:^(NSString *certificate, float progress) {
                    item.progress = progress;
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                } onError:^(NSString *certificate, NSError *error) {
                    item.stauts = HAPhotoUploadOrDownloadStateFalied;
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                     NSString* path = [basePath stringByAppendingPathComponent:[item.imagePath lastPathComponent]];
                    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                }];
            });
        }
        else if (HAPhotoLoadTypeUpload == item.loadType){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            });
        }
    }
    else if (HAPhotoUploadOrDownloadStateFinsish == item.stauts ||
             HAPhotoUploadOrDownloadStateDownloaded == item.stauts){
        NSMutableArray* imageItemArray = [[NSMutableArray alloc] initWithCapacity:self.photosArray.count];
        for (NSInteger i = 0; i < self.photosArray.count; i ++) {
            HAHouseImage* imageItem = self.photosArray[i];
            UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            CGRect rect = [self.view convertRect:cell.frame fromView:collectionView];
            LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:nil
                                                                                  thumbnailURL:[NSURL URLWithString:imageItem.localPath]
                                                                                         HDURL:[NSURL URLWithString:imageItem.localPath]
                                                                            imageViewSuperView:cell.contentView
                                                                           positionAtSuperView:rect
                                                                                         index:indexPath.row];
            [imageItemArray addObject:imageModel];
        }
        LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                                imageModels:imageItemArray
                                                                               currentIndex:indexPath.row];
        imageBrowser.view.backgroundColor = [UIColor blackColor];
        [imageBrowser show];

    }
}

#pragma mark - *** Target Action ***
- (IBAction)addPhotoBtnClicked:(id)sender {
    
    [self showActionSheet];
}

- (IBAction)saveBtnClicked:(id)sender {
    if (self.photosArray.count <= 0) {
        return;
    }
    [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在处理";
    [[HARESTfulEngine defaultEngine] relationshipBetweenHousesAndPictures:([self.photosArray copy]) completion:^{
        [self.navigationController popViewControllerAnimated:YES];
        NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImages"];
        NSError* error;
        [[NSFileManager defaultManager]  removeItemAtPath:filePath error:&error];
        [self.delegate imagesOfHouseDidChange:[self.photosArray copy]];
        [HAActiveWheel dismissForView:self.navigationController.view];
    } onError:^(NSError *engineError) {
        [HAActiveWheel dismissViewDelay:3 forView:self.navigationController.view warningText:@"处理失败，请检查网络"];
    }];
}
#pragma mark - *** Target Action***
- (IBAction)editButtonClicked:(UIBarButtonItem*)sender {
    if ([sender.title isEqualToString:@"编辑"]) {
        sender.title = @"取消";
        self.edited = YES;
    }
    else{
        sender.title = @"编辑";
        self.edited = NO;
    }
    
    NSArray* array = [self.collectionView indexPathsForVisibleItems];

    [self.collectionView reloadItemsAtIndexPaths:array];

}


#pragma mark - *** HAAddPictureCollectionViewCellDelegate ***
- (void)deleteItemFromCell:(UICollectionViewCell *)cell
{
//    [self.photosArray exchangeObjectAtIndex:0 withObjectAtIndex:self.photosArray.count -1];
//    [self.collectionView moveItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] toIndexPath:[NSIndexPath indexPathForItem:self.photosArray.count -1 inSection:0]];
    
    HAAddPictureCollectionViewCell* pictureCell = (HAAddPictureCollectionViewCell*)cell;
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
    HAHouseImage* item = self.photosArray[indexPath.row];
    [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在处理";
    [[HARESTfulEngine defaultEngine] delteHouseImageWithImageId:item.imageId completion:^{
        [HAActiveWheel dismissForView:self.navigationController.view];
        [self.photosArray removeObjectAtIndex:indexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        pictureCell.image = nil;
        self.addPhotoBtn.enabled = YES;
        self.addPhotoBtn.layer.borderColor = [UIColor colorWithRed:245/255.0f green:2/255.0f blue:63/255.0f alpha:1].CGColor;
        [self.delegate imagesOfHouseDidChange:[self.photosArray copy]];
    } onError:^(NSError *engineError) {
        [HAActiveWheel dismissViewDelay:3 forView:self.navigationController.view warningText:@"删除失败，请检查网络"];
    }];
}

- (void)placeOnTopItemFromCell:(UICollectionViewCell*)cell
{
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
    
    if (0 == indexPath.row) {
        return;
    }

    [self.photosArray exchangeObjectAtIndex:0 withObjectAtIndex:indexPath.row];
    [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    //[NETWORKENGINE modifyHouseGeneralInfoWithID:houseCopy.houseId params:<#(HAHouse *)#> completion:<#^(HAHouse *house)completion#> onError:<#^(NSError *engineError)errorBlcok#>]
    
}



@end
