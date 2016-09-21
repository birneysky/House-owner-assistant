//
//  HAHouseImage.h
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAJSONModel.h"


typedef NS_ENUM(NSInteger, HAPhotoUploadOrDownloadState) {
    HAPhotoUploadOrDownloadStateUnknown,
    HAPhotoUploadOrDownloadStateNotDownloaded, //未下载
    HAPhotoUploadOrDownloadStateDownloaded, // 已下载
    HAPhotoUploadOrDownloadStateBegin, //开始下载
    HAPhotoUploadOrDownloadStateFinsish, // 下载完成
    HAPhotoUploadOrDownloadStateFalied //下载失败
};

typedef NS_ENUM(NSInteger, HAPhotoLoadType) {
    HAPhotoLoadTypeDownload,
    HAPhotoLoadTypeUpload
};

@interface HAHouseImage : HAJSONModel

@property(nonatomic,assign) NSInteger imageId;
@property(nonatomic,assign) NSInteger houseId;
@property(nonatomic,copy)   NSString* imagePath;
@property(nonatomic,assign) NSInteger userId;

@property(nonatomic,copy)  NSString* localPath;

@property (assign,nonatomic) float progress;

@property (nonatomic,assign) BOOL isFirstImage;

@property (nonatomic, assign) HAPhotoUploadOrDownloadState stauts;

@property (nonatomic, assign) HAPhotoLoadType loadType;

@end
