//
//  BDPhotoGroupCell.h
//  test_photo
//
//  Created by 王建斌 on 16/11/7.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#define kBDPhotoGroupCellHeight 80

@interface BDPhotoGroupCell : UITableViewCell


- (void)setCollection:(PHAssetCollection*)collection keyAsset:(PHAsset*)asset;

@end
