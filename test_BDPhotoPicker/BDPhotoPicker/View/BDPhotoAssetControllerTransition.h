//
//  BDPhotoAssetControllerTransition.h
//  test_photo
//
//  Created by 王建斌 on 16/11/9.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BDPhotoAssetControllerTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) UINavigationControllerOperation operation;

@end
