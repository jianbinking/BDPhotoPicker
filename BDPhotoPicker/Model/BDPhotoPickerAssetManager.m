//
//  BDPhotoPickerAssetManager.m
//  test_photo
//
//  Created by 王建斌 on 16/11/7.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import "BDPhotoPickerAssetManager.h"
#import "BDPhotoPickerAssetsCollectionController.h"

@implementation BDPhotoPickerAssetManager

- (void)loadAssetsFromCollection:(PHAssetCollection *)collection Complete:(CompleteBlock)block
{
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    for (NSInteger i = 0 ; i < result.count ; i ++)
    {
        PHAsset *asset = result[i];
        if (self.delegate && [self.delegate respondsToSelector:@selector(BDPhotoPickerController:shouldShowAsset:)])
        {
            if (![self.delegate BDPhotoPickerController:[self.groupVC pickerController] shouldShowAsset:asset])
            {
                continue;
            }
        }
        [self.arrAssets addObject:asset];
    }
    if (block)
    {
        block(YES,nil);
    }
}



- (NSMutableArray <PHAsset*>*)arrAssets
{
    if (!_arrAssets)
    {
        _arrAssets = [NSMutableArray array];
    }
    return _arrAssets;
}

@end
