//
//  BDPhotoAssetControllerTransition.m
//  test_photo
//
//  Created by 王建斌 on 16/11/9.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import "BDPhotoAssetControllerTransition.h"
#import "BDPhotoPickerAssetsCollectionController.h"
#import "BDPhotoPageController.h"

@implementation BDPhotoAssetControllerTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor whiteColor];
    if (self.operation == UINavigationControllerOperationPush)
    {
        BDPhotoPickerAssetsCollectionController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        BDPhotoPageController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        NSIndexPath *idx = [NSIndexPath indexPathForItem:toVC.currentIdx inSection:0];
        
        UIView *cellView = [fromVC.collectionView cellForItemAtIndexPath:idx];
        UIImageView *imav = (UIImageView*)[toVC.viewControllers[0].view viewWithTag:1];
        UIView *snapShot = [self resizedSnapShot:imav];
        
        CGPoint cellCenter = [fromVC.view convertPoint:cellView.center fromView:cellView.superview];
        CGPoint snapCenter = toVC.view.center;
        
        CGFloat startScale = MAX(CGRectGetWidth(cellView.frame) / CGRectGetWidth(snapShot.frame),
                                 CGRectGetHeight(cellView.frame) / CGRectGetHeight(snapShot.frame));
        CGFloat endScale = MIN(CGRectGetWidth(toVC.view.frame) / CGRectGetWidth(snapShot.frame),
                               CGRectGetHeight(toVC.view.frame) / CGRectGetHeight(snapShot.frame));
        
        CGFloat width = CGRectGetWidth(snapShot.bounds);
        CGFloat height = CGRectGetHeight(snapShot.bounds);
        CGFloat length = MIN(width, height);
        CGRect startBounds = CGRectMake((width - length) / 2, (height - length) / 2, length, length);
        
        UIView *mask = [[UIView alloc] initWithFrame:startBounds];
        mask.backgroundColor = [UIColor whiteColor];
        
        snapShot.transform = CGAffineTransformMakeScale(startScale, startScale);
        snapShot.layer.mask = mask.layer;
        snapShot.center = cellCenter;
        
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.alpha = 0;
        
        [containerView addSubview:toVC.view];
        [containerView addSubview:snapShot];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:0.75
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             fromVC.view.alpha = 0;
                             snapShot.transform = CGAffineTransformMakeScale(endScale, endScale);
                             snapShot.layer.mask.bounds = snapShot.bounds;
                             snapShot.center = snapCenter;
                             
                         } completion:^(BOOL finished) {
                             toVC.view.alpha = 1;
                             [snapShot removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
    }
    else if (self.operation == UINavigationControllerOperationPop)
    {
        BDPhotoPageController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        BDPhotoPickerAssetsCollectionController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        NSIndexPath *idx = [NSIndexPath indexPathForItem:fromVC.currentIdx inSection:0];
        
        UIView *cellView = [toVC.collectionView cellForItemAtIndexPath:idx];
        UIImageView *imav = (UIImageView*)[fromVC.viewControllers[0].view viewWithTag:1];
        UIView *snapShot = [self resizedSnapShot:imav];
        
        CGPoint cellCenter = [toVC.view convertPoint:cellView.center fromView:cellView.superview];
        CGPoint snapCenter = fromVC.view.center;
        
        CGFloat startScale = MIN(CGRectGetWidth(fromVC.view.frame) / CGRectGetWidth(snapShot.frame),
                                 CGRectGetHeight(fromVC.view.frame) / CGRectGetHeight(snapShot.frame));
        CGFloat endScale = MAX(CGRectGetWidth(cellView.frame) / CGRectGetWidth(snapShot.frame),
                                 CGRectGetHeight(cellView.frame) / CGRectGetHeight(snapShot.frame));
        
        CGFloat width = CGRectGetWidth(snapShot.bounds);
        CGFloat height = CGRectGetHeight(snapShot.bounds);
        CGFloat length = MIN(width, height);
        CGRect endBounds = CGRectMake((width - length) / 2, (height - length) / 2, length, length);
        
        UIView *mask = [[UIView alloc] initWithFrame:snapShot.bounds];
        mask.backgroundColor = [UIColor whiteColor];
        
        snapShot.transform = CGAffineTransformMakeScale(startScale, startScale);
        snapShot.layer.mask = mask.layer;
        snapShot.center = snapCenter;
        
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.alpha = 0;
        fromVC.view.alpha = 0;
        
        [containerView addSubview:toVC.view];
        [containerView addSubview:snapShot];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             toVC.view.alpha = 1;
                             snapShot.transform = CGAffineTransformMakeScale(endScale, endScale);
                             snapShot.layer.mask.bounds = endBounds;
                             snapShot.center = cellCenter;
                             
                         } completion:^(BOOL finished) {
                             [snapShot removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
    }
}

- (UIView*)resizedSnapShot:(UIImageView*)imav
{
    CGSize size = imav.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [[UIColor whiteColor] setFill];
    
    UIRectFill(((CGRect){{0,0},size}));
    
    [imav.image drawInRect:((CGRect){{0,0},size})];
    UIImage *imaResized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [[UIImageView alloc]initWithImage:imaResized];
}

@end
