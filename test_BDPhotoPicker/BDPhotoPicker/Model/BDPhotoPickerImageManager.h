//
//  BDPhotoPickerImageManager.h
//  test_photo
//
//  Created by 王建斌 on 16/11/7.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void (^requestImageCompleteBlock)(UIImage *__nullable ima,NSDictionary *__nullable dicInfo);

@interface BDPhotoPickerImageManager : PHCachingImageManager<NSCopying>

+ (instancetype __nullable)sharedManager;

- (UIImage*)imageFromAsset:(PHAsset*)asset;

/**
 *  同步取图片（请求取下一个的时候会取消这个）
 *
 *  @param asset         asset
 *  @param targetSize    目标大小
 *  @param contentMode   展示mode
 *  @param options       信息
 *  @param resultHandler 成功回调
 *
 *  @return 返回ID，可根据这个ID取消任务
 */
- (PHImageRequestID)syncRequestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(nullable PHImageRequestOptions *)options resultHandler:(requestImageCompleteBlock)resultHandler;

/**
 *  异步取图片（请求下一个的时候不会取消这个）
 *
 *  @param asset         asset
 *  @param targetSize    目标大小
 *  @param contentMode   展示mode
 *  @param options       信息
 *  @param resultHandler 成功回调
 *
 *  @return 返回ID，可根据这个ID取消任务
 */
- (PHImageRequestID)asyncRequestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(nullable PHImageRequestOptions *)options resultHandler:(requestImageCompleteBlock)resultHandler;

@end
