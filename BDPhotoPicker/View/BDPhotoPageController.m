//
//  BDPhotoPageController.m
//  test_photo
//
//  Created by 王建斌 on 16/11/8.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import "BDPhotoPageController.h"
#import "BDPhotoPickerImageManager.h"
#import "BDPhotoPickerCommon.h"
#import "BDPhotoPickerController.h"

#define kBDPhotoPickerNotificationScrollTapped @"kBDPhotoPickerNotificationScrollTapped"

@interface BDPhotoPageController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (assign, nonatomic) BOOL currentAssetIsSelected;
@property (assign, nonatomic) BOOL statusBarHidden;

@end

@implementation BDPhotoPageController

- (instancetype)initWithAssets:(NSArray<PHAsset*>*)assets
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:@{UIPageViewControllerOptionInterPageSpacingKey:@30.f}];
    if (self)
    {
        self.arrAssets = assets;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewTapped:) name:kBDPhotoPickerNotificationScrollTapped object:nil];
    self.toolbarItems = [[self pickerController] customToolbarItems];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"BDPhotoPickerCheckMark_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rightBarButtonTapped)];
    [self updateBarItems];
    [self.pickerController toggleDoneButton];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateBarItems
{
    if (self.bdDataSource && [self.bdDataSource respondsToSelector:@selector(assetIsSelectedAtIndex:)])
    {
        self.currentAssetIsSelected = [self.bdDataSource assetIsSelectedAtIndex:self.currentIdx];
        NSString *strImaName = [NSString stringWithFormat:@"BDPhotoPickerCheckMark_%@",(self.currentAssetIsSelected ? @"s" : @"n")];
        [self.navigationItem.rightBarButtonItem setImage:[[UIImage imageNamed:strImaName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
}

- (void)rightBarButtonTapped
{
    if (self.currentAssetIsSelected)
    {
        [[self pickerController] deselectAsset:[self.bdDataSource assetForIndex:self.currentIdx]];
    }
    else
    {
        [[self pickerController] selectAsset:[self.bdDataSource assetForIndex:self.currentIdx]];
    }
    [self updateBarItems];
}

#pragma mark - Notification Observer

- (void)scrollViewTapped:(NSNotification*)noti
{
    UITapGestureRecognizer *tap = noti.object;
    if (tap.numberOfTapsRequired == 1)
    {
        if (self.statusBarHidden)
        {
            [self showNavBar];
        }
        else
        {
            [self hideNavBar];
        }
    }
}

- (void)showNavBar
{
    self.statusBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
    [UIView animateWithDuration:.2 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.navigationBar.alpha = 1;
        self.navigationController.toolbar.alpha = 1;
        self.view.backgroundColor = [UIColor whiteColor];
    }];
}

- (void)hideNavBar
{
    self.statusBarHidden = YES;
    [UIView animateWithDuration:.2 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.navigationBar.alpha = 0;
        self.navigationController.navigationBarHidden = YES;
        self.navigationController.toolbar.alpha = 0;
        self.navigationController.toolbarHidden = YES;
        self.view.backgroundColor = [UIColor blackColor];
    }];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = ((BDPhotoPageItemController*)viewController).index;
    if (index < (self.arrAssets.count - 1))
    {
        BDPhotoPageItemController *itemVC = [[BDPhotoPageItemController alloc] init];
        itemVC.index = index + 1;
        itemVC.bdDataSource = self.bdDataSource;
        return itemVC;
    }
    return nil;
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((BDPhotoPageItemController*)viewController).index;
    if (index > 0)
    {
        BDPhotoPageItemController *itemVC = [[BDPhotoPageItemController alloc] init];
        itemVC.index = index - 1;
        itemVC.bdDataSource = self.bdDataSource;
        return itemVC;
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        BDPhotoPageItemController *itemVC = pageViewController.viewControllers[0];
        _currentIdx = itemVC.index;
        self.title = [NSString stringWithFormat:@"%li/%li",_currentIdx+1,self.arrAssets.count];
        [self updateBarItems];
        if (!itemVC.bDownloadSuccess)
        {
            [self showSimpleWarningAlertWithTitle:@"OK"];
        }
        self.navigationItem.rightBarButtonItem.enabled = itemVC.bDownloadSuccess;
    }
}

#pragma mark - getters

- (void)setCurrentIdx:(NSInteger)currentIdx
{
    _currentIdx = currentIdx;
    if (currentIdx >= 0 && currentIdx < self.arrAssets.count)
    {
        BDPhotoPageItemController *itemVC = [[BDPhotoPageItemController alloc] init];
        itemVC.index = currentIdx;
        itemVC.bdDataSource = self.bdDataSource;
        [self setViewControllers:@[itemVC]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
        self.title = [NSString stringWithFormat:@"%li/%li",currentIdx+1,self.arrAssets.count];
    }
}


- (BDPhotoPickerController*)pickerController
{
    return (BDPhotoPickerController*)self.navigationController.parentViewController;
}

@end



@interface BDPhotoPageItemController()<UIScrollViewDelegate>

@property (assign, nonatomic) CGSize imageSize;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;



@end

@implementation BDPhotoPageItemController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayImage];
    [self addGestures];
}

#pragma mark - gesture

- (void)addGestures
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [self.scrollView addGestureRecognizer:singleTap];
    [self.scrollView addGestureRecognizer:doubleTap];
}

