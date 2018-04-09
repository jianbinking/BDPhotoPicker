//
//  BDPhotoPickerDelegate.h
//  test_photo
//
//  Created by 王建斌 on 16/11/7.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#ifndef BDPhotoPickerDelegateDatasource_h
#define BDPhotoPickerDelegateDatasource_h

@class BDPhotoPickerController;

@protocol BDPhotoPickerControllerDelegate <NSObject>

@required

- (void)BDPhotoPickerController:(BDPhotoPickerController*)picker didFinishPickingWithAssets:(NSArray<PHAsset*>*)arrAssets;

- (void)BDPhotoPickerControllerDidCancelPicking:(BDPhotoPickerController*)picker;

@optional

- (BOOL)BDPhotoPickerController:(BDPhotoPickerController*)picker isDefaultGroup:(PHAssetCollection*)group;

- (BOOL)BDPhotoPickerController:(BDPhotoPickerController*)picker shouldShowGroup:(PHAssetCollection*)group;

- (BOOL)BDPhotoPickerController:(BDPhotoPickerController*)picker shouldShowAsset:(PHAsset*)asset;

- (BOOL)BDPhotoPickerController:(BDPhotoPickerController*)picker shouldSelectedAsset:(PHAsset*)asset;

@end


#endif /* BDPhotoPickerDelegateDatasource_h */
