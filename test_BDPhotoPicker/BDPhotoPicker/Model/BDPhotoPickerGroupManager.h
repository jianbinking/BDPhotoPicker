//
//  BDPhotoPickerGroupManager.h
//  test_photo
//
//  Created by 王建斌 on 16/11/7.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDPhotoPickerController.h"

@class BDPhotoPickerGroupTableController;
@interface BDPhotoPickerGroupManager : NSObject

@property (weak, nonatomic) BDPhotoPickerGroupTableController *groupVC;

@property (weak, nonatomic) id<BDPhotoPickerControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray <PHAssetCollection*>* arrCollections;

- (void)loadCollectionsComplete:(CompleteBlock)block;

- (PHAsset*)keyAssetAtIndex:(NSInteger)idx;

@end