- (void)singleTapped:(UITapGestureRecognizer*)tap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBDPhotoPickerNotificationScrollTapped object:tap];
}

- (void)doubleTapped:(UITapGestureRecognizer*)tap
{
    if (self.scrollView.zoomScale == self.scrollView.maximumZoomScale)
    {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
    else
    {
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    }
}



#pragma mark - layouts

- (void)displayImage
{
    self.scrollView.zoomScale = 1;
    if (self.bdDataSource && [self.bdDataSource respondsToSelector:@selector(assetForIndex:)])
    {
        PHAsset *asset = [self.bdDataSource assetForIndex:self.index];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.synchronous = YES;
        options.networkAccessAllowed = NO;
        @weakify(self);
        [[BDPhotoPickerImageManager sharedManager] asyncRequestImageForAsset:asset
                                                                  targetSize:PHImageManagerMaximumSize
                                                                 contentMode:PHImageContentModeDefault
                                                                     options:options
                                                               resultHandler:^(UIImage * _Nullable ima, NSDictionary * _Nullable dicInfo) {
                                                                   @strongify(self);
                                                                   [self.imageView removeFromSuperview];
                                                                   self.imageView = nil;
                                                                   if (ima &&
                                                                       ![[dicInfo objectForKey:PHImageCancelledKey] boolValue] &&
                                                                       ![[dicInfo objectForKey:PHImageErrorKey] boolValue] &&
                                                                       ![[dicInfo objectForKey:PHImageResultIsDegradedKey] boolValue])
                                                                   {
                                                                       self.bDownloadSuccess = YES;
                                                                       self.imageView = [[UIImageView alloc]initWithImage:ima];
                                                                   }
                                                                   else
                                                                   {
                                                                       self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, asset.pixelWidth, asset.pixelHeight)];
                                                                       self.imageView.image = [UIImage imageNamed:@"home_defaultimage"];
                                                                       self.bDownloadSuccess = NO;
                                                                   }
                                                                   self.imageView.tag = 1;
                                                                   [self.scrollView addSubview:self.imageView];
                                                                   [self resizeImage:self.imageView.frame.size];
                                                               }];
    }
}

- (void)resizeImage:(CGSize)size
{
    self.imageSize = size;
    self.scrollView.contentSize = size;
    
    CGSize boundsSize = self.view.bounds.size;
    
    CGFloat xScale = boundsSize.width / self.imageSize.width;
    CGFloat yScale = boundsSize.height / self.imageSize.height;
    
    CGFloat miniScale = MIN(xScale, yScale);
    CGFloat maxScale = miniScale * 2;
    
    self.scrollView.minimumZoomScale = miniScale;
    self.scrollView.maximumZoomScale = maxScale;
    
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    [self layoutImage];
}

- (void)layoutImage
{
    CGSize boundsSize = self.view.bounds.size;
    CGRect frame2Center = self.imageView.frame;
    
    if (frame2Center.size.width < boundsSize.width)
    {
        frame2Center.origin.x = (boundsSize.width - frame2Center.size.width) / 2;
    }
    else
    {
        frame2Center.origin.x = 0;
    }
    if (frame2Center.size.height < boundsSize.height)
    {
        frame2Center.origin.y = (boundsSize.height - frame2Center.size.height) / 2;
    }
    else
    {
        frame2Center.origin.y = 0;
    }
    self.imageView.frame = frame2Center;
}


#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self layoutImage];
}

#pragma mark - getters

- (UIScrollView*)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bouncesZoom = YES;
        _scrollView.delegate = self;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)dealloc
{
//    [self.parentViewController hideHud];
}

@end
