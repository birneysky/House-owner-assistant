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

@interface HAAddHousePhotoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic,strong) NSMutableArray* selectedPhotoPathes;

@property (nonatomic,strong) NSMutableDictionary* netOperationDic;

@property (nonatomic,strong) NSMutableArray <HAHouseImage*>* photosArray;

@property(nonatomic,assign) BOOL edited;

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


@implementation HAAddHousePhotoViewController

- (void)dealloc
{
    NSLog(@"HAAddHousePhotoViewController dealloc ~");
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[HAAddPictureCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
   // self.automaticallyAdjustsScrollViewInsets = NO;
    //self.photoCollectionViewController.datasource = self.selectedPhotoPathes;
    //NSInteger count = self.photoCollectionViewController.datasource.count;
    
    if (self.photoes.count > 0) {
        [self.photosArray addObjectsFromArray:self.photoes];
    }
    NSString* basePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImagesNet"];
    //检测图片是否存在
    __weak HAAddHousePhotoViewController* weakSelf = self;
    [self.photosArray enumerateObjectsUsingBlock:^(HAHouseImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        HAPhotoItem* item = [[HAPhotoItem alloc] init];
//        item.imageId = obj.imageId;
//        item.loadType = HAPhotoLoadTypeDownload;
//        item.netPath = obj.imagePath;
        obj.loadType = HAPhotoLoadTypeDownload;
        
        NSString* path = [basePath stringByAppendingPathComponent:[obj.imagePath lastPathComponent]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path] && HAPhotoUploadOrDownloadStateUnknown == obj.stauts) {
            obj.localPath = path;
            //item.localPath = path;
            //item.state = HAPhotoUploadOrDownloadStateDownloaded;
            obj.stauts = HAPhotoUploadOrDownloadStateDownloaded;
        }
        //[weakSelf.selectedPhotoPathes addObject:item];
    }];
    
    [self.collectionView reloadData];
    //检测图片在不在，不在开始下载，暂时先直接开下
    __block NSInteger downloadedCount = 0;
    
    [self.photosArray enumerateObjectsUsingBlock:^(HAHouseImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //NSLog(@"imagePath %@",obj.imagePath);
        if(obj.localPath.length <= 0 && HAPhotoUploadOrDownloadStateUnknown == obj.stauts){
            downloadedCount ++;
            MKNetworkOperation* op = [[HARESTfulEngine defaultEngine] downloadHouseImageWithPath:obj.imagePath completion:^(NSString *certificate, NSString *fileName) {
                NSInteger index = [weakSelf.netOperationDic[certificate] integerValue];
//                HAPhotoItem* item = weakSelf.selectedPhotoPathes[index];
//                item.localPath = [basePath stringByAppendingPathComponent:fileName];
//                item.state = HAPhotoUploadOrDownloadStateFinsish;
                obj.localPath = [basePath stringByAppendingPathComponent:fileName];
                obj.stauts = HAPhotoUploadOrDownloadStateFinsish;
                [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
                [weakSelf.netOperationDic removeObjectForKey:certificate];
                if (weakSelf.photosArray.count < PHOTO_COUNT_MAX && weakSelf.netOperationDic.count == 0) {
                    weakSelf.addPhotoBtn.enabled = YES;
                    weakSelf.addPhotoBtn.layer.borderColor = [UIColor colorWithRed:245/255.0f green:2/255.0f blue:63/255.0f alpha:1].CGColor;
                }
                
            } progress:^(NSString *certificate, float progress) {
                NSInteger index = [weakSelf.netOperationDic[certificate] integerValue];
//                HAPhotoItem* item = weakSelf.selectedPhotoPathes[index];
//                item.progress = progress;
                obj.progress = progress;
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
                //[self.collectionView reloadData];
                //NSLog(@"progess %f imageId %ld",progress,(long)obj.imageId);
            } onError:^(NSString *certificate,NSError *engineError) {
                NSInteger index = [weakSelf.netOperationDic[certificate] integerValue];
                //HAPhotoItem* item = weakSelf.selectedPhotoPathes[index];
                NSString* path = [basePath stringByAppendingPathComponent:[obj.imagePath lastPathComponent]];
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                //item.state = HAPhotoUploadOrDownloadStateFalied;
                obj.stauts = HAPhotoUploadOrDownloadStateFalied;
                [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
                [weakSelf.netOperationDic removeObjectForKey:certificate];
                if (weakSelf.photosArray.count < PHOTO_COUNT_MAX && weakSelf.netOperationDic.count == 0) {
                    weakSelf.addPhotoBtn.enabled = YES;
                    weakSelf.addPhotoBtn.layer.borderColor = [UIColor colorWithRed:245/255.0f green:2/255.0f blue:63/255.0f alpha:1].CGColor;
                }
            }];
//            HAPhotoItem* item = weakSelf.selectedPhotoPathes[idx];
//            item.state = HAPhotoUploadOrDownloadStateBegin;
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
    MKNetworkOperation* op = [[HARESTfulEngine defaultEngine] uploadHouseImageWithPath:path houseId:self.house.houseId completion:^(NSString* certificate,HAHouseImage *obj) {
        NSInteger index = [weakSelf.netOperationDic[certificate] integerValue];
//        HAPhotoItem* item = weakSelf.selectedPhotoPathes[index];
//        item.imageId = obj.imageId;
//        item.state = HAPhotoUploadOrDownloadStateFinsish;
        
        HAHouseImage* houseImageObj = weakSelf.photosArray[index];
        houseImageObj.imageId = obj.imageId;
        houseImageObj.stauts = HAPhotoUploadOrDownloadStateFinsish;
        
        NSString* targetPath = [downloadsBasePath stringByAppendingPathComponent:[obj.imagePath lastPathComponent]];
        [[NSFileManager defaultManager] moveItemAtPath:path toPath:targetPath error:nil];
        //item.localPath = targetPath;
        houseImageObj.localPath = targetPath;
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        [weakSelf.netOperationDic removeObjectForKey:certificate];
        obj.userId = weakSelf.house.landlordId;
        obj.houseId = weakSelf.house.houseId;

        
        //[weakSelf.photosArray addObject:obj];
        if (weakSelf.photosArray.count >= PHOTO_COUNT_MAX) {
            weakSelf.addPhotoBtn.enabled = NO;
            weakSelf.addPhotoBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
        weakSelf.saveBtn.enabled = YES;
        weakSelf.saveBtn.layer.borderColor = [UIColor colorWithRed:245/255.0f green:2/255.0f blue:63/255.0f alpha:1].CGColor;
    } progress:^(NSString *certificate, float progress) {
        NSInteger index = [weakSelf.netOperationDic[certificate] integerValue];
//        HAPhotoItem* item = weakSelf.selectedPhotoPathes[index];
//        item.progress = progress;
        HAHouseImage* houseImageObj = weakSelf.photosArray[index];
        houseImageObj.progress = progress;
        
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    } onError:^(NSString *certificate,NSError *engineError) {
        NSInteger index = [weakSelf.netOperationDic[op.clientCertificate] integerValue];
//        HAPhotoItem* item = weakSelf.selectedPhotoPathes[index];
//        item.state = HAPhotoUploadOrDownloadStateFalied;
        HAHouseImage* houseImageObj = weakSelf.photosArray[index];
        houseImageObj.stauts = HAPhotoUploadOrDownloadStateFalied;
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        [weakSelf.netOperationDic removeObjectForKey:certificate];
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
    //self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
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
    dispatch_queue_t queue = dispatch_queue_create("com.upload.file", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        for (ALAsset * asset in assets)
        {
            CGImageRef fullimg = [[asset defaultRepresentation] fullScreenImage];
            CGImageRef thumbnailImg = asset.aspectRatioThumbnail;
            NSString * fileID = gen_uuid();
            const char* guid = [fileID cStringUsingEncoding:NSUTF8StringEncoding];
            
//            NSData * pngData = UIImagePNGRepresentation([UIImage imageWithCGImage:fullimg]);
            //NSData* thumbnailData = UIImagePNGRepresentation([UIImage imageWithCGImage:thumbnailImg]);
            NSData* thumbnailJPGData = UIImageJPEGRepresentation([UIImage imageWithCGImage:thumbnailImg], 1);
            
            
            NSString* fullImgfilePath = [filePath stringByAppendingPathComponent:fileID];
            NSString* fileThumbnailName = [NSString stringWithFormat:@"%@_%@.jpg",fileID,@"thumbnail"];
            NSString* thumbnailImgPath = [filePath stringByAppendingPathComponent:fileThumbnailName];

            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            //[pngData writeToFile:fullImgfilePath atomically:YES];
            [thumbnailJPGData writeToFile:thumbnailImgPath atomically:YES];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
//                HAPhotoItem* allocItem = [[HAPhotoItem alloc] init];
//                allocItem.localPath = thumbnailImgPath;
//                allocItem.progress = 0;
//                allocItem.loadType = HAPhotoLoadTypeUpload;
//                allocItem.state = HAPhotoUploadOrDownloadStateBegin;
//                [self.selectedPhotoPathes addObject:allocItem];
                
                HAHouseImage* houseImageObj = [[HAHouseImage alloc] init];
                houseImageObj.localPath = thumbnailImgPath;
                houseImageObj.progress = 0;
                houseImageObj.loadType = HAPhotoLoadTypeUpload;
                houseImageObj.stauts = HAPhotoUploadOrDownloadStateBegin;
                [self.photosArray addObject:houseImageObj];
                [self.collectionView reloadData];
            });
            
            [self uploadHouseImageWithPath:thumbnailImgPath];
//            MKNetworkOperation* op = [[HARESTfulEngine defaultEngine] uploadHouseImageWithPath:thumbnailImgPath completion:^(NSString* certificate,HAHouseImage *obj) {
//                NSInteger index = [self.netOperationDic[certificate] integerValue];
//                HAPhotoItem* item = self.selectedPhotoPathes[index];
//                item.state = HAPhotoUploadOrDownloadStateFinsish;
//                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
//                obj.userId = self.house.landlordId;
//                obj.houseId = self.house.houseId;
//                [self.photosArray addObject:obj];
//            } progress:^(NSString *certificate, float progress) {
//                NSInteger index = [self.netOperationDic[certificate] integerValue];
//                HAPhotoItem* item = self.selectedPhotoPathes[index];
//                item.progress = progress;
//                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
//            } onError:^(NSError *engineError) {
//                
//            }];
//            MKNetworkOperation* op = [[HARESTfulEngine defaultEngine] uploadHouseImageWithPath:thumbnailImgPath completion:(void (^)(HAHouseImage* obj)){
//                
//            } progress:^(NSString* certificate, float progress) {
//                NSInteger index = [self.netOperationDic[certificate] integerValue];
//                HAPhotoItem* item = self.selectedPhotoPathes[index];
//                item.progress = progress;
//                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
//            }];
            //NSLog(@"key %@",op.clientCertificate);
//            [self.netOperationDic setObject:@(self.selectedPhotoPathes.count-1) forKey:op.clientCertificate];
            //});
            
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
        
        NSString* fullImgfilePath = [filePath stringByAppendingPathComponent:fileID];
        NSString* fileThumbnailName = [NSString stringWithFormat:@"%@_%@.jpg",fileID,@"thumbnail"];
        NSString* thumbnailImgPath = [filePath stringByAppendingPathComponent:fileThumbnailName];
        
        [thumbnailJPGData writeToFile:thumbnailImgPath atomically:YES];
//        HAPhotoItem* allocItem = [[HAPhotoItem alloc] init];
//        allocItem.localPath = thumbnailImgPath;
//        allocItem.progress = 0;
//        allocItem.loadType = HAPhotoLoadTypeUpload;
//        allocItem.state = HAPhotoUploadOrDownloadStateBegin;
//        [self.selectedPhotoPathes addObject:allocItem];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    //return self.selectedPhotoPathes.count;
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //BOOL lastOneFlag = indexPath.row == 9;
    HAAddPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HAAddPictureCell" forIndexPath:indexPath];
    // Configure the cell
    //HAPhotoItem* item = self.selectedPhotoPathes[indexPath.row];
    //    UIView* selectBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    //    selectBackgroundView.backgroundColor = [UIColor orangeColor];
    
    //cell.image = [UIImage imageWithContentsOfFile:item.path];
    //cell.selectedBackgroundView = selectBackgroundView;
    //cell.edited = self.edited ? YES : NO;
    //cell.delegate = self;
    //cell.uploadProgress = item.progress;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //HAPhotoItem* item = self.selectedPhotoPathes[indexPath.row];
    HAHouseImage* item = self.photosArray[indexPath.row];
    HAAddPictureCollectionViewCell* pictureCell = (HAAddPictureCollectionViewCell*)cell;
    pictureCell.edited = self.edited ? YES : NO;
    pictureCell.delegate = self;
    pictureCell.uploadProgress = item.progress;
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
    //HAPhotoItem* item = self.selectedPhotoPathes[indexPath.row];
    HAHouseImage* item = self.photosArray[indexPath.row];
    HAAddPictureCollectionViewCell* pictureCell = (HAAddPictureCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (HAPhotoUploadOrDownloadStateFalied == item.stauts) {
        [pictureCell showProgressView];
        pictureCell.image = nil;
        if (HAPhotoLoadTypeDownload == item.loadType) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                item.stauts = HAPhotoUploadOrDownloadStateBegin;
                [NETWORKENGINE downloadHouseImageWithPath:item.imagePath completion:^(NSString *certificate, NSString *fileName) {
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
//        UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
//        CGRect rect = [collectionView convertRect:cell.frame fromView:collectionView];
//        NSLog(@"rect %@",NSStringFromCGRect(rect));
        NSMutableArray* imageItemArray = [[NSMutableArray alloc] initWithCapacity:self.photosArray.count];
        NSString* basePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImagesNet"];
        for (NSInteger i = 0; i < self.photosArray.count; i ++) {
            HAHouseImage* imageItem = self.photosArray[i];
            UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            CGRect rect = [self.view convertRect:cell.frame fromView:collectionView];
            NSLog(@"rect %@",NSStringFromCGRect(rect));
            NSString* itemPath = [basePath stringByAppendingPathComponent:[imageItem.imagePath lastPathComponent]];
            LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:nil
                                                                                  thumbnailURL:[NSURL URLWithString:itemPath]
                                                                                         HDURL:[NSURL URLWithString:itemPath]
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
    //[self.collectionView ];
    if ([sender.title isEqualToString:@"编辑"]) {
        sender.title = @"取消";
        self.edited = YES;
    }
    else{
        sender.title = @"编辑";
        self.edited = NO;
    }
    
    NSArray* array = [self.collectionView indexPathsForVisibleItems];
    //NSArray* arrayCell = [self.collectionView visibleCells];

    [self.collectionView reloadItemsAtIndexPaths:array];//
    
    
    //self.collectionView.indexPathsForVisibleItems;
//     [self.photoCollectionViewController.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    //[self.collectionView reloadData];
}


#pragma mark - *** HAAddPictureCollectionViewCellDelegate ***
- (void)deleteItemFromCell:(UICollectionViewCell *)cell
{
    HAAddPictureCollectionViewCell* pictureCell = (HAAddPictureCollectionViewCell*)cell;
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
    //HAPhotoItem* item = self.selectedPhotoPathes[indexPath.row];
    HAHouseImage* item = self.photosArray[indexPath.row];
    [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在处理";
    [[HARESTfulEngine defaultEngine] delteHouseImageWithImageId:item.imageId completion:^{
        [HAActiveWheel dismissForView:self.navigationController.view];
        //[self.selectedPhotoPathes removeObjectAtIndex:indexPath.row];
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



@end
