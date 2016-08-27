//
//  HAPhotoItem.h
//  HOAKit
//
//  Created by birneysky on 16/8/21.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, HAPhotoUploadOrDownloadState) {
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

@interface HAPhotoItem : NSObject

@property (nonatomic,assign) NSInteger imageId;

@property (copy,nonatomic) NSString* localPath;

@property (copy,nonatomic) NSString* netPath;

@property (assign,nonatomic) float progress;

@property (nonatomic, assign) HAPhotoUploadOrDownloadState state;

@property (nonatomic, assign) HAPhotoLoadType loadType;

@end
