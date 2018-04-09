//
//  BDPhotoPickerController.m
//  test_photo
//
//  Created by 王建斌 on 16/11/4.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import "BDPhotoPickerController.h"
#import "UIImage+BDPhotoPickerController.h"
#import "BDPhotoPickerGroupTableController.h"
#import "BDPhotoAssetControllerTransition.h"
#import "BDPhotoPageController.h"
#import "BDPhotoPickerCommon.h"

NSString * const kBDPhotoPickerDidSelectedAssetNotification = @"kBDPhotoPickerDidSelectedAssetNotification";
NSString * const kBDPhotoPickerDidDeselectedAssetNotification = @"kBDPhotoPickerDidDeselectedAssetNotification";
NSString * const kBDPhotoPickerAssetsChangedNotification = @"kBDPhotoPickerAssetsChangedNotification";

@interface BDPhotoPickerController ()<UINavigationControllerDelegate>

@property (strong, nonatomic) PHAssetCollection *collection;

@end

@implementation BDPhotoPickerController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _arrSelectedAssets = [NSMutableArray array];
        _strDefaultGroupName = @"";
        [self setUpNavigationController];
        [self addKeyValueObserver];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        ;
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)setUpNavigationController
{
    BDPhotoPickerGroupTableController *vc = [[BDPhotoPickerGroupTableController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    
    nav.delegate = self;
    [nav willMoveToParentViewController:self];
    
    nav.toolbar.backgroundColor = [UIColor whiteColor];
    nav.toolbar.opaque = NO;
    nav.toolbar.tintColor = [UIColor blackColor];
    nav.toolbarHidden = NO;
    
    nav.view.frame = self.view.bounds;
    [self.view addSubview:nav.view];
    [self addChildViewController:nav];
    [nav didMoveToParentViewController:self];
}

- (void)addKeyValueObserver
{
    [self addObserver:self forKeyPath:@"arrSelectedAssets"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:NULL];
}

- (void)removeKeyValueObserver
{
    [self removeObserver:self forKeyPath:@"arrSelectedAssets"];
}

- (NSArray<UIBarButtonItem*>*)customToolbarItems
{
    UIBarButtonItem *blankSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *btnCount = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCount.contentEdgeInsets = UIEdgeInsetsMake(2, 6, 2, 6);
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:@"0"];
    [strAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, strAttr.length)];
    [strAttr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, strAttr.length)];
    [btnCount setAttributedTitle:strAttr forState:UIControlStateNormal];
    btnCount.backgroundColor = BDPickerUIColorFromRGB(0xFFCB00);
    btnCount.clipsToBounds = YES;
    btnCount.userInteractionEnabled = NO;
    [btnCount sizeToFit];
    btnCount.layer.cornerRadius = CGRectGetHeight(btnCount.frame) / 2;
    UIBarButtonItem *lbl = [[UIBarButtonItem alloc]initWithCustomView:btnCount];
    
    
    UIBarButtonItem *confirm = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmSelected)];
    confirm.tintColor = BDPickerUIColorFromRGB(0x323232);
    confirm.enabled = NO;
    
    return [NSArray arrayWithObjects:blankSpace, lbl, confirm, nil];
    
}

- (void)toggleDoneButton
{
    UINavigationController *nav = [self.childViewControllers firstObject];
    BOOL enabled = self.arrSelectedAssets.count > 0;
    [nav.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBarButtonItem *confirm = obj.toolbarItems[2];
        UIButton *btnCount = obj.toolbarItems[1].customView;
        NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%li",self.arrSelectedAssets.count]];
        [strAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, strAttr.length)];
        [strAttr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, strAttr.length)];
        [btnCount setAttributedTitle:strAttr forState:UIControlStateNormal];
        [btnCount sizeToFit];
        confirm.enabled = enabled;
    }];
}

- (void)confirmSelected
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(BDPhotoPickerController:didFinishPickingWithAssets:)])
    {
        [self.delegate BDPhotoPickerController:self didFinishPickingWithAssets:self.arrSelectedAssets];
    }
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"arrSelectedAssets"])
    {
        [self toggleDoneButton];
        [self postAssetsChangedNotification:self.arrSelectedAssets];
    }
}

#pragma mark - post notification

- (void)postAssetsChangedNotification:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBDPhotoPickerAssetsChangedNotification object:sender];
}

- (void)postSelectAssetNotification:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBDPhotoPickerDidSelectedAssetNotification object:sender];
}

- (void)postDeselectAssetNotification:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBDPhotoPickerDidDeselectedAssetNotification object:sender];
}

#pragma mark - publicMethod

- (void)selectAsset:(PHAsset *)asset
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(BDPhotoPickerController:shouldSelectedAsset:)])
    {
        if (![self.delegate BDPhotoPickerController:self shouldSelectedAsset:asset])
        {
            return;
        }
    }
    [self.arrSelectedAssets addObject:asset];
    [self toggleDoneButton];
    [self postSelectAssetNotification:asset];
}

- (void)deselectAsset:(PHAsset *)asset
{
    [self.arrSelectedAssets removeObject:asset];
    [self toggleDoneButton];
    [self postDeselectAssetNotification:asset];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if ((operation == UINavigationControllerOperationPush && [toVC isKindOfClass:[BDPhotoPageController class]])
        || (operation == UINavigationControllerOperationPop && [fromVC isKindOfClass:[BDPhotoPageController class]]))
    {
        BDPhotoAssetControllerTransition *transition = [[BDPhotoAssetControllerTransition alloc]init];
        transition.operation = operation;
        return transition;
    }
    return nil;
}

#pragma mark - getters



- (void)dealloc
{
    [self removeKeyValueObserver];
}

@end
