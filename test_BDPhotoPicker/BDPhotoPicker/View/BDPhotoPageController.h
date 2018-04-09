//
//  BDPhotoPageController.h
//  test_photo
//
//  Created by 王建斌 on 16/11/8.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol BDPhotoPageDataSource <NSObject>

- (PHAsset*)assetForIndex:(NSInteger)idx;

- (BOOL)assetIsSelectedAtIndex:(NSInteger)idx;

@end

@class BDPhotoPickerController;
@interface BDPhotoPageController : UIPageViewController

@property (strong, nonatomic) NSArray<PHAsset*> *arrAssets;

@property (assign, nonatomic) NSInteger currentIdx;

@property (weak, nonatomic) id<BDPhotoPageDataSource> bdDataSource;

- (instancetype)initWithAssets:(NSArray<PHAsset*>*)assets;

- (BDPhotoPickerController*)pickerController;

@end



@interface BDPhotoPageItemController : UIViewController

@property (assign, nonatomic) BOOL bDownloadSuccess;

@property (assign, nonatomic) NSInteger index;

@property (weak, nonatomic) id<BDPhotoPageDataSource> bdDataSource;

@end
