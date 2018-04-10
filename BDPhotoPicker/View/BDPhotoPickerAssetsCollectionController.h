//
//  BDPhotoPickerAssetsCollectionController.h
//  test_photo
//
//  Created by 王建斌 on 16/11/7.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class BDPhotoPickerController;
@interface BDPhotoPickerAssetsCollectionController : UIViewController

@property (strong, nonatomic, readonly) UICollectionView *collectionView;

@property (strong, nonatomic) PHAssetCollection *collection;

- (BDPhotoPickerController*)pickerController;

@end
