//
//  BDPhotoGroupCell.m
//  test_photo
//
//  Created by 王建斌 on 16/11/7.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import "BDPhotoGroupCell.h"
#import "BDPhotoPickerImageManager.h"

@interface BDPhotoGroupCell()

@property (weak, nonatomic) IBOutlet UIImageView *imaThumb;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;

@end

@implementation BDPhotoGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCollection:(PHAssetCollection*)collection keyAsset:(PHAsset*)asset
{
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    
    self.lblInfo.text = [NSString stringWithFormat:@"%@(%li)",collection.localizedTitle,result.count];
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.resizeMode = PHImageRequestOptionsResizeModeExact;
    option.networkAccessAllowed = NO;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    [[BDPhotoPickerImageManager sharedManager] asyncRequestImageForAsset:asset
                                                              targetSize:CGSizeMake(kBDPhotoGroupCellHeight * scale, kBDPhotoGroupCellHeight * scale)
                                                             contentMode:PHImageContentModeAspectFill
                                                                 options:option
                                                           resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                               self.imaThumb.image = result;
                                                           }];
}

@end
