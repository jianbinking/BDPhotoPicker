//
//  BDPhotoPickerImageManager.m
//  test_photo
//
//  Created by 王建斌 on 16/11/7.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import "BDPhotoPickerImageManager.h"

static BDPhotoPickerImageManager *manager = nil;

@interface BDPhotoPickerImageManager()

@property (assign, nonatomic) PHImageRequestID preID;

@end

@implementation BDPhotoPickerImageManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
        manager.preID = -1;
    });
    return manager;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self.class sharedManager];
}

- (UIImage*)imageFromAsset:(PHAsset *)asset
{
    __block UIImage *imaReturn = nil;
    PHImageRequestOptions *opts = [[PHImageRequestOptions alloc] init];
    opts.resizeMode = PHImageRequestOptionsResizeModeExact;
    opts.synchronous = YES;
    [self syncRequestImageForAsset:asset
                        targetSize:PHImageManagerMaximumSize
                       contentMode:PHImageContentModeDefault
                           options:opts
                     resultHandler:^(UIImage * _Nullable ima, NSDictionary * _Nullable dicInfo) {
                         imaReturn = ima;
                     }];
    return imaReturn;
}

- (PHImageRequestID)syncRequestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(nullable PHImageRequestOptions *)options resultHandler:(requestImageCompleteBlock)resultHandler
{
    if (self.preID > 0)
    {
        [self cancelImageRequest:self.preID];
    }
    self.preID = [self requestImageForAsset:asset targetSize:targetSize contentMode:contentMode options:options resultHandler:resultHandler];
    return self.preID;
}

- (PHImageRequestID)asyncRequestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(nullable PHImageRequestOptions *)options resultHandler:(requestImageCompleteBlock)resultHandler
{
    if (self.preID > 0)
    {
        [self cancelImageRequest:self.preID];
    }
    return [self requestImageForAsset:asset targetSize:targetSize contentMode:contentMode options:options resultHandler:resultHandler];
}

@end
