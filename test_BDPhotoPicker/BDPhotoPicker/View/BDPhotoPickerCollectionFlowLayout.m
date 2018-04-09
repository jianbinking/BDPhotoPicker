//
//  BDPhotoPickerCollectionFlowLayout.m
//  Baking
//
//  Created by 王建斌 on 2016/11/25.
//  Copyright © 2016年 lileilei. All rights reserved.
//

#import "BDPhotoPickerCollectionFlowLayout.h"

@implementation BDPhotoPickerCollectionFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 4;
        self.minimumInteritemSpacing = 4;
        self.sectionInset = UIEdgeInsetsMake(4, 8, 4, 8);
        NSInteger maxCount = 4;
        CGFloat imaWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) - 12) / maxCount - 4;
        self.itemSize = CGSizeMake(imaWidth, imaWidth);
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *))
    {
        contentInset = self.collectionView.safeAreaInsets;
    }
    else
    {
        contentInset = self.collectionView.contentInset;
    }
    CGFloat contentHeight = contentInset.top + ceil(self.itemCount / 4.0) * self.itemSize.height + (ceil(self.itemCount / 4.0) + 1) * 4 + contentInset.bottom;
    CGFloat yoff = contentHeight - CGRectGetHeight(self.collectionView.frame) - contentInset.bottom - 20;//要-20才正常，原因暂时不明 
    CGPoint offset = CGPointMake(contentInset.left, MAX(yoff, - contentInset.top));
    [self.collectionView setContentOffset:offset];
}

@end
