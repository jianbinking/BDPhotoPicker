//
//  BDPhotoPickerController.h
//  test_photo
//
//  Created by 王建斌 on 16/11/4.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "BDPhotoPickerDelegate.h"

typedef void (^CompleteBlock)(BOOL success, NSError *err);

extern NSString * const kBDPhotoPickerDidSelectedAssetNotification;
extern NSString * const kBDPhotoPickerDidDeselectedAssetNotification;
extern NSString * const kBDPhotoPickerAssetsChangedNotification;

@interface BDPhotoPickerController : UIViewController

@property (weak, nonatomic) id<BDPhotoPickerControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray <PHAsset*>*arrSelectedAssets;

@property (strong, nonatomic) NSString *strDefaultGroupName;

@property (strong, nonatomic) UINavigationController *childNavCtrl;



- (void)selectAsset:(PHAsset*)asset;

- (void)deselectAsset:(PHAsset*)asset;

- (NSArray<UIBarButtonItem*>*)customToolbarItems;

- (void)toggleDoneButton;

@end
