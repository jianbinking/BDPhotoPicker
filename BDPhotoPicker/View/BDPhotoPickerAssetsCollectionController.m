//
//  BDPhotoPickerAssetsCollectionController.m
//  test_photo
//
//  Created by 王建斌 on 16/11/7.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import "BDPhotoPickerAssetsCollectionController.h"
#import "BDPhotoAssetCell.h"
#import "BDPhotoPickerAssetManager.h"
#import "BDPhotoPickerController.h"
#import "BDPhotoPageController.h"
#import "BDPhotoPickerImageManager.h"
#import "BDPhotoPickerCollectionFlowLayout.h"

@interface BDPhotoPickerAssetsCollectionController ()<BDPhotoPageDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (strong, nonatomic) BDPhotoPickerAssetManager *manager;

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation BDPhotoPickerAssetsCollectionController

static NSString * const reuseIdentifier = @"BDPhotoAssetCell";

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.manager = [[BDPhotoPickerAssetManager alloc]init];
        [self addNotificationObserver];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self setUpNavigationButtons];
    self.toolbarItems = [[self pickerController] customToolbarItems];
    self.title = self.collection.localizedTitle;
    self.manager.groupVC = self;
    self.manager.delegate = [self pickerController].delegate;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"BDPhotoAssetCell" bundle:NULL] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    
    __weak BDPhotoPickerAssetsCollectionController *wself = self;
    [self.manager loadAssetsFromCollection:self.collection Complete:^(BOOL success, NSError *err) {
        __strong BDPhotoPickerAssetsCollectionController *sself = wself;
        
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
        option.resizeMode = PHImageRequestOptionsResizeModeExact;
        option.networkAccessAllowed = NO;
        [[BDPhotoPickerImageManager sharedManager] startCachingImagesForAssets:sself.manager.arrAssets
                                                                    targetSize:((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).itemSize
                                                                   contentMode:PHImageContentModeAspectFill
                                                                       options:option];
        //滚动到collectionview底部
        ((BDPhotoPickerCollectionFlowLayout*)self.collectionView.collectionViewLayout).itemCount = self.manager.arrAssets.count;
        [sself.collectionView reloadData];
    }];
    [self.pickerController toggleDoneButton];
    
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[BDPhotoPickerImageManager sharedManager] stopCachingImagesForAllAssets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNavigationButtons
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtn:)];
}

- (void)leftBtn:(id)sender
{
    if ([self pickerController].delegate && [[self pickerController].delegate respondsToSelector:@selector(BDPhotoPickerControllerDidCancelPicking:)])
    {
        [[self pickerController].delegate BDPhotoPickerControllerDidCancelPicking:[self pickerController]];
    }
    [[self pickerController]dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - NSNotification Observer

- (void)addNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedAsset:) name:kBDPhotoPickerDidSelectedAssetNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deselectedAsset:) name:kBDPhotoPickerDidDeselectedAssetNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetsChanged:) name:kBDPhotoPickerAssetsChangedNotification object:nil];
}

- (void)selectedAsset:(NSNotification*)noti
{
    PHAsset *asset = noti.object;
    NSIndexPath *idx = [NSIndexPath indexPathForItem:[self.manager.arrAssets indexOfObject:asset] inSection:0];
    BDPhotoAssetCell *cell = (BDPhotoAssetCell*)[self.collectionView cellForItemAtIndexPath:idx];
    cell.assetSelected = YES;
}

- (void)deselectedAsset:(NSNotification*)noti
{
    PHAsset *asset = noti.object;
    NSIndexPath *idx = [NSIndexPath indexPathForItem:[self.manager.arrAssets indexOfObject:asset] inSection:0];
    BDPhotoAssetCell *cell = (BDPhotoAssetCell*)[self.collectionView cellForItemAtIndexPath:idx];
    cell.assetSelected = NO;
}

- (void)assetsChanged:(NSNotification*)noti
{
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.manager.arrAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BDPhotoAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell bindAsset:self.manager.arrAssets[indexPath.item]];
    cell.assetSelected = [[self pickerController].arrSelectedAssets containsObject:self.manager.arrAssets[indexPath.item]];
    
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [BDPhotoPickerImageManager sharedManager].allowsCachingHighQualityImages = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [BDPhotoPickerImageManager sharedManager].allowsCachingHighQualityImages = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHImageRequestOptions *opts = [[PHImageRequestOptions alloc] init];
    opts.networkAccessAllowed = NO;
    opts.synchronous = YES;
    [[BDPhotoPickerImageManager sharedManager] syncRequestImageForAsset:self.manager.arrAssets[indexPath.item]
                                                             targetSize:PHImageManagerMaximumSize
                                                            contentMode:PHImageContentModeDefault
                                                                options:opts
                                                          resultHandler:^(UIImage * _Nullable ima, NSDictionary * _Nullable dicInfo) {
                                                                    if (ima)
                                                                    {
                                                                        BDPhotoPageController *pagecontroller = [[BDPhotoPageController alloc]initWithAssets:self.manager.arrAssets];
                                                                        pagecontroller.bdDataSource = self;
                                                                        pagecontroller.currentIdx = indexPath.item;
                                                                        [self.navigationController pushViewController:pagecontroller animated:YES];
                                                                    }
                                                                    else
                                                                    {
                                                                        [self showSimpleWarningAlertWithTitle:@"OK"];
                                                                    }
                                                                }];
}

#pragma mark - BDPhotoPageDataSource

- (PHAsset*)assetForIndex:(NSInteger)idx
{
    return self.manager.arrAssets[idx];
}

- (BOOL)assetIsSelectedAtIndex:(NSInteger)idx
{
    return [[self pickerController].arrSelectedAssets containsObject:self.manager.arrAssets[idx]];
}

#pragma mark - getters

- (BDPhotoPickerController*)pickerController
{
    return (BDPhotoPickerController*)self.navigationController.parentViewController;
}

- (UICollectionView*)collectionView
{
    if (!_collectionView)
    {
        BDPhotoPickerCollectionFlowLayout *layout = [[BDPhotoPickerCollectionFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.view addSubview:_collectionView];
        _collectionView.frame = self.view.bounds;
    }
    return _collectionView;
}

@end
