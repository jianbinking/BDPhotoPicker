//
//  BDPhotoPickerGroupManager.m
//  test_photo
//
//  Created by 王建斌 on 16/11/7.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import "BDPhotoPickerGroupManager.h"
#import "BDPhotoPickerGroupTableController.h"

@implementation BDPhotoPickerGroupManager

- (void)loadCollectionsComplete:(CompleteBlock)block
{
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                     subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                     options:nil];
    [self addCollectionsFromFetchResult:result];
    result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                      subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumImported | PHAssetCollectionSubtypeAlbumSyncedAlbum
                                                      options:nil];
    [self addCollectionsFromFetchResult:result];
    if (block)
    {
        block(YES,nil);
    }
}

- (void)addCollectionsFromFetchResult:(PHFetchResult*)result
{
    for (NSInteger i = 0 ; i < result.count ; i ++)
    {
        PHCollection *collection = result[i];
        if ([collection isKindOfClass:PHAssetCollection.class])
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(BDPhotoPickerController:shouldShowGroup:)])
            {
                if (![self.delegate BDPhotoPickerController:[self.groupVC pickerController] shouldShowGroup:((PHAssetCollection*)collection)])
                {
                    continue;
                }
            }
            if (((PHAssetCollection*)collection).estimatedAssetCount > 0)
            {
                [self.arrCollections addObject:((PHAssetCollection*)collection)];
            }
        }
    }
}

- (PHAsset*)keyAssetAtIndex:(NSInteger)idx
{
    return [PHAsset fetchKeyAssetsInAssetCollection:self.arrCollections[idx] options:nil].firstObject;
}

- (NSMutableArray <PHAssetCollection*>*)arrCollections
{
    if (!_arrCollections)
    {
        _arrCollections = [NSMutableArray array];
    }
    return _arrCollections;
}

@end
