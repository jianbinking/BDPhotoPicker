//
//  UIImage+BDPhotoPickerController.m
//  test_photo
//
//  Created by 王建斌 on 16/11/4.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import "UIImage+BDPhotoPickerController.h"
#import <Photos/Photos.h>


@implementation UIImage (BDPhotoPickerController)

- (void)saveToAlbum:(nullable void(^)(BOOL success, NSString *assetID, NSError *__nullable error))completionHandler
{
    __block NSString *assetID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        assetID = [PHAssetCreationRequest creationRequestForAssetFromImage:self].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (completionHandler)
        {
            completionHandler(success, assetID, error);
        }
    }];
}

- (void)saveToCustomCollectionWithName:(NSString *)name complete:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler
{
    [self saveToAlbum:^(BOOL success, NSString *assetID, NSError * _Nullable error) {
        if (success && assetID &&!error)
        {
            PHAssetCollection *collection = [self collectionWithName:name];
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
                PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil].firstObject;
                [request addAssets:@[asset]];
            } completionHandler: completionHandler];
        }
        else
        {
            if (completionHandler)
            {
                completionHandler(success, error);
            }
        }
    }];
}

- (PHAssetCollection*)collectionWithName:(NSString*)name;
{
    
    PHFetchResult<PHAssetCollection*> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                                                   subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                                                   options:nil];
    for (PHAssetCollection *coll in collectionResult)
    {
        if ([coll.localizedTitle isEqualToString:name])
        {
            return coll;
        }
    }
    __block NSString * collectionID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name].placeholderForCreatedAssetCollection.localIdentifier;
        
    } error:nil];
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionID] options:nil].firstObject;
}

@end
