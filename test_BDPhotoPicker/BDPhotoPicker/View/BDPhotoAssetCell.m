//
//  BDPhotoAssetCell.m
//  test_photo
//
//  Created by 王建斌 on 16/11/7.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import "BDPhotoAssetCell.h"
#import "BDPhotoPickerImageManager.h"
#import "BDPhotoPickerController.h"
#import "BDPhotoPickerAssetsCollectionController.h"


#define kImaCheck_n @"BDPhotoPickerCheckMark_n"
#define kImaCheck_s @"BDPhotoPickerCheckMark_s"


@interface BDPhotoAssetCell()

@property (strong, nonatomic) NSData *dataImage;

@property (strong, nonatomic) PHAsset *asset;



@end
@implementation BDPhotoAssetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)bindAsset:(PHAsset *)asset
{
    self.asset = asset;
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.resizeMode = PHImageRequestOptionsResizeModeExact;
    option.networkAccessAllowed = NO;
    CGFloat scale = [UIScreen mainScreen].scale;
    [[BDPhotoPickerImageManager sharedManager] asyncRequestImageForAsset:asset
                                                              targetSize:CGSizeMake(CGRectGetWidth(self.frame) * scale, CGRectGetHeight(self.frame) * scale)
                                                             contentMode:PHImageContentModeAspectFill
                                                                 options:option
                                                           resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                               if (result)
                                                               {
                                                                   self.dataImage = UIImagePNGRepresentation(result);
                                                                   [self setNeedsDisplay];
                                                               }
                                                           }];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UIImage *image = [UIImage imageWithData:self.dataImage];
    [image drawInRect:rect];
    UIImage *checkMark = nil;
    if (self.assetSelected)
    {
        checkMark = [UIImage imageNamed:kImaCheck_s];
    }
    else
    {
        checkMark = [UIImage imageNamed:kImaCheck_n];
    }
    CGFloat width = 20.0 / 87.0 * CGRectGetWidth(self.frame);
    CGRect rc = CGRectMake(CGRectGetWidth(self.frame) - width - 4, 4, width, width);
    [checkMark drawInRect:rc];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = event.allTouches.anyObject;
    CGFloat width = 20.0 / 87.0 * CGRectGetWidth(self.frame);
    CGRect rc = CGRectMake(CGRectGetWidth(self.frame) - width - 4, 4, width, width);
    if (CGRectContainsPoint(rc, [touch locationInView:self]))
    {
        if (self.assetSelected)
        {
            [[self collectionVC].pickerController deselectAsset:self.asset];
        }
        else
        {
            [[self collectionVC].pickerController selectAsset:self.asset];
        }
        
    }
    else
    {
        [super touchesBegan:touches withEvent:event];
    }
}

- (BDPhotoPickerAssetsCollectionController*)collectionVC
{
    for (UIView *view = self.superview ; ; view = view.superview)
    {
        UIResponder *responder = view.nextResponder;
        if ([responder isKindOfClass:[BDPhotoPickerAssetsCollectionController class]])
        {
            return (BDPhotoPickerAssetsCollectionController*)responder;
        }
    }
    return nil;
}

- (void)setAssetSelected:(BOOL)assetSelected
{
    _assetSelected = assetSelected;
    [self setNeedsDisplay];
}

@end
