//
//  BDPhotoAssetCell.h
//  test_photo
//
//  Created by 王建斌 on 16/11/7.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface BDPhotoAssetCell : UICollectionViewCell

@property (assign, nonatomic) BOOL assetSelected;
@property (weak, nonatomic) IBOutlet UIImageView *imaThumb;

- (void)bindAsset:(PHAsset*)asset;

@end
