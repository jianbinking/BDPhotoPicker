//
//  BDPhotoPickerAssetManager.h
//  test_photo
//
//  Created by 王建斌 on 16/11/7.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDPhotoPickerCommon.h"
#import <Photos/Photos.h>
#import "BDPhotoPickerController.h"

@class BDPhotoPickerAssetsCollectionController;
@interface BDPhotoPickerAssetManager : NSObject

@property (strong, nonatomic) NSMutableArray <PHAsset*>*arrAssets;

@property (weak, nonatomic) BDPhotoPickerAssetsCollectionController *groupVC;

@property (weak, nonatomic) id<BDPhotoPickerControllerDelegate> delegate;

- (void)loadAssetsFromCollection:(PHAssetCollection*)collection Complete:(CompleteBlock)block;


@end
